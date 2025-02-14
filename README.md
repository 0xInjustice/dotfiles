##### Packages To install``

```bash
sudo pacman -S neovim git python easyeffects reflector bluez blueman bluez-utils p7zip unzip unrar firefox vlc stow tmux zsh fzf zoxide lsp-plugins unzip npm wl-clipboard swaync
yay -S  oh-my-posh kanata spotify hyprshot #install yay first
```

##### Pacman

```bash
sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo vim /etc/pacman.conf # add IloveCandy and uncomment Color
```

##### Yay

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

```

##### UFW

```bash
sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
```

#### Cpu-Freq

```bash
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install
```

#### Tmux

```bash
 rm ~/dotfiles/.config/tmux/plugins/tpm  -rf
 rm ~/dotfiles/.config/tmux/plugins/tmux-themepack/ -rf
 git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.config/tmux/plugins/tpm
```

#### Kanata

```bash
sudo cp ~/dotfiles/ignores/kanata.service /lib/systemd/system/kanata.service
sudo systemctl daemon-reload
sudo systemctl start kanata
sudo systemctl enable kanata

```

#### QuteBrowser

```bash
mkdir  -p ~/.config/qutebrowser/themes
git clone https://github.com/gicrisf/qute-city-lights.git ~/.config/qutebrowser/themes/qute-city-lights
```

#### Nerd-Font

```bash
sudo mkdir -p /usr/local/share/fonts
cd /usr/local/share/fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf
sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf
sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/HackNerdFont-BoldItalic.ttf
fc-cache
```

#### EasyEffects and DolbyAtmos

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)" #https://www.reddit.com/r/linuxquestions/comments/pfl0g7/dolby_atmos_support_in_linux/

```

#### Git

```bash
git config user.email ""
git config user.name ""
git config --global core.editor nvim
git remote set-url origin https://scuzzlebuzzle:<MYTOKEN>@github.com/scuzzlebuzzle/ol3-1.git

```

#### Clone the Repository

```bash
git clone https://github.com/mrsujnan/dotfiles.git
cd dotfiles
stow --adopt .
```

#### Qemu

```bash
#https://www.youtube.com/watch?v=2wUZ5KdaFhU
sudo pacman -Sy qemu-full virt-manager dnsmasq bridge-utils libguestfs iptables-nft vde2 openbsd-netcat
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

### uncomment these lines unix_sock_group = "libvert" & unix_sock_rw_perms = "0770"

```bash
sudo vim /etc/libvirt/libvirtd.conf
```

```bash
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt #add user to libvert group
sudo systemctl restart libvirtd.service
sudo vim /etc/libvirt/network.conf # firewell backend to iptables
sudo systemctl enable iptables.service
sudo systemctl start iptables.service
sudo systemctl restart libvirtd.service
```

#### AMD Processor

```bash
sudo modprobe -r kvm_amd
sudo modprobe kvm_amd nested=1
echo "options kvm-amd nested=1" | sudo tee /etc/modprobe.d/amd-intel.conf
```

```bash
yay -S tuned
sudo systemctl enable tuned.service
tuned --version
sudo systemctl enable tuned.service --now
tuned-adm active
sudo tuned-adm profile virtual-host
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default
```
