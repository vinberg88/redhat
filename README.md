<div align="center">

# 🔴 Red Hat Enterprise Linux on WSL

### Enterprise Linux on Windows — with MATE, GNOME and KDE Plasma 6

[![RHEL](https://img.shields.io/badge/Red%20Hat-Enterprise%20Linux-EE0000?style=for-the-badge&logo=redhat&logoColor=white)](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)
[![WSL2](https://img.shields.io/badge/WSL-2-0078D4?style=for-the-badge&logo=windows11&logoColor=white)](https://learn.microsoft.com/windows/wsl/)
[![Windows 11](https://img.shields.io/badge/Windows-11-0078D4?style=for-the-badge&logo=windows11&logoColor=white)](https://www.microsoft.com/windows/windows-11)
[![Desktop](https://img.shields.io/badge/Desktop-MATE%20%7C%20GNOME%20%7C%20KDE6-444444?style=for-the-badge)](#-desktop-environments)

**A community project for running Red Hat Enterprise Linux under WSL2 and exploring full Linux desktop environments on Windows.**

<img src="wallpapers/RVMtJ.jpg" alt="Red Hat Enterprise Linux 10" width="920">

</div>

---

## 📖 About this project

Red Hat Enterprise Linux and Windows Subsystem for Linux make a powerful development combination.

You can keep **Windows 11** as your main desktop while using a real RHEL userspace for Linux development, shell tools, containers, automation and testing — without maintaining a traditional virtual machine.

This repository focuses on taking that setup one step further by experimenting with complete Linux desktop environments on RHEL under WSL2:

- 🟢 **MATE Desktop**
- 🔵 **GNOME**
- 🟣 **KDE Plasma 6**

The goal is to document clean, repeatable setups for **WSL2 + systemd + GUI + audio**, with **X410** used where a complete X11 desktop session is preferable and **WSLg** retained for native GUI integration and audio.

> [!IMPORTANT]
> Red Hat provides RHEL 8, RHEL 9 and RHEL 10 WSL images for development use. Red Hat documents these images as **self-supported**, and notes that graphical interfaces can behave differently under WSL. The desktop configurations in this repository are community experiments and are not official Red Hat desktop-on-WSL configurations.

---

## 🎨 Wallpapers

Community wallpapers for **RHEL 10** and the Red Hat fedora. Unofficial fan art — not official Red Hat brand assets.

All files live in [`wallpapers/`](wallpapers/).

### RHEL 10 — color mix

<p align="center">
  <img src="wallpapers/QfXn8.jpg" alt="RHEL 10 blue and yellow" width="48%">
  <img src="wallpapers/bzS52.jpg" alt="RHEL 10 yellow and blue" width="48%">
</p>
<p align="center">
  <img src="wallpapers/9MJPK.jpg" alt="RHEL 10 forest" width="48%">
  <img src="wallpapers/U5poz.jpg" alt="RHEL 10 purple and cyan" width="48%">
</p>
<p align="center">
  <img src="wallpapers/Th3nk.jpg" alt="RHEL 10 blue and gold" width="92%">
</p>

### RHEL 10 — enterprise

<p align="center">
  <img src="wallpapers/RVMtJ.jpg" alt="RHEL 10 classic" width="48%">
  <img src="wallpapers/RKq23.jpg" alt="RHEL 10 Lightspeed" width="48%">
</p>
<p align="center">
  <img src="wallpapers/uEMx9.jpg" alt="RHEL 10 teal clouds" width="48%">
  <img src="wallpapers/S6jUS.jpg" alt="RHEL 10 image mode" width="48%">
</p>
<p align="center">
  <img src="wallpapers/UW0CC.jpg" alt="RHEL 10 security" width="48%">
  <img src="wallpapers/EkUzE.jpg" alt="RHEL 10 light" width="48%">
</p>
<p align="center">
  <img src="wallpapers/pt5tI.jpg" alt="RHEL 10 geometric" width="48%">
  <img src="wallpapers/Tn2pA.jpg" alt="RHEL 10 terminal" width="48%">
</p>
<p align="center">
  <img src="wallpapers/6aSVZ.jpg" alt="RHEL 10 mountains" width="48%">
  <img src="wallpapers/pwGBt.jpg" alt="RHEL 10 gold" width="48%">
</p>

### Red Hat fedora

<p align="center">
  <img src="wallpapers/IIwxn.jpg" alt="Red Hat classic" width="48%">
  <img src="wallpapers/QPink.jpg" alt="Red Hat neon" width="48%">
</p>
<p align="center">
  <img src="wallpapers/ZBTp0.jpg" alt="Red Hat light" width="48%">
  <img src="wallpapers/iNZU9.jpg" alt="Red Hat geometric" width="48%">
</p>
<p align="center">
  <img src="wallpapers/IhcJl.jpg" alt="Red Hat circuits" width="48%">
  <img src="wallpapers/mExW0.jpg" alt="Red Hat teal" width="48%">
</p>
<p align="center">
  <img src="wallpapers/P8K8O.jpg" alt="Red Hat mountains" width="48%">
  <img src="wallpapers/6olQG.jpg" alt="Red Hat terminal rain" width="48%">
</p>
<p align="center">
  <img src="wallpapers/D0Pla.jpg" alt="Red Hat gold" width="48%">
  <img src="wallpapers/tnxVT.jpg" alt="Red Hat ink" width="48%">
</p>

---

## ✨ Why RHEL on WSL?

### 🧱 Develop closer to production

Use the same RHEL family of tools, package management, libraries and system conventions that are common in enterprise Linux environments.

### 📦 Container development

RHEL provides first-class support for **Podman** and OCI containers. WSL makes it possible to build and test Linux workloads while remaining inside your Windows development environment.

### 💻 Windows + Linux workflow

Use Windows Terminal, Visual Studio Code, Git and other Windows tools alongside the RHEL command line and Linux filesystem.

### ⚙️ systemd support

Modern WSL2 can run **systemd**, which makes service management and complete desktop-session experiments considerably more practical.

### 🖥️ Linux GUI on Windows

Use **WSLg** for individual Linux GUI applications, or an external X server such as **X410** when experimenting with a complete X11 desktop session.

---

# 🖥️ Desktop Environments

This repository is designed around three desktop configurations.

| Desktop | Style | WSL display target | Project status |
|---|---|---|---|
| 🟢 **MATE** | Traditional, lightweight and fast | X410 / X11 | 🚧 Validation |
| 🔵 **GNOME** | Modern, integrated desktop | WSLg / X11 experiments | 🚧 Validation |
| 🟣 **KDE Plasma 6** | Feature-rich and highly customizable | X410 / X11 | 🚧 Validation |

The status will be updated as each configuration is installed, tested and documented.

---

## 🟢 MATE Desktop

MATE is an excellent candidate for WSL because it provides a complete traditional Linux desktop without requiring an especially heavy graphical stack.

### Planned MATE guide

- Package installation
- X410 configuration
- Correct `DISPLAY` handling
- D-Bus session startup
- systemd user session
- WSLg PulseAudio integration
- Clean start/stop launcher
- Diagnostic command
- Screenshot and tested version information

**Target launcher:**

```bash
mate-x410 start
mate-x410 doctor
mate-x410 stop
```

📸 **Screenshot:** will be added after the first validated RHEL + MATE session.

---

## 🔵 GNOME

GNOME is the desktop most closely associated with the standard RHEL graphical workstation experience.

Running a complete GNOME session inside WSL is more experimental than launching individual GNOME applications through WSLg, because modern GNOME relies heavily on Mutter, D-Bus, systemd user services and modern display-stack behavior.

### Planned GNOME guide

- GNOME package installation
- systemd and D-Bus preparation
- WSLg compatibility
- X11 / X410 testing where applicable
- Mutter session diagnostics
- WSLg audio
- Environment cleanup to prevent mixed WSLg/X410 windows
- Start/stop/doctor tooling

**Target launcher:**

```bash
gnome-wsl start
gnome-wsl doctor
gnome-wsl stop
```

📸 **Screenshot:** will be added after the first validated RHEL + GNOME session.

---

## 🟣 KDE Plasma 6

KDE Plasma 6 is the most configurable desktop in this project and is a particularly interesting target for a full X410 session.

A major objective is to keep the entire Plasma desktop on the same display server instead of allowing some applications to open through WSLg and others through X410.

### Planned KDE Plasma 6 guide

- Plasma 6 package installation
- X11 session verification
- X410 display detection
- KWin X11 startup
- plasmashell startup
- D-Bus and systemd user session
- WSLg PulseAudio integration
- Mixed-display protection
- Start/stop/doctor tooling

**Target launcher:**

```bash
kde6-x410 start
kde6-x410 doctor
kde6-x410 stop
```

📸 **Screenshot:** will be added after the first validated RHEL + KDE Plasma 6 session.

---

# 🧩 How the setup fits together

```text
┌─────────────────────────────────────────────────────────┐
│                      Windows 11                          │
│                                                          │
│  ┌──────────────────────┐   ┌───────────────────────┐   │
│  │        WSLg          │   │         X410           │   │
│  │ GUI apps + audio     │   │ Full X11 desktop      │   │
│  └──────────┬───────────┘   └───────────┬───────────┘   │
│             │                            │               │
│  ┌──────────┴──────────────────────────┴────────────┐  │
│  │                     WSL2                          │  │
│  │                                                  │  │
│  │   Red Hat Enterprise Linux                      │  │
│  │   ├── systemd                                   │  │
│  │   ├── D-Bus                                     │  │
│  │   ├── MATE / GNOME / KDE Plasma 6               │  │
│  │   ├── Podman                                    │  │
│  │   └── Linux development tools                   │  │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

# 🚀 Getting RHEL for WSL

Red Hat publishes WSL images for **RHEL 8, RHEL 9 and RHEL 10** through the Red Hat Customer Portal.

A Red Hat subscription is required to access RHEL content. A no-cost Red Hat Developer Subscription can also be used where applicable.

Useful official resources:

- 🔗 [Red Hat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)
- 🔗 [Red Hat Customer Portal](https://access.redhat.com/)
- 🔗 [RHEL 10 — Generating a WSL2 image with Image Builder](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/composing_a_customized_rhel_system_image/generating-wsl2-image-with-rhel-image-builder)
- 🔗 [Microsoft WSL documentation](https://learn.microsoft.com/windows/wsl/)
- 🔗 [Microsoft WSL GUI application documentation](https://learn.microsoft.com/windows/wsl/tutorials/gui-apps)

RHEL Image Builder can also produce a native `.wsl` image:

```bash
image-builder build wsl --blueprint <blueprint-name>
```

The generated image can then be deployed on Windows using modern WSL tooling.

---

# ✅ Windows prerequisites

This project targets **WSL2**.

From PowerShell:

```powershell
wsl --version
wsl --status
wsl --update
```

List installed distributions:

```powershell
wsl --list --verbose
```

The RHEL distribution should be running as **Version 2**.

---

# ⚙️ Enable systemd

Check the current init process inside RHEL:

```bash
ps -p 1 -o pid,comm,args
```

Expected result:

```text
PID COMMAND
  1 systemd
```

If systemd is not enabled, create or edit:

```bash
sudo nano /etc/wsl.conf
```

Use:

```ini
[boot]
systemd=true
```

Then restart WSL from Windows:

```powershell
wsl --shutdown
```

Start RHEL again and verify:

```bash
systemctl is-system-running
systemctl --failed --no-pager
```

---

# 🚪 WSLg vs X410

WSLg and X410 solve different problems.

| Feature | WSLg | X410 |
|---|---|---|
| Individual Linux GUI apps | ✅ Excellent | ✅ |
| Windows Start menu integration | ✅ | ❌ |
| Wayland applications | ✅ | Limited / depends on setup |
| X11 applications | ✅ | ✅ |
| Complete X11 desktop session | ⚠️ Not the primary WSLg use case | ✅ Preferred in this project |
| WSL audio integration | ✅ | ✅ Can reuse WSLg PulseAudio |
| Desktop isolation | Windows-integrated windows | Single desktop window / X server |

> [!NOTE]
> Microsoft explicitly describes WSLg as support for Linux GUI **applications**, not as a complete Linux desktop replacement. This project therefore uses X410 for full desktop experiments where appropriate.

---

# 🔊 Audio

When WSLg is installed, Linux applications can use the WSLg PulseAudio server.

Typical socket:

```text
/mnt/wslg/PulseServer
```

Useful check:

```bash
test -S /mnt/wslg/PulseServer && echo "WSLg audio socket: OK"
```

The desktop launchers in this repository will aim to reuse WSLg audio rather than starting a second competing audio server.

---

# 🔍 Basic RHEL WSL diagnostics

These commands are useful before installing a desktop:

```bash
echo "=== OS ==="
cat /etc/redhat-release
cat /etc/os-release

echo
echo "=== Kernel ==="
uname -a

echo
echo "=== systemd ==="
ps -p 1 -o pid,comm,args
systemctl is-system-running
systemctl --failed --no-pager

echo
echo "=== WSL ==="
grep -i microsoft /proc/version

echo
echo "=== GUI ==="
printf 'DISPLAY=%s\n' "$DISPLAY"
printf 'WAYLAND_DISPLAY=%s\n' "$WAYLAND_DISPLAY"

echo
echo "=== Audio ==="
test -S /mnt/wslg/PulseServer && echo "WSLg PulseAudio: OK" || echo "WSLg PulseAudio: not found"
```

---

# 📦 Podman

RHEL is an excellent environment for Podman-based development.

Install Podman:

```bash
sudo dnf install -y podman
podman --version
```

> [!NOTE]
> RHEL WSL releases may have WSL-specific Podman networking requirements. Check the current Red Hat documentation for your exact RHEL release before treating a WSL container setup as equivalent to a normal RHEL host.

---

# 🧪 Validation checklist

Each desktop guide will only be marked **READY** after the important WSL components have been tested.

```text
[ ] RHEL starts normally under WSL2
[ ] systemd is PID 1
[ ] systemd reports running/degraded state understood
[ ] User systemd session works
[ ] D-Bus session works
[ ] Windows interoperability works
[ ] DNS/networking works
[ ] X410 connection works
[ ] Desktop shell starts
[ ] Desktop stays on the intended display server
[ ] WSLg audio works
[ ] Desktop can be stopped cleanly
[ ] Re-launch works without rebooting Windows
```

---

# 🗂️ Planned repository layout

```text
redhat/
├── README.md
├── wallpapers/
│   ├── README.md
│   └── *.jpg
├── mate/
│   ├── README.md
│   └── scripts/
├── gnome/
│   ├── README.md
│   └── scripts/
├── kde6/
│   ├── README.md
│   └── scripts/
└── screenshots/
```

This keeps the main page clean while allowing each desktop environment to have a complete installation and troubleshooting guide.

---

# 🛣️ Roadmap

- [ ] Validate the base RHEL WSL installation
- [ ] Build the RHEL WSL diagnostic tool
- [ ] Add MATE Desktop
- [ ] Add MATE X410 launcher
- [ ] Add GNOME
- [ ] Validate GNOME display/session behavior
- [ ] Add KDE Plasma 6
- [ ] Add KDE6 X410 launcher
- [ ] Validate WSLg audio on all desktops
- [x] Add community wallpapers
- [ ] Add desktop screenshots
- [ ] Add tested-version matrix
- [ ] Add troubleshooting documentation
- [ ] Add YouTube installation/demo links

---

# ⚠️ Important notes

- This repository is an **independent community project**.
- It is **not affiliated with, sponsored by or endorsed by Red Hat, Inc.**
- Red Hat, RHEL and Red Hat Enterprise Linux are trademarks or registered trademarks of Red Hat, Inc.
- The wallpapers in this repository are unofficial community artwork.
- Full desktop environments under WSL are experimental and may require workarounds that are unnecessary on a native RHEL installation.
- WSLg is optimized for individual GUI applications; a complete desktop session may require a different display-server strategy.
- Always check the current Red Hat documentation for support status and release-specific limitations.

---

<div align="center">

## ❤️ Red Hat + WSL + Linux Desktop

**Windows on the outside. Enterprise Linux on the inside.**

Built as a community WSL desktop project by [vinberg88](https://github.com/vinberg88).

</div>
