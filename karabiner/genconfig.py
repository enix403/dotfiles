import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from genlib import parse, KeyboardDevice

builtin = KeyboardDevice.built_in()
galaxy65 = KeyboardDevice.external(
    vendor_id=10473,
    product_id=12645
)

parse(
    devices=[galaxy65],
    desc="Terminal: <fn> to <ctrl>",
    apps=["com.google.Chrome"],
    maps=[
        "fn+a == ctrl+a",
        "fn+b == ctrl+b",
        "fn+c == ctrl+c",
        "fn+d == ctrl+d",
        "fn+e == ctrl+e",
        "fn+f == ctrl+f",
        "fn+g == ctrl+g",
        "fn+h == ctrl+h",
        "fn+i == ctrl+i",
        "fn+j == ctrl+j",
        "fn+k == ctrl+k",
        "fn+l == ctrl+l",
        "fn+m == ctrl+m",
        "fn+n == ctrl+n",
        "fn+o == ctrl+o",
        "fn+p == ctrl+p",
        "fn+q == ctrl+q",
        "fn+r == ctrl+r",
        "fn+s == ctrl+s",
        "fn+t == ctrl+t",
        "fn+u == ctrl+u",
        "fn+v == ctrl+v",
        "fn+w == ctrl+w",
        "fn+x == ctrl+x",
        "fn+y == ctrl+y",
        "fn+z == ctrl+z",

        "fn+0 == ctrl+0",
        "fn+1 == ctrl+1",
        "fn+2 == ctrl+2",
        "fn+3 == ctrl+3",
        "fn+4 == ctrl+4",
        "fn+5 == ctrl+5",
        "fn+6 == ctrl+6",
        "fn+7 == ctrl+7",
        "fn+8 == ctrl+8",
        "fn+9 == ctrl+9",

        "fn+` == ctrl+`",
        "fn+- == ctrl+-",
        "fn+= == ctrl+=",

        "fn+[ == ctrl+[",
        "fn+] == ctrl+]",
        "fn+\\ == ctrl+\\",

        "fn+; == ctrl+;",
        "fn+' == ctrl+'",

        "fn+, == ctrl+,",
        "fn+. == ctrl+.",
        "fn+/ == ctrl+/",

        "fn+space == ctrl+space",
        "fn+enter == ctrl+enter",
        "fn+tab == ctrl+tab",
        "fn+escape == ctrl+escape",
    ]
)
