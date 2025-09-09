#!/system/bin/sh

MODDIR=${0%/*}

sleep_pause() {
    # APatch and KernelSU needs this
    # but not KSU_NEXT, MMRL
    if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
        sleep 6
    fi
}

# Oneplus
[ ! -f "/system/fonts/SysSans-En-Regular.ttf" ] || /system/bin/ln -sf ${SOURCE}-Regular.ttf SysSans-En-Regular.ttf
#[ ! -f "/system/fonts/SysSans-Hans-Regular.ttf" ] || /system/bin/ln -sf ${SANS_CJK} SysSans-Hans-Regular.ttf
#[ ! -f "/system/fonts/SysSans-Hant-Regular.ttf" ] || /system/bin/ln -sf ${SANS_CJK} SysSans-Hant-Regular.ttf

echo "[+] Successfully."
echo "[!] You MUST reboot to apply the update."
sleep_pause
