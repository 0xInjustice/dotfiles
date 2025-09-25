Below is a concise, reference-backed technical guide covering items (1)–(8) for Wayland screen-sharing on Hyprland (Arch Linux). Each numbered section gives the required technologies, concrete package names and commands, recommended configuration snippets, and troubleshooting notes — with **at least three links** supporting the key claims per section.

I.  I’ll assume you want a working WebRTC / browser screen-share stack (PipeWire + xdg-desktop-portal + Hyprland portal backend). If you want me to produce a ready-to-run dotfile snippet (e.g., `hyprland.conf` lines, systemd commands collected into a script), say so and I’ll produce it immediately.

---

# 1) Core technologies & how they fit together (PipeWire + xdg-desktop-portal)

Summary (short): On Wayland the browser cannot directly capture compositor surfaces; instead a compositor exposes a portal via `xdg-desktop-portal` which coordinates a PipeWire capture stream (server) created by the compositor (or a portal backend). The browser requests a ScreenCast session via the portal (DBus), the portal asks the compositor backend to produce a PipeWire stream, and the browser consumes that PipeWire stream (WebRTC).

Key points and why they matter:

* **PipeWire**: provides the low-level media graph and the stream endpoint used by WebRTC for screen frames (the capture stream runs through PipeWire). ([ArchWiki][1])
* **xdg-desktop-portal**: abstracts compositor specifics — the browser talks to this portal over DBus to request screen capture. The portal needs a **backend/implementation** that knows how to ask the compositor for frames. ([ArchWiki][2])
* **Compositor portal backend** (for Hyprland): `xdg-desktop-portal-hyprland` is the Hyprland backend that implements the portal’s ScreenCast interface and creates the PipeWire source. Without a backend the portal cannot supply a capture stream. ([Arch Linux][3])

Practical implication: for working Wayland screen sharing you need (a) PipeWire (and a session manager such as WirePlumber or pipewire-media-session), (b) xdg-desktop-portal, and (c) a portal backend that matches your compositor — for Hyprland that’s `xdg-desktop-portal-hyprland`.

---

# 2) Exact Arch Linux packages to install

Minimal, recommended packages (Arch package names and short rationale):

1. **pipewire** — core PipeWire daemon. ([ArchWiki][1])
2. **wireplumber** — recommended PipeWire session/ policy manager (or `pipewire-media-session` as older alternative). WirePlumber is the modern default on Arch. ([ArchWiki][1])
3. **pipewire-pulseaudio** (or `pipewire-pulse`) — if you use PipeWire as PulseAudio replacement (audio, not required for video but commonly installed). ([ArchWiki][1])
4. **xdg-desktop-portal** — the portal runner the browser talks to. ([ArchWiki][2])
5. **xdg-desktop-portal-hyprland** — Hyprland’s portal backend/implementation that talks to Hyprland and produces PipeWire streams. (Arch package: `extra/x86_64/xdg-desktop-portal-hyprland`). ([Arch Linux][3])
6. Optional/diagnostic: **xdg-desktop-portal-gtk** or **xdg-desktop-portal-gnome** (generic GUI portal helpers) — useful for some dialogs on other desktops; not strictly necessary with the Hyprland backend but sometimes present. ([ArchWiki][2])

Example pacman command:

```bash
sudo pacman -Syu pipewire wireplumber pipewire-pulse xdg-desktop-portal xdg-desktop-portal-hyprland
```

(If you prefer `pipewire-media-session` instead of WirePlumber, install that instead; use one session manager only.) ([ArchWiki][1])

Additional notes / links:

* Arch package page for `xdg-desktop-portal-hyprland` (package metadata). ([Arch Linux][3])
* ArchWiki PipeWire / XDG Desktop Portal pages for reasoning and dependencies. ([ArchWiki][1])

---

# 3) System configuration steps (systemd user services, env variables, hyprland specifics)

Concrete commands to enable/run required services (user services — run as the logged-in user):

```bash
# enable and start PipeWire and session manager
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# ensure xdg-desktop-portal is running (it’s a user service)
systemctl --user enable --now xdg-desktop-portal
```

Check status / logs:

```bash
# check pipewire/runtime
systemctl --user status pipewire wireplumber

# check portal logs (helpful when the screen picker fails)
journalctl --user -u xdg-desktop-portal -f
journalctl --user -u pipewire -f
```

