#!/bin/sh

export ARKLOC=/workspace/deployment_files/sas_viya_playbook

# Delay about 2 minutes and then start our startup routine.
function execStart {
  cd ${ARKLOC}
  # Ensure the OOTB scripts are disabled
  ansible-playbook viya-ark/playbooks/viya-mmsu/viya-services-disable.yml
  ansible-playbook viya-ark/playbooks/viya-mmsu/viya-services-start.yml
}

function execStop {
 cd ${ARKLOC}
 ansible-playbook viya-ark/playbooks/viya-mmsu/viya-services-stop.yml -e "enable_stray_cleanup=true"
}

case $1 in

  ""|-?|-help|-HELP|-usage|-USAGE)
  echo "USAGE:
     -start    # Start Viya Services
     -stop     # Stop Viya Services
  "
  exit 1
;;

-start)
execStart
;;

-stop)
execStop
;;

esac

