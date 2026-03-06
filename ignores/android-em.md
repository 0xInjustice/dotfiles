---

## 1. Install required base packages

```bash
sudo pacman -S jdk17-openjdk unzip wget
```

Set system Java:

```bash
sudo archlinux-java set java-17-openjdk
```

Verify:

```bash
java -version
```

---

## 2. Create SDK directory

```bash
mkdir -p $HOME/Android/Sdk
cd $HOME/Android/Sdk
```

---

## 3. Install official Android Command Line Tools

Download Linux command line tools from Google (ZIP).

Then:

```bash
unzip commandlinetools-linux-*.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/
rm -r cmdline-tools
```

Final layout must be:

```
~/Android/Sdk/cmdline-tools/latest/bin/sdkmanager
```

Verify:

```bash
ls ~/Android/Sdk/cmdline-tools/latest/bin
```

---

## 4. Configure environment (permanent)

Add to `~/.zshrc`:

```bash
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$HOME/Android/Sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$JAVA_HOME/bin:$PATH
```

Reload:

```bash
source ~/.zshrc
```

Verify:

```bash
which sdkmanager
which emulator
```

---

## 5. Accept licenses

```bash
sdkmanager --licenses
```

---

## 6. Install required SDK components

Example for API 31:

```bash
sdkmanager \
"platform-tools" \
"emulator" \
"platforms;android-31" \
"system-images;android-31;google_apis;x86_64"
```

---

## 7. Create AVD

List devices:

```bash
avdmanager list device
```

Create AVD:

```bash
avdmanager create avd \
-n Pixel_6_API_31 \
-k "system-images;android-31;google_apis;x86_64" \
-d pixel_6
```

---

## 8. Run emulator

```bash
emulator -avd Pixel_6_API_31
```

For writable system:

```bash
emulator -avd Pixel_6_API_31 -writable-system -no-snapshot
```

---

## 9. Optional: KVM acceleration

Install:

```bash
sudo pacman -S qemu-base virt-manager dnsmasq vde2 bridge-utils
```

Enable:

```bash
sudo systemctl enable --now libvirtd
sudo usermod -aG kvm $USER
```

Reboot.

Verify:

```bash
lsmod | grep kvm
```

---

## Final State

Single SDK root:

```
~/Android/Sdk
```

No pacman `android-sdk` package.
No `/opt/android-sdk`.
No duplicate SDK installations.
JDK 17 active.
Persistent PATH in `.zshrc`.

This prevents every conflict encountered earlier.
