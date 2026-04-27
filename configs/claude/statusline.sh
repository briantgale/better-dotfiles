#!/usr/bin/env bash
input=$(cat)
session_name=$(echo "$input" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('session_name', ''))" 2>/dev/null)

[ -z "$session_name" ] && exit 0

captain=$(echo "$session_name" | awk '{print $1}')
rest=$(echo "$session_name" | awk '{$1=""; sub(/^ /, ""); print}')

case "${captain,,}" in
  picard)  icon="🖖" ;;
  sisko)   icon="⚾" ;;
  janeway) icon="☕" ;;
  archer)  icon="🚀" ;;
  *)       icon="⭐" ;;
esac

[ -n "$rest" ] && echo "$icon $captain | $rest" || echo "$icon $captain"
