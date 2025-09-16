
# format_Static <static font prefix>
format_Static() {
    local template font_static=$1

    template='\n'\
'        <font weight="100" style="normal">'"$font_static"'-Thin.ttf</font>\n'\
'        <font weight="100" style="italic">'"$font_static"'-ThinItalic.ttf</font>\n'\
'        <font weight="300" style="normal">'"$font_static"'-Light.ttf</font>\n'\
'        <font weight="300" style="italic">'"$font_static"'-LightItalic.ttf</font>\n'\
'        <font weight="400" style="normal">'"$font_static"'-Regular.ttf</font>\n'\
'        <font weight="400" style="italic">'"$font_static"'-Italic.ttf</font>\n'\
'        <font weight="500" style="normal">'"$font_static"'-Medium.ttf</font>\n'\
'        <font weight="500" style="italic">'"$font_static"'-MediumItalic.ttf</font>\n'\
'        <font weight="900" style="normal">'"$font_static"'-Black.ttf</font>\n'\
'        <font weight="900" style="italic">'"$font_static"'-BlackItalic.ttf</font>\n'\
'        <font weight="700" style="normal">'"$font_static"'-Bold.ttf</font>\n'\
'        <font weight="700" style="italic">'"$font_static"'-BoldItalic.ttf</font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}

# format_9Weight <font> <width>
format_9Weight() {
    local template font=$1 width=$2
    local _weight _italic

    template='\n'\
$(for _italic in 0:normal 1:italic; do
    for _weight in $(seq 100 100 900); do
    echo -n ''\
'        <font weight="'"$_weight"'" style="'"${_italic#*:}"'">'"$font"'\n'\
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

# format_VF <font> <width>
format_VF() {
    local template font=$1 width=$2

    template='\n'\
'        <font supportedAxes="wght,ital">'"$font"'\n'\
'          <axis tag="wdth" stylevalue="'"$width"'" />\n'\
'        </font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}

# format_CJKRegular <font>
format_CJKRegular() {
    local template font=$1

    template='\n'\
'        <font weight="400" style="normal">'"$font"'</font>\n'\
'    </family>\n'\
'    <family>'

    echo -n "$template"
}
