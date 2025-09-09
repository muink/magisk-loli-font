
# format_Static <font prefix> [static font prefix]
format_Static() {
    local template font=$1 font_static=$2

    template='\n'\
'        <font weight="100" style="normal">'"$font"'-Thin.ttf</font>\n'\
'        <font weight="100" style="italic">'"$font"'-ThinItalic.ttf</font>\n'\
'        <font weight="300" style="normal">'"$font"'-Light.ttf</font>\n'\
'        <font weight="300" style="italic">'"$font"'-LightItalic.ttf</font>\n'\
'        <font weight="400" style="normal">'"${font_static:-$font}"'-Regular.ttf</font>\n'\
'        <font weight="400" style="italic">'"$font"'-Italic.ttf</font>\n'\
'        <font weight="500" style="normal">'"$font"'-Medium.ttf</font>\n'\
'        <font weight="500" style="italic">'"$font"'-MediumItalic.ttf</font>\n'\
'        <font weight="900" style="normal">'"$font"'-Black.ttf</font>\n'\
'        <font weight="900" style="italic">'"$font"'-BlackItalic.ttf</font>\n'\
'        <font weight="700" style="normal">'"$font"'-Bold.ttf</font>\n'\
'        <font weight="700" style="italic">'"$font"'-BoldItalic.ttf</font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}

# format_9Weight <font prefix> <width>
format_9Weight() {
    local template font=$1 width=$2
    local _weight _italic

    template='\n'\
$(for _italic in 0:normal 1:italic; do
    for _weight in $(seq 100 100 900); do
    echo -n ''\
'        <font weight="'"$_weight"'" style="'"${_italic#*:}"'">'"$font"'-Regular.ttf\n'\
'          <axis tag="ital" stylevalue="'"${_italic%:*}"'" />\n'\
'          <axis tag="wdth" stylevalue="'"$width"'" />\n'\
'          <axis tag="wght" stylevalue="'"$_weight"'" />\n'\
'        </font>\n'
    done
done)\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}

# format_VF <font prefix> <width>
format_VF() {
    local template font=$1 width=$2

    template='\n'\
'        <font supportedAxes="wght,ital">'"$font"'-Regular.ttf\n'\
'          <axis tag="wdth" stylevalue="'"$width"'" />\n'\
'        </font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}

# format_CJKRegular <font prefix>
format_CJKRegular() {
    local template font=$1

    template='\n'\
'        <font weight="400" style="normal">'"$font"'-Regular.ttf</font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}
