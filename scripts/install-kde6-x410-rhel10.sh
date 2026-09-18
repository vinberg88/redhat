#!/usr/bin/env bash
#
# RHEL KDE6 X410 installer
# Installs the kde6-x410 launcher for Red Hat Enterprise Linux 10 under WSL2.
#
# Usage:
#   chmod +x install-kde6-x410-rhel10.sh
#   ./install-kde6-x410-rhel10.sh
#

set -euo pipefail

VERSION="0.1.3"
SYSTEM_LAUNCHER="/usr/local/bin/kde6-x410"
LEGACY_LAUNCHER="$HOME/.local/bin/kde6-x410"
STATE_DIR="$HOME/.local/state/kde6-x410"
TMP_LAUNCHER="$(mktemp)"
trap 'rm -f "$TMP_LAUNCHER"' EXIT

ok()   { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

if [[ "${EUID}" -eq 0 ]]; then
    err "Do not run this installer as root or with sudo."
    echo "Run it as your normal WSL user."
    exit 1
fi

echo
echo "   RHEL KDE6 X410 Installer $VERSION"
echo "============================================"
echo

if [[ -r /etc/redhat-release ]]; then
    info "$(cat /etc/redhat-release)"
else
    warn "/etc/redhat-release was not found."
fi

if ! grep -qi microsoft /proc/version 2>/dev/null; then
    warn "WSL was not detected in /proc/version."
fi

missing=0
for cmd in startplasma-x11 kwin_x11 plasmashell systemctl ip pgrep pkill timeout sudo install; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        err "Missing command: $cmd"
        missing=1
    fi
done

if [[ "$missing" -ne 0 ]]; then
    echo
    err "Required KDE/WSL components are missing. Installation stopped."
    exit 1
fi

mkdir -p "$STATE_DIR"

cat > "$TMP_LAUNCHER" <<'LAUNCHER_EOF'
#!/usr/bin/env bash

set -u

VERSION="0.1.3"
STATE_DIR="$HOME/.local/state/kde6-x410"
LOG_FILE="$STATE_DIR/session.log"
PID_FILE="$STATE_DIR/session.pid"

mkdir -p "$STATE_DIR"

ok()   { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

get_x410_host() {
    if [[ -n "${X410_HOST:-}" ]]; then
        printf '%s\n' "$X410_HOST"
        return
    fi

    local host=""
    host="$(ip route show default 2>/dev/null | awk '/default/ {print $3; exit}')"

    if [[ -z "$host" ]] && [[ -r /etc/resolv.conf ]]; then
        host="$(awk '/^nameserver[[:space:]]+/ {print $2; exit}' /etc/resolv.conf)"
    fi

    printf '%s\n' "$host"
}

setup_env() {
    local host
    host="$(get_x410_host)"

    if [[ -z "$host" ]]; then
        err "Could not detect the Windows/X410 host address."
        echo "You can override it with:"
        echo "  export X410_HOST=<Windows-host-IP>"
        return 1
    fi

    export DISPLAY="${host}:0.0"

    unset WAYLAND_DISPLAY
    unset WAYLAND_SOCKET

    export XDG_SESSION_TYPE=x11
    export XDG_CURRENT_DESKTOP=KDE
    export XDG_SESSION_DESKTOP=KDE
    export DESKTOP_SESSION=plasma
    export KDE_FULL_SESSION=true
    export KDE_SESSION_VERSION=6

    export QT_QPA_PLATFORM=xcb
    export GDK_BACKEND=x11

    export XDG_RUNTIME_DIR="/run/user/$(id -u)"

    if [[ -S "$XDG_RUNTIME_DIR/bus" ]]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    fi

    if [[ -S /mnt/wslg/PulseServer ]]; then
        export PULSE_SERVER="unix:/mnt/wslg/PulseServer"
    fi
}

check_x410() {
    setup_env || return 1

    local host="${DISPLAY%%:*}"

    if command -v xdpyinfo >/dev/null 2>&1; then
        timeout 4 env DISPLAY="$DISPLAY" xdpyinfo >/dev/null 2>&1
        return $?
    fi

    if command -v xset >/dev/null 2>&1; then
        timeout 4 env DISPLAY="$DISPLAY" xset q >/dev/null 2>&1
        return $?
    fi

    timeout 3 bash -c "exec 3<>/dev/tcp/${host}/6000" >/dev/null 2>&1
}

import_environment() {
    systemctl --user unset-environment WAYLAND_DISPLAY WAYLAND_SOCKET 2>/dev/null || true

    systemctl --user import-environment         DISPLAY         XDG_RUNTIME_DIR         XDG_SESSION_TYPE         XDG_CURRENT_DESKTOP         XDG_SESSION_DESKTOP         DESKTOP_SESSION         KDE_FULL_SESSION         KDE_SESSION_VERSION         QT_QPA_PLATFORM         GDK_BACKEND         PULSE_SERVER         DBUS_SESSION_BUS_ADDRESS         2>/dev/null || true

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment --systemd             DISPLAY             XDG_RUNTIME_DIR             XDG_SESSION_TYPE             XDG_CURRENT_DESKTOP             XDG_SESSION_DESKTOP             DESKTOP_SESSION             KDE_FULL_SESSION             KDE_SESSION_VERSION             QT_QPA_PLATFORM             GDK_BACKEND             PULSE_SERVER             2>/dev/null || true
    fi
}

running() {
    pgrep -u "$(id -u)" -x plasmashell >/dev/null 2>&1 ||
    pgrep -u "$(id -u)" -x kwin_x11 >/dev/null 2>&1
}

failed_user_units() {
    systemctl --user --failed --no-legend --plain 2>/dev/null | awk 'NF {print $1}'
}

is_known_wsl_warning() {
    local unit="$1"

    case "$unit" in
        app-nvidia*settings*|app-sealertauto*|obex.service|uresourced.service)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

doctor() {
    setup_env || return 1

    local user_systemd
    local failed_count=0
    local known_warning_count=0
    local plasma_failed_count=0
    local audio_ok=0
    local unit

    user_systemd="$(systemctl --user is-system-running 2>/dev/null || true)"

    while IFS= read -r unit; do
        [[ -z "$unit" ]] && continue
        ((failed_count++))

        if is_known_wsl_warning "$unit"; then
            ((known_warning_count++))
        fi

        case "$unit" in
            plasma-*|app-org.kde.*|app-systemsettings*|app-org.kde.konsole*)
                ((plasma_failed_count++))
                ;;
        esac
    done < <(failed_user_units)

    echo
    echo "   RHEL KDE6 X410 $VERSION"
    echo "============================================"
    printf "%-26s %s\n" "Distribution:" "$(cat /etc/redhat-release 2>/dev/null || echo unknown)"
    printf "%-26s %s\n" "Kernel:" "$(uname -r)"
    printf "%-26s %s\n" "WSL:" "$(grep -qi microsoft /proc/version 2>/dev/null && echo yes || echo no)"
    printf "%-26s %s\n" "User:" "$(whoami)"
    printf "%-26s %s\n" "UID:" "$(id -u)"
    printf "%-26s %s\n" "PID 1:" "$(ps -p 1 -o comm=)"

    if [[ "$user_systemd" == "degraded" && "$failed_count" -gt 0 && "$failed_count" -eq "$known_warning_count" ]]; then
        printf "%-26s %s\n" "User systemd:" "degraded (WSL warnings only)"
    else
        printf "%-26s %s\n" "User systemd:" "$user_systemd"
    fi

    printf "%-26s %s\n" "Failed user units:" "$failed_count"

    if [[ "$known_warning_count" -gt 0 ]]; then
        printf "%-26s %s\n" "Known WSL warnings:" "$known_warning_count"
    fi

    if [[ "$plasma_failed_count" -gt 0 ]]; then
        printf "%-26s %s\n" "Failed Plasma units:" "$plasma_failed_count"
    fi

    printf "%-26s %s\n" "X410 DISPLAY:" "$DISPLAY"

    if check_x410; then
        printf "%-26s %s\n" "X410:" "reachable"
    else
        printf "%-26s %s\n" "X410:" "NOT reachable"
    fi

    for cmd in startplasma-x11 kwin_x11 plasmashell; do
        if command -v "$cmd" >/dev/null 2>&1; then
            printf "%-26s %s\n" "$cmd:" "$(command -v "$cmd")"
        else
            printf "%-26s %s\n" "$cmd:" "MISSING"
        fi
    done

    if [[ -S /mnt/wslg/PulseServer ]]; then
        audio_ok=1
        printf "%-26s %s\n" "WSLg audio socket:" "yes"
    else
        printf "%-26s %s\n" "WSLg audio socket:" "no"
    fi

    if running; then
        printf "%-26s %s\n" "Plasma session:" "RUNNING"
    else
        printf "%-26s %s\n" "Plasma session:" "stopped"
    fi

    if check_x410 >/dev/null 2>&1 &&
       command -v startplasma-x11 >/dev/null 2>&1 &&
       command -v kwin_x11 >/dev/null 2>&1 &&
       command -v plasmashell >/dev/null 2>&1 &&
       [[ "$plasma_failed_count" -eq 0 ]]; then
        if [[ "$audio_ok" -eq 0 && "$failed_count" -eq 0 ]]; then
            printf "%-26s %s\n" "Status:" "READY WITH AUDIO WARNING"
        elif [[ "$audio_ok" -eq 0 && "$failed_count" -eq "$known_warning_count" ]]; then
            printf "%-26s %s\n" "Status:" "READY WITH WSL/AUDIO WARNINGS"
        elif [[ "$audio_ok" -eq 0 ]]; then
            printf "%-26s %s\n" "Status:" "READY WITH WARNINGS"
        elif [[ "$failed_count" -eq 0 ]]; then
            printf "%-26s %s\n" "Status:" "READY"
        elif [[ "$failed_count" -eq "$known_warning_count" ]]; then
            printf "%-26s %s\n" "Status:" "READY WITH WSL WARNINGS"
        else
            printf "%-26s %s\n" "Status:" "READY WITH WARNINGS"
        fi
    else
        printf "%-26s %s\n" "Status:" "CHECK REQUIRED"
    fi

    echo

    if [[ "${1:-}" == "--verbose" && "$failed_count" -gt 0 ]]; then
        echo "Failed user units:"
        systemctl --user --failed --no-pager -l
        echo
    fi
}
start_session() {
    setup_env || exit 1

    if ! check_x410; then
        err "X410 does not respond on DISPLAY=$DISPLAY"
        echo
        echo "Start X410 in Windows and make sure it accepts WSL connections."
        echo
        echo "Then run:"
        echo "  kde6-x410 doctor"
        exit 1
    fi

    ok "X410 responds on DISPLAY=$DISPLAY"

    if [[ -S /mnt/wslg/PulseServer ]]; then
        ok "WSLg audio available via /mnt/wslg/PulseServer"
    else
        warn "WSLg PulseAudio socket was not found."
    fi

    if running; then
        warn "A Plasma session already appears to be running."
        echo "Use: kde6-x410 stop"
        exit 1
    fi

    import_environment

    rm -f "$PID_FILE"
    : > "$LOG_FILE"

    echo
    echo "[RHEL KDE6 X410] Starting KDE Plasma 6 X11..."
    echo "[RHEL KDE6 X410] DISPLAY=$DISPLAY"
    echo "[RHEL KDE6 X410] Log: $LOG_FILE"
    echo

    nohup setsid /usr/bin/startplasma-x11 >>"$LOG_FILE" 2>&1 &
    local pid=$!
    echo "$pid" > "$PID_FILE"

    sleep 5

    if running; then
        ok "KDE Plasma 6 is running."
        echo
        echo "DISPLAY: $DISPLAY"
        echo "Session: X11"
        echo
        echo "Use:"
        echo "  kde6-x410 doctor"
        echo "  kde6-x410 stop"
    else
        err "Plasma did not appear to start correctly."
        echo
        echo "Last log lines:"
        tail -n 40 "$LOG_FILE" 2>/dev/null || true
        exit 1
    fi
}

stop_session() {
    echo "[RHEL KDE6 X410] Stopping Plasma..."

    if command -v kquitapp6 >/dev/null 2>&1; then
        kquitapp6 plasmashell >/dev/null 2>&1 || true
    fi

    sleep 1

    pkill -u "$(id -u)" -x plasmashell 2>/dev/null || true
    pkill -u "$(id -u)" -x kwin_x11 2>/dev/null || true
    pkill -u "$(id -u)" -f '/usr/bin/startplasma-x11' 2>/dev/null || true

    rm -f "$PID_FILE"
    sleep 2

    if running; then
        warn "Some Plasma processes are still running."
    else
        ok "KDE Plasma 6 stopped."
    fi
}

show_log() {
    if [[ -f "$LOG_FILE" ]]; then
        tail -n 100 "$LOG_FILE"
    else
        echo "No session log yet."
    fi
}

case "${1:-doctor}" in
    start)
        start_session
        ;;
    stop)
        stop_session
        ;;
    restart)
        stop_session
        sleep 2
        start_session
        ;;
    doctor|status)
        doctor "${2:-}"
        ;;
    log)
        show_log
        ;;
    version|--version|-v)
        echo "RHEL KDE6 X410 $VERSION"
        ;;
    *)
        echo "Usage:"
        echo "  kde6-x410 start"
        echo "  kde6-x410 stop"
        echo "  kde6-x410 restart"
        echo "  kde6-x410 doctor"
        echo "  kde6-x410 doctor --verbose"
        echo "  kde6-x410 log"
        exit 1
        ;;
