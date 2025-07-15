````markdown
# Arch Linux Setup: Btrfs + Full Disk Encryption + NVIDIA GTX 1650 + Hyprland

## 1. Pacman & Multilib

Enable the **multilib** repo in `/etc/pacman.conf`:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```
````

Then update:

```bash
sudo pacman -Syu
```

Install NVIDIA driver and optional deps:

```bash
sudo pacman -S nvidia nvidia-utils \
             lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader \
             nvidia-settings
```

_(If `lib32‑nvidia‑utils` or `lib32‑vulkan‑icd-loader` errors occur, ensure multilib is enabled.)_

## 2. Initramfs (`mkinitcpio.conf`)

Edit `/etc/mkinitcpio.conf`:

```bash
MODULES=(btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

- Including **btrfs** ensures proper mounting of the encrypted root (especially with Btrfs root subvolumes).
- The order **does not matter**: modules are loaded by name, not sequence.([Reddit][1], [imoize.github.io][2], [Unix & Linux Stack Exchange][3])
- If using multi-disk Btrfs (RAID), consider using the `btrfs` HOOK instead of `filesystems`.([Arch Wiki][4])

Typical `HOOKS` sequence for encrypted Btrfs root:

```ini
HOOKS=(base udev autodetect modconf block encrypt filesystems)
# or if only single-device btrfs: replace `filesystems` with `btrfs`
```

After editing, regenerate initramfs:

```bash
sudo mkinitcpio -P
```

## 3. Bootloader Kernel Args

### For GRUB (`/etc/default/grub`):

```ini
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 cryptdevice=UUID=<…>:cryptlvm root=/dev/mapper/cryptlvm nvidia_drm.modeset=1"
```

- **Order doesn’t matter**: `cryptdevice=…` and `nvidia_drm.modeset=1` can be in any order.([Arch Wiki][5], [Reddit][6])
- Use underscore syntax: `nvidia_drm.modeset=1` is preferred over a hyphen.([Reddit][7])

Then update GRUB:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### For systemd‑boot:

Add the same parameters in your kernel line (`/etc/kernel/cmdline`) and then:

```bash
sudo reinstall-kernels
```

## 4. Optional: Pacman Hook for NVIDIA

If you’re using `nvidia` (non-DKMS):

Create `/etc/pacman.d/hooks/nvidia.hook`:

```ini
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```

With `nvidia-dkms`, this isn’t needed—`mkinitcpio -P` triggers automatically.([Arch Wiki][8], [GitHub][9])

## 5. Hyprland Environment (Wayland)

In your Hyprland config (`~/.config/hypr/hyprland.conf`), add:

```ini
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_EGL_NO_MODIFIERS,1
```

---

## ✅ Quick Summary

| Component        | Key Settings                                                          |
| ---------------- | --------------------------------------------------------------------- |
| **MODULES**      | `btrfs`, `nvidia`, `nvidia_modeset`, `nvidia_uvm`, `nvidia_drm`       |
| **HOOKS**        | `base udev autodetect modconf block encrypt filesystems` (or `btrfs`) |
| **Kernel Args**  | `cryptdevice=UUID=… root=… nvidia_drm.modeset=1`                      |
| **Pacman Hook**  | Recommended for `nvidia`, not needed for `nvidia-dkms`                |
| **Hyprland ENV** | Set Wayland + NVIDIA env vars in config file                          |

---

### 🔁 Rebuild & Reboot

After installation or driver updates:

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg   # if using GRUB
reboot
```

---

### 📦 Validation Commands

```bash
nvidia-smi
echo $XDG_SESSION_TYPE  # should output "wayland"
```

---

Keep this file handy—it covers encrypted Btrfs root, Nvidia KMS via mkinitcpio, and Hyprland-specific environment setup for NVIDIA GPUs.
Happy installing! 🚀

```

---
```
