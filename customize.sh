
SKIPUNZIP=1


ui_print "*******************************"
ui_print "       Magisk Loli Font        "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
. "$MODPATH/common_func.sh"
# --------------------------------------------
ui_print "- Unzipping font files..."
FONTSPATH=/system/fonts
unzip -oj "$ZIPFILE" fonts.tar.xz -d $TMPDIR >&2
mkdir -p $TMPDIR/$FONTSPATH 2>/dev/null
mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
tar -xf $TMPDIR/fonts.tar.xz -C $TMPDIR/$FONTSPATH 2>/dev/null


ui_print "- Installing fonts..."
# https://github.com/lxgw/simple-cjk-font-magisk-module-template/blob/main/system/etc/fonts.xml
LEGACY_FONTS=/system/etc/fonts.xml
FALLBACK_FONTS=/system/etc/font_fallback.xml
SYSTEM_FONTS=/system/system_ext/etc/fonts_base.xml # Third-party

FONT_SANSSERIF='Loli-Regular.ttf'
FONT_CJK='LoliCJK-Regular.ttf'
FONT_SANSSERIF_STATIC='LoliStatic'

for _x in LEGACY_FONTS FALLBACK_FONTS SYSTEM_FONTS; do
  eval "__x=\$$_x"
  if [ -f "$__x" ]; then
    mkdir -p $MODPATH/$(dirname $__x) 2>/dev/null
    cp -af $__x $MODPATH/$__x 2>/dev/null

    # Android 15+ https://source.android.com/docs/core/fonts/custom-font-fallback
    if [ $API -gt 34 -a "$(basename $__x)" = "font_fallback.xml" ]; then # Android 15+ font_fallback.xml https://cs.android.com/android/platform/superproject/+/android15-release:frameworks/base/data/fonts/font_fallback_cjkvf.xml
      ui_print "- Installing Android 15 format $(basename $__x) ..."

      # sans-serif(-condensed)?
      sed -Ei "
        s|^([ \t]*<family name=\"sans-serif\">)|\1$(format_VF "$FONT_SANSSERIF" 100)|;
        s|^([ \t]*<family name=\"sans-serif-condensed\">)|\1$(format_VF "$FONT_SANSSERIF" 75)|;
      " $MODPATH/$__x
      cp -f $TMPDIR/$FONTSPATH/$FONT_SANSSERIF $MODPATH/$FONTSPATH/

      # CJK
      for _lang in zh-Hans zh-Hant,zh-Bopo ja ko; do
        sed -Ei "
          s|^([ \t]*<family lang=\""$_lang"\">)|\1$(format_CJKRegular "$FONT_CJK")|;
        " $MODPATH/$__x
      done
      cp -f $TMPDIR/$FONTSPATH/$FONT_CJK $MODPATH/$FONTSPATH/
    elif [ $API -gt 30 ]; then # Android 12+ https://android.googlesource.com/platform/frameworks/base/+/android12-release/data/fonts/fonts.xml
      ui_print "- Installing Android 12 format $(basename $__x) ..."

      # sans-serif(-condensed)?
      sed -Ei "
        s|^([ \t]*<family name=\"sans-serif\">)|\1$(format_9Weight "$FONT_SANSSERIF" 100)|;
        s|^([ \t]*<family name=\"sans-serif-condensed\">)|\1$(format_9Weight "$FONT_SANSSERIF" 75)|;
      " $MODPATH/$__x
      cp -f $TMPDIR/$FONTSPATH/$FONT_SANSSERIF $MODPATH/$FONTSPATH/

      # CJK
      for _lang in zh-Hans zh-Hant,zh-Bopo ja ko; do
        sed -Ei "
          s|^([ \t]*<family lang=\""$_lang"\">)|\1$(format_CJKRegular "$FONT_CJK")|;
        " $MODPATH/$__x
      done
      cp -f $TMPDIR/$FONTSPATH/$FONT_CJK $MODPATH/$FONTSPATH/
    else # Android 11- https://android.googlesource.com/platform/frameworks/base/+/android11-release/data/fonts/fonts.xml
      ui_print "- Installing Android 11 format $(basename $__x) ..."

      # sans-serif(-condensed)?
      sed -Ei "
        s|^([ \t]*<family name=\"sans-serif(-condensed)?\">)|\1$(format_Static "$FONT_SANSSERIF_STATIC")|;
      " $MODPATH/$__x
      cp -f $TMPDIR/$FONTSPATH/$FONT_SANSSERIF_STATIC-* $MODPATH/$FONTSPATH/

      # CJK
      for _lang in zh-Hans zh-Hant,zh-Bopo ja ko; do
        sed -Ei "
          s|^([ \t]*<family lang=\""$_lang"\">)|\1$(format_CJKRegular "$FONT_CJK")|;
        " $MODPATH/$__x
      done
      cp -f $TMPDIR/$FONTSPATH/$FONT_CJK $MODPATH/$FONTSPATH/
    fi
  fi
done


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
