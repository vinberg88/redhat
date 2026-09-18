# Extras

## Sister WSL desktop projects

| Distro | Repo |
|---|---|
| AlmaLinux 10 | https://github.com/vinberg88/almalinux |
| openSUSE | https://github.com/vinberg88/opensuse |
| Ubuntu | https://github.com/vinberg88/ubuntu |
| Debian | https://github.com/vinberg88/debian |
| openSUSE Leap / Tumbleweed notes | https://github.com/vinberg88/suse |
| Manjaro | https://github.com/vinberg88/manjaro |
| Pop!_OS | https://github.com/vinberg88/pop-os-wsl |
| Overview site | https://github.com/vinberg88/vinberg88.github.io |

## Windows Terminal colors

Blue/gold scheme: [`extras/windows-terminal/rhel-wsl-theme.json`](extras/windows-terminal/rhel-wsl-theme.json)

Settings → Color schemes → Open JSON file → add the object to `schemes` → set the RHEL profile to **RHEL 10.2 WSL**.

## Boot splash

```bash
chmod +x scripts/rhel-wsl
./scripts/rhel-wsl splash
./scripts/rhel-wsl doctor
sudo install -m 0755 scripts/rhel-wsl /usr/local/bin/rhel-wsl
```

## Issue templates

New issue → Desktop does not start / X410 / Audio