esac
LAUNCHER_EOF

chmod 755 "$TMP_LAUNCHER"

# Remove the old per-user launcher if it exists.  A stale ~/.local/bin copy
# can shadow /usr/local/bin and was the cause of the original PATH problem.
if [[ -e "$LEGACY_LAUNCHER" || -L "$LEGACY_LAUNCHER" ]]; then
    info "Removing legacy launcher: $LEGACY_LAUNCHER"
    rm -f "$LEGACY_LAUNCHER" 2>/dev/null || sudo rm -f "$LEGACY_LAUNCHER"
fi

info "Installing kde6-x410 system-wide in /usr/local/bin..."
sudo install -m 0755 "$TMP_LAUNCHER" "$SYSTEM_LAUNCHER"

if [[ ! -x "$SYSTEM_LAUNCHER" ]]; then
    err "Installation failed: $SYSTEM_LAUNCHER is not executable."
    exit 1
fi

ok "Installed: $SYSTEM_LAUNCHER"

echo
echo "Installation complete."
echo
echo "No shell reload is required."
echo
echo "Run immediately:"
echo
echo "  kde6-x410 doctor"
echo
echo "Then:"
echo "  kde6-x410 start"
echo
echo "Other commands:"
echo "  kde6-x410 stop"
echo "  kde6-x410 restart"
echo "  kde6-x410 doctor --verbose"
echo "  kde6-x410 log"
echo