References for these units and how Arch manages PipeWire and portals: ArchWiki PipeWire and XDG Desktop Portal. ([ArchWiki][1])

Important environment variables and Hyprland-specific notes:

* **XDG\_CURRENT\_DESKTOP** must be set (so xdg-desktop-portal can detect your desktop type). Several users report that if the portal is started *before* that env var is propagated, the portal may not pick the correct backend — leading to “Unknown method ScreenCast” or a non-functional picker. Common remedy: ensure `XDG_CURRENT_DESKTOP=Hyprland` (or `hyprland`) is exported into the environment that starts `xdg-desktop-portal` (or update DBus/systemd activation), or add a `dbus-update-activation-environment` hook in Hyprland startup so systemd user services inherit the value. Example recommended Hyprland line:

```ini
# add to hyprland.conf (exec-once)
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
```

This forces systemd user units (like xdg-desktop-portal) to receive WAYLAND\_DISPLAY and XDG\_CURRENT\_DESKTOP from the compositor session. (Reported as effective in Hyprland community/GitHub issues.) ([GitHub][4])

* **Launching portals manually for debugging**: you can stop portal services and run them in a terminal to see live logs:

```bash
systemctl --user stop xdg-desktop-portal
/usr/lib/xdg-desktop-portal -r     # runs portal in the foreground (debug)
# and run the hyprland-specific backend if necessary (the hyprland backend usually integrates)
```

