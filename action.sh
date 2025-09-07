#!/system/bin/sh

MODDIR=${0%/*}

SOURCE='Loli'
SANS_CJK='LoliCJK-Regular.ttf'

sleep_pause() {
    # APatch and KernelSU needs this
    # but not KSU_NEXT, MMRL
    if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
        sleep 6
    fi
}

echo "[+] Repairing symlinks..."
cd $MODDIR/system/fonts/
for _t in *.placeholder; do
    _v=${_t%.placeholder}
    /system/bin/ln -sf ${SOURCE}-${_v#*-} ${_t}
    mv ${_t} ${_v}
done

# Oneplus
[ ! -f "/system/fonts/SysSans-En-Regular.ttf" ] || /system/bin/ln -sf ${SOURCE}-Regular.ttf SysSans-En-Regular.ttf
[ ! -f "/system/fonts/SysSans-Hans-Regular.ttf" ] || /system/bin/ln -sf ${SANS_CJK} SysSans-Hans-Regular.ttf
[ ! -f "/system/fonts/SysSans-Hant-Regular.ttf" ] || /system/bin/ln -sf ${SANS_CJK} SysSans-Hant-Regular.ttf

echo "[+] Successfully."
echo "[!] You MUST reboot to apply the update."
sleep_pause
