#!/bin/bash

blank='#00000000'  # blank
#background='#1A6785FF'
background='#2e3440'
foreground='#D8DEE9FF'  # text

primary='#4c566a'  # default
alert='#81a1c1'  # wrong
verifying='#A3BE8CFF'  # verifying

i3lock \
--color=$background \
\
--screen  \
--indicator \
--keylayout \
--force-clock \
\
--insidever-color=$background   \
--insidewrong-color=$background \
--inside-color=$background      \
\
--ringver-color=$primary        \
--ringwrong-color=$alert        \
--ring-color=$primary           \
\
--line-color=$primary           \
--line-uses-inside              \
\
--keyhl-color=$alert            \
--bshl-color=$alert             \
\
--separator-color=$primary      \
\
--verif-color=$foreground       \
--wrong-color=$foreground       \
--time-color=$foreground        \
--date-color=$foreground        \
--layout-color=$foreground      \
\
--time-align=0 \
--date-align=0 \
--layout-align=0 \
--verif-align=0 \
--wrong-align=0 \
--modif-align=0 \
\
# --blur 5              \
--indicator           \
--keylayout 2         \
\
--verif-text=""          \
--wrong-text=""          \
# --clock               \
# --timestr="%H:%M:%S"  \
# --line-uses-inside       \
# --datestr="%A, %m %Y" \
# --textsize=20
# --modsize=10
#--time-font=noto-sans    \
#--datefont=noto-sans    \
# etc

