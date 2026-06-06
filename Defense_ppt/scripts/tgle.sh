#!/usr/bin/env bash

#!/usr/bin/env bash

TARGET_NAME="Mouse passthrough"  # the device name you want to match
DBUS_SERVICE="org.kde.KWin"
BASE_PATH="/org/kde/KWin/InputDevice"

# Find device path by scanning all InputDevice entries
DEVICE_PATH=""
for dev in $(qdbus6 $DBUS_SERVICE | grep "$BASE_PATH"); do
    name=$(qdbus6 $DBUS_SERVICE "$dev" org.freedesktop.DBus.Properties.Get org.kde.KWin.InputDevice name 2>/dev/null | sed 's/^"//;s/"$//')
    if [[ "$name" == "$TARGET_NAME" ]]; then
        DEVICE_PATH="$dev"
        break
    fi
done

if [[ -z "$DEVICE_PATH" ]]; then
    notify-send "Mouse passthrough toggle" "Device not found: $TARGET_NAME"
    exit 1
fi

# Read current state
cur=$(qdbus6 $DBUS_SERVICE "$DEVICE_PATH" org.freedesktop.DBus.Properties.Get org.kde.KWin.InputDevice enabled)

# Toggle
if [[ "$cur" == *"true"* ]]; then
    qdbus6 $DBUS_SERVICE "$DEVICE_PATH" org.freedesktop.DBus.Properties.Set org.kde.KWin.InputDevice enabled false
    notify-send "Mouse passthrough" "Disabled (no clicks)"
else
    qdbus6 $DBUS_SERVICE "$DEVICE_PATH" org.freedesktop.DBus.Properties.Set org.kde.KWin.InputDevice enabled true
    notify-send "Mouse passthrough" "Enabled (clicks active)"
fi



#DEV_PATH="/org/kde/KWin/InputDevice/event25"

#cur=$(qdbus6 org.kde.KWin "$DEV_PATH" org.freedesktop.DBus.Properties.Get org.kde.KWin.InputDevice enabled 2>/dev/null || echo "(error)")
#if [[ "$cur" == *"true"* ]]; then
#  qdbus6 org.kde.KWin "$DEV_PATH" org.freedesktop.DBus.Properties.Set org.kde.KWin.InputDevice enabled false
#  notify-send "Mouse passthrough" "Disabled (no clicks)"
#else
#  qdbus6 org.kde.KWin "$DEV_PATH" org.freedesktop.DBus.Properties.Set org.kde.KWin.InputDevice enabled true
#  notify-send "Mouse passthrough" "Enabled (clicks active)"
#fi
