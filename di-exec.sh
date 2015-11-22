#!/bin/bash

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title
	dialog --backtitle "Select the command to execute: " --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
  #
}

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


while true
do

### display main menu ###
dialog \
--clear \
--backtitle "di-exec" \
--title "[ SELECT A COMMAND ]" \
--menu "Use UP/DOWN arrow keys, Choose the command" 15 150 4 \
$OPTIONS 2>"${INPUT}"

menuitem=$(<"${INPUT}")

clear
echo "Executing! \"${COMMANDS[$menuitem]}\" " $'\n\n'
sleep 2
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
