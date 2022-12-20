#!/bin/bash
OUR_IP=$(hostname -i)

if [ -z "$1" ]; then
  tail -f /dev/null
else
  # unknown option ==> call command
  echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
  echo "Executing command: '$@'"
  exec "$@"
fi