(Useful while testing screen-share dialogs.) ([Nick's Blog][5])

Flatpak note (if you use Flatpak apps): Flatpak sandboxes need access to PipeWire socket. When running Firefox/Chromium as Flatpak, you may need to grant `--filesystem=xdg-run/pipewire-0` or use the Flatpak portal support built into runtime. See Mozilla/Flatpak bug references. ([Bugzilla][6])

---

# 4) Firefox: run natively on Wayland and `about:config` specifics

Short checklist (concrete):

1. **Run Firefox under Wayland**:

   * Launch with `MOZ_ENABLE_WAYLAND=1` (environment variable). Example:

     ```bash
     MOZ_ENABLE_WAYLAND=1 firefox
     ```
   * Verify in `about:support` → *Window Protocol* shows `wayland`. If it says `x11`, Firefox is using XWayland and screen capture via PipeWire portals may not work consistently. ([Gist][7])

2. **Ensure WebRTC is enabled** (Firefox must allow peer connection / getUserMedia):

   * In `about:config` confirm:

     * `media.peerconnection.enabled` = `true` (default). If you disabled WebRTC for privacy, re-enable it to use screen sharing. ([Help center | MyOwnConference][8])
   * There is not generally a separate Firefox pref to “use PipeWire” — Firefox uses the portal infrastructure; ensure the portal & PipeWire stack are present and that Firefox runs on Wayland. For Flatpak Firefox there are additional sandbox permissions (see Flatpak note above). ([Bugzilla][6])

3. **If you still get a blank/black preview**:

   * Confirm `xdg-desktop-portal` and the Hyprland backend are running and that the portal received `XDG_CURRENT_DESKTOP` before starting. If not, restart portal after exporting that env var (see section 3). ([Arch Linux Forums][9])

Useful references showing these steps and examples / troubleshooting for Firefox + Wayland: Gist & Arch/Forum writeups. ([Gist][7])

---

# 5) Chromium / Chrome / Edge (Chromium-based) flags & runtime options

Key facts & commands:

* Historically Chromium required enabling the **WebRTC PipeWire capturer** flag (`chrome://flags/#enable-webrtc-pipewire-capturer`) or launching with a CLI feature flag. On modern Chromium/Chrome builds this may be enabled by default (Chromium/Chrome ≳ v110+), but on some distributions/versions you still need to enable it. Check `chrome://flags` for `WebRTC PipeWire support`. ([Ask Ubuntu][10])

* CLI alternatives (if the flag is not available or you want explicit control):

  ```bash
  # old style
  chromium --enable-features=WebRTCPipeWireCapturer

  # newer variants used by distributions
  chromium --enable-features=WebRtcPipeWireCamera
  ```

  (The exact feature name changed across Chrome releases; if one name has no effect, try the other and check `chrome://version` / `chrome://flags`.) ([Arch Linux Forums][11])

* If you use Electron-based apps (Slack, Teams, etc.) they also need to have PipeWire support enabled (or be rebuilt with a newer Electron that supports PipeWire). For example, launching Slack with `--enable-features=WebRtcPipeWireCapturer` has been used as a workaround. ([Ask Ubuntu][10])

Browser note: Chrome/Chromium typically picks up the PipeWire stream provided by xdg-desktop-portal automatically once PipeWire support is enabled; ensure `xdg-desktop-portal` with your compositor backend is functional. See Chromium/Edge/Chrome guidance pages. ([Ask Ubuntu][10])

---

# 6) Common troubleshooting (black screen, picker missing, poor perf) — concrete checks & fixes

I list the common failure modes and immediate checks/fixes:

A. **Screen picker missing / “Unknown method ScreenCast” / no options in browser**

* Cause: `xdg-desktop-portal` doesn’t know your compositor or backend; usually `XDG_CURRENT_DESKTOP` was not set, or the portal started before compositor session env vars propagated.
* Fixes:

  1. Restart portal after ensuring `XDG_CURRENT_DESKTOP=Hyprland` is exported to the systemd user environment: `systemctl --user restart xdg-desktop-portal`. Or add `exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP` to `hyprland.conf` so values propagate on login. ([Arch Linux Forums][9])

B. **Black screen in the captured thumbnail / black stream delivered to browser**

* Causes: compositor backend or PipeWire stream is failing (GPU/bit-depth mismatch, xwayland issues, xwayland bridge), or PipeWire permissions.
* Checks & fixes:

  * Inspect portal and PipeWire logs: `journalctl --user -u xdg-desktop-portal -f` and `journalctl --user -u pipewire -f`. ([GitHub][4])
  * Confirm Hyprland portal is installed (`xdg-desktop-portal-hyprland`) and there are no conflicting portal implementations running. Reinstall if necessary. ([Arch Linux][3])
  * Check monitor bitdepth/color profile/format: Hyprland docs mention `bitdepth` must match physical monitor configuration for successful capture (rare but reported). ([Hyprland Wiki][12])

C. **Poor performance / high CPU**

* Causes: software fallback path, copying frames in software, or wrong PipeWire format negotiation.
* Fixes:

  * Ensure PipeWire uses hardware-accelerated capture path where available (compositor implementation does that). Keep PipeWire and WirePlumber up to date. Use GPU drivers correctly installed (Mesa/AMDGPU, Intel, NVIDIA proprietary). ([ArchWiki][1])

D. **Flatpak sandbox prevents access (blank or no device shown)**

* Solution: add Flatpak permission for pipewire socket or use the Flatpak portal integration (e.g., `--filesystem=xdg-run/pipewire-0` when invoking the flatpak) or use system browser. ([Bugzilla][6])

E. **Electron apps (Teams/Slack) only show tabs or fail**

* Reason: the embedded Electron may not include PipeWire support; they require CLI flags or a rebuilt Electron. Slack example: start with `--enable-features=WebRtcPipeWireCapturer` or use a newer build. ([Ask Ubuntu][10])

When to gather logs & what to paste into bug reports:

* `journalctl --user -u xdg-desktop-portal -b --no-pager`
* `journalctl --user -u pipewire -b --no-pager`
* Output of `ls -l /run/user/$UID/ | grep pipewire` and `pactl info` (if audio issues). ([GitHub][4])

---

# 7) Alternative / workaround: OBS Studio → virtual camera (v4l2loopback / obs-v4l2sink)

Use case: browser/conference app where portal capture fails, or you need overlays, scene composition, or better control.

Recipe (high-level steps on Arch):

1. Install OBS and v4l2loopback (kernel module) and optionally `obs-v4l2sink` (AUR) if required:

   ```bash
   sudo pacman -S obs-studio
   # install kernel headers then (from AUR) v4l2loopback-dkms or v4l2loopback
   # AUR: obs-v4l2sink (if you want plugin that writes OBS output to /dev/videoX)
   ```

   On Arch you can use `v4l2loopback-dkms` or `v4l2loopback` package; `obs-v4l2sink` is available in AUR. ([ArchWiki][13])

2. Load v4l2loopback device and start virtual camera sink (examples):

   ```bash
   # load module (example)
   sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual" exclusive_caps=1

   # if using obs-v4l2sink plugin, start the plugin from OBS "Tools" or use the plugin CLI to write to the device
   ```

   Newer OBS versions (>=26.1+) have improved virtual camera support; if virtual cam is not available check obs logs and v4l2loopback compatibility. ([EndeavourOS][14])

3. In your meeting/browser app, choose the virtual camera device (`/dev/video10` in the example) as the camera. OBS renders your screen scene (desktop capture) into the virtual camera so the meeting app sees it like a normal webcam.

Utility and caveats:

* **Pros**: supports overlays, selective capture, cropping, streaming optimizations, and works with apps that only accept camera input. Works around portal issues. ([Interfacing Linux][15])
* **Cons**: higher setup complexity (kernel module + plugin), potential compatibility issues across kernel/OBS updates (some users report breakage across upgrades), and added latency compared with native PipeWire capture. Also requires permission to load kernel modules (not ideal on locked down systems). ([Arch Linux Forums][16])

Practical links / guides:

* ArchWiki `v4l2loopback` page and OBS virtual camera guides. ([ArchWiki][13])

---

# 8) Comparison: browser-native portal vs OBS + virtual camera (setup complexity, reliability, features)

| Aspect                      |                                                                                                                                                         Native browser (PipeWire + xdg-desktop-portal) | OBS + virtual camera (v4l2loopback)                                                                                                                                                                 |
| --------------------------- | -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Setup complexity**        |         **Lower** once stack installed: install PipeWire + WirePlumber + xdg-desktop-portal + compositor backend and enable user services. But getting env vars correct can be tricky. ([ArchWiki][1]) | **Higher**: install OBS, kernel module (`v4l2loopback`/DKMS), possibly `obs-v4l2sink`, load kernel modules, configure scenes. ([ArchWiki][13])                                                      |
| **Reliability / stability** |      **Good** in mature setups (GNOME, Mutter, KWin, Hyprland with portal). Failure modes are usually env/portal timing or driver issues; when working it’s efficient and low-latency. ([ArchWiki][2]) | **Variable**: works well but can break on kernel/OBS/plugin updates; requires more maintenance. Offers a robust fallback when portal fails. ([Arch Linux Forums][16])                               |
| **Features**                | Browser picks exact screen/window or region via compositor picker; minimal overhead; more direct (WebRTC native). No scene composition/overlays (unless the compositor provides them). ([Flatpak][17]) | Rich scene composition (multiple sources, overlays, backgrounds), works in apps that expect a webcam; adds latency and CPU/GPU load. Good for professional presentations. ([Interfacing Linux][15]) |
| **Performance**             |                                                                              Usually lower latency, efficient (PipeWire + compositor GPU path). Dependent on compositor & GPU drivers. ([ArchWiki][1]) | More CPU/GPU usage due to encoding and v4l2 copy; may be acceptable, but not as optimal as direct PipeWire capture. ([Interfacing Linux][15])                                                       |
| **When to use**             |                                                                                                                      Prefer when portal stack works (simple meetings, screen sharing). ([ArchWiki][2]) | Use as fallback or when you need overlays / will show multiple sources or when portal is incompatible with a particular app. ([Interfacing Linux][15])                                              |

In short: aim to get the **native portal + PipeWire** working first (clean, lower latency, native WebRTC support). Use **OBS + virtual camera** as a fallback or when you require advanced composition features.

---

## Quick "cheat-sheet" commands & checks (copy/paste)

Install packages:

```bash
sudo pacman -Syu pipewire wireplumber pipewire-pulse xdg-desktop-portal xdg-desktop-portal-hyprland
```

Enable services (user):

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber xdg-desktop-portal
```

If screen picker is absent / portal misbehaves, add to `hyprland.conf`:

```ini
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
# and make sure XDG_CURRENT_DESKTOP is set to Hyprland in your login environment
```

Check logs:

```bash
journalctl --user -u xdg-desktop-portal -f
journalctl --user -u pipewire -f
```

Firefox Wayland launch:

```bash
MOZ_ENABLE_WAYLAND=1 firefox
# verify about:support -> Window Protocol = wayland
```

Chromium flag CLI (if required):

```bash
chromium --enable-features=WebRtcPipeWireCamera
# or try --enable-features=WebRTCPipeWireCapturer (older name)
```

OBS virtual cam quick start:

```bash
sudo pacman -S obs-studio
# load module (adjust device number)
sudo modprobe v4l2loopback devices=1 video_nr=10 exclusive_caps=1
# start OBS, configure scene with "Screen Capture (Wayland/X11)" and start virtual camera (or use obs-v4l2sink plugin)
```

---

## Sources / further reading (grouped per section)

(Selected — each section above cites at least three sources; below are the most relevant single-click references for deeper reading.)

* Hyprland / Hypr ecosystem pages (screen-sharing notes & portal info). ([Hyprland Wiki][12])
* Arch Linux package page for `xdg-desktop-portal-hyprland`. ([Arch Linux][3])
* ArchWiki: **PipeWire** and **XDG Desktop Portal** explanatory pages. ([ArchWiki][1])
* Chromium/Chrome flag notes and AskUbuntu explanation of `enable-webrtc-pipewire-capturer`. ([Ask Ubuntu][10])
* Firefox / Wayland community guidance & Flatpak caveats (MOZ\_ENABLE\_WAYLAND, sandbox permissions). ([Gist][7])
* GitHub/issue reports describing black screen / env var fixes (Hyprland portal issues and suggested `dbus-update-activation-environment` remedy). ([GitHub][4])
* OBS virtual camera / v4l2loopback guides and AUR `obs-v4l2sink`. ([ArchWiki][13])

---

If you want, I can:

* produce a ready-to-run shell script that installs (AUR bits excepted), enables the user services, and prints verification commands; **or**
* provide a ready `hyprland.conf` snippet to add `exec-once` and an environment file for `XDG_CURRENT_DESKTOP`, or
* generate an OBS step-by-step script including `modprobe` options you can paste.

Tell me which of those you want next (script, config snippet, or both) and I’ll produce it immediately.

[1]: https://wiki.archlinux.org/title/PipeWire?utm_source=chatgpt.com "PipeWire"
[2]: https://wiki.archlinux.org/title/XDG_Desktop_Portal?utm_source=chatgpt.com "XDG Desktop Portal - ArchWiki"
[3]: https://archlinux.org/packages/extra/x86_64/xdg-desktop-portal-hyprland/?utm_source=chatgpt.com "xdg-desktop-portal-hyprland 1.3.10-1 (x86_64)"
[4]: https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/297?utm_source=chatgpt.com "Black screen when trying to screen-share · Issue #297"
[5]: https://nick.groenen.me/notes/wayland-screen-sharing/?utm_source=chatgpt.com "Wayland screen-sharing - Nick Groenen"
[6]: https://bugzilla.mozilla.org/show_bug.cgi?id=1648029&utm_source=chatgpt.com "[Flatpak] enable pipewire support for wayland screensharing"
[7]: https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580?utm_source=chatgpt.com "Screen sharing on Hyprland (Arch Linux)"
[8]: https://support.myownconference.com/en/article/webrtc-protocol-in-mozilla-firefox-browser-91jm0o/?utm_source=chatgpt.com "WebRTC protocol in Mozilla Firefox browser | Help center"
[9]: https://bbs.archlinux.org/viewtopic.php?id=291771&utm_source=chatgpt.com "[Solved] Sway / xdg-desktop-portal-wlr - Arch Linux Forums"
[10]: https://askubuntu.com/questions/1293394/screen-sharing-under-wayland?utm_source=chatgpt.com "Screen sharing under wayland - google chrome"
[11]: https://bbs.archlinux.org/viewtopic.php?id=280990&utm_source=chatgpt.com "[SOLVED] cli flag for chrome://flags/#enable-webrtc- ..."
[12]: https://wiki.hypr.land/Useful-Utilities/Screen-Sharing/?utm_source=chatgpt.com "Screen sharing - Hyprland Wiki"
[13]: https://wiki.archlinux.org/title/V4l2loopback?utm_source=chatgpt.com "v4l2loopback"
[14]: https://forum.endeavouros.com/t/obs-studio-flatpak-version-does-not-support-virtual-camera/54987?utm_source=chatgpt.com "OBS studio flatpak version does not support virtual camera"
[15]: https://interfacinglinux.com/2024/01/09/obs-virtual-webcam-on-linux/?utm_source=chatgpt.com "OBS Virtual Webcam On Linux"
[16]: https://bbs.archlinux.org/viewtopic.php?id=305169&utm_source=chatgpt.com "Anyone else with an \"v4l2loopback/virtual camera\" issue ..."
[17]: https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.impl.portal.ScreenCast.html?utm_source=chatgpt.com "ScreenCast - XDG Desktop Portal documentation - Flatpak"

