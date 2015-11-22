#!/bin/bash

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

declare -a CAPTIONS
declare -a COMMANDS

while read line ; do

  if [[ "${line}" == caption:* ]]
  then CAPTIONS=("${CAPTIONS[@]}" "${line/caption:\ /}")
  fi

  if [[ "${line}" == command:* ]]
  then COMMANDS=("${COMMANDS[@]}" "${line/command:\ /}")
  fi

done  < <(cat config/options.json | python parse.py)

OPTIONS=""

for i in "${!CAPTIONS[@]}"
do OPTIONS="$OPTIONS $i ${CAPTIONS[$i]}"
done


# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}


while true
do
exec 3>&1
### display main menu ###
menuitem=$(  dialog \
              --clear \
              --backtitle "di-exec" \
              --title "[ SELECT A COMMAND ]" \
              --cancel-label "Exit" \
              --menu "Use UP/DOWN arrow keys, Choose the command" \
              20 150 12 \
              $OPTIONS \
              2>&1 1>&3 )

exit_status=$?

exec 3>&-
case $exit_status in
  $DIALOG_CANCEL)
    clear
    echo "Program terminated."
    exit
    ;;
  $DIALOG_ESC)
    clear
    echo "Program aborted." >&2
    exit 1
    ;;
esac

clear
echo "Executing! \"${COMMANDS[$menuitem]}\" " $'\n\n'
sleep 1
eval ${COMMANDS[$menuitem]}
read -p "Press [Enter] key to continue..."

# ## confirmation dialog ###
# dialog \
# --clear \
# --title "Execute confirmation" \
# --backtitle "Shell Script execution" \
# --yesno "Are you sure you want to execute ${CAPTIONS[$menuitem]}? \n Command: ${COMMANDS[$menuitem]}"\
# 7 60
#
# response=$?
# case $response in
#    0)
#     echo "Executing!\n\n"
#     sleep 2
#     ${COMMANDS[$menuitem]}
#     ;;
#    1) echo "Execution stoped!.";;
#    255) echo "[ESC] Execution stoped!.";;
# esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
