#!/usr/bin/env bash
set -u
readonly ENABLE_DEBUG=${ENABLE_DEBUG:-1}

msg_debug() {
  if [[ $ENABLE_DEBUG -eq 1 ]];then
    printf "%s\\n" "[DEBUG]$(date "+[%F_%T]"):${FUNCNAME[1]}:$1" >&2
  fi
}

get_datetime_filename () {
  msg_debug "start"
  local _target="$1"
  local _pat='^([0-9]{4}-[0-9]{2}-[0-9]{2}) [0-9]{2}\.[0-9]{2}\.[0-9]{2}\.'
  local _date
  if [[ "$(basename "$_target")" =~  $_pat ]]; then
    _date="${BASH_REMATCH[1]}"
  else
    msg_debug "'$_target' does not contain the name."
    return 1
  fi
  printf "%s\\n" "$_date"
}

get_datetime_exif () {
  msg_debug "start"
  local _target="$1"
  local _date
  _date="$(identify -verbose "$_target" | awk '/exif:DateTime:/{gsub(":","-",$2); printf $2}')"
  if [[ -z "${_date}" ]];then
    printf "%s\\n" "Warning:$_target: 'exitf:DateTime' is empty." >&2
    return 1
  fi
  printf "%s\\n" "$_date"
}

get_datetime_modified () {
  msg_debug "start"
  local _target="$1"
  if ! stat -c '%y' "$_target" | awk '{print $1}' ;then
    printf "%s\\n" "Warning:$_target: stat command was not succeeded." >&2
    return 1
  fi
}

get_datetime () {
  msg_debug "start"
  local _target="$1"
  local _date
  _date=$(get_datetime_filename "$_target") && {
    printf "%s\\n" "$_date"
    return 0
  }
  _date=$(get_datetime_exif "$_target") && {
    printf "%s\\n" "$_date"
    return 0
  }
  _date=$(get_datetime_modified "$_target") && {
    printf "%s\\n" "$_date"
    return 0
  }
  return 1
}

main () {
  local _target="$1"
  local _date
  if _date="$(get_datetime "$_target")" ;then
    printf "%s\\n" "$_date"
    return 0
  else
    printf "%s\\n" "Error:$_target: date cannot be set." >&2
    return 1
  fi
}

main ${1+"$@"}
exit $?
