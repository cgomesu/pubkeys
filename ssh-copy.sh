#!/usr/bin/env bash
##########################################################
# script to install all public keys on a remote ssh server
##########################################################
end_trap() {
    echo "Received a signal to end the script before the EOF."; exit 1;
}
# parse args
while getopts 'u:h:s' OPT; do
  case ${OPT} in
    h) hostname="$OPTARG";;
    u) username="$OPTARG";;
    s) use_sftp=1;;
    *) echo "Only -h hostname/ip and -u username are valid options.";exit 1;;
  esac
done
# check mandatory and set target
if [ -z "$hostname" ]; then echo "Missing mandatory hostname/ip (-h)"; exit 1; fi
if [ -n "$username" ]; then target="$username@$hostname"; else target="$hostname"; fi
# install pub keys on remote monitoring interrupts
trap end_trap INT HUP TERM
for file in ./*; do
  if [[ "$file" =~ \.pub$ ]]; then
    if [[ "$use_sftp" -eq 1 ]]; then
        ssh-copy-id -sf -i "$file" "$target"
    else
        ssh-copy-id -f -i "$file" "$target"
    fi
  fi
done
exit 0
