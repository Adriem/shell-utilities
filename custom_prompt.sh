# ==============================================================================
#  custom_propmt.sh
# ------------------------------------------------------------------------------
#  Custom prompt that displays <username>: <current-dir> $. It allows to set up
#  a different prompt for the root user.
#  Copy this file into /etc/profile.d/ to enable this prompt
#
#  Author: Adrian Moreno
# ==============================================================================

BLACK_PROMPT="\[\e[1;30m\]\u: \[\e[0;30m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
RED_PROMPT="\[\e[1;31m\]\u: \[\e[0;31m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
GREEN_PROMPT="\[\e[1;32m\]\u: \[\e[0;32m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
YELLOW_PROMPT="\[\e[1;33m\]\u: \[\e[0;33m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
BLUE_PROMPT="\[\e[1;34m\]\u: \[\e[0;34m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
PURPLE_PROMPT="\[\e[1;35m\]\u: \[\e[0;35m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
CYAN_PROMPT="\[\e[1;36m\]\u: \[\e[0;36m\]\W\[\e[1;37m\] \\$ \[\e[m\]"
WHITE_PROMPT="\[\e[1;37m\]\u: \[\e[0;37m\]\W\[\e[1;37m\] \\$ \[\e[m\]"

case "$TERM" in
screen*|xterm*|rxvt*)
    # Root prompt
    if [[ $EUID -eq 0 ]]; then
        PS1=$RED_PROMPT
    # Non root prompt
    else
        PS1=$WHITE_PROMPT
    fi
    ;;
*)
    ;;
esac
