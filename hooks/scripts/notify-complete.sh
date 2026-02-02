#!/bin/bash
# notify-complete.sh - Notifica cuando una tarea larga termina
# Uso: Se ejecuta cuando Claude completa una tarea

# Detectar sistema operativo y método de notificación
notify() {
    local title="$1"
    local message="$2"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - usar osascript
        osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux - usar notify-send si está disponible
        if command -v notify-send &> /dev/null; then
            notify-send "$title" "$message"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        # Windows (Git Bash/WSL) - usar PowerShell toast
        powershell.exe -Command "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; \$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02; \$toastXml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(\$template); \$toastXml.GetElementsByTagName('text')[0].AppendChild(\$toastXml.CreateTextNode('$title')); \$toastXml.GetElementsByTagName('text')[1].AppendChild(\$toastXml.CreateTextNode('$message')); \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$toastXml); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)"
    fi
}

# Main
main() {
    local task_name="${1:-Task}"
    local status="${2:-completed}"

    notify "Claude Code" "$task_name $status"
}

main "$@"
