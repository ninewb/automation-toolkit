
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export _BASE=/workspace
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export _BASE=~/workspace
else
  echo "We could not determine the OS, aborting."
  exit 1
fi

################################################################################
# shell
################################################################################

set -o emacs
export TMOUT=9999999999
export TERM=xterm
export CRON_TZ="America/New_York"

################################################################################
# variables
################################################################################

export MAINDIR=/workspace
#export BASEDIR=$(pwd)
#export AUTOROOT=$(dirname ${BASEDIR})
export AUTOROOT=${MAINDIR}/sas-automation

export LOGDIR=${MAINDIR}/logs
export LOGDATE=$(date +%Y-%m-%d)

export NOTESDIR=${MAINDIR}/notes
export HISTORY=${NOTESDIR}/history

export SCRATCH=scratch.md
export MODDATE=$(date -r ${NOTESDIR}/${SCRATCH} +%F)


################################################################################
# aliases
################################################################################

alias ll='ls -ltrh'
alias lh='ls -latrh'
alias grep='grep --color=auto'
alias rr='source ~/.bash_profile'
alias cpr='ps -ef | grep $1'
alias err='grep -rn "ERROR:" $1'
alias fc='grep "$1" *.log|cut -d":" -f l|wc'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias notes='cd ${NOTESDIR}'
alias scratch='mv ${NOTESDIR}/${SCRATCH} ${HISTORY}/${SCRATCH}-${MODDATE}; vi ${NOTESDIR}/${SCRATCH}' 

alias viup='vistart'
alias vidown='vistop'

################################################################################
# GIT specific
################################################################################

export GITLOG=git_${LOGDATE}.log


################################################################################
# SAS specific
################################################################################

if [ -d /opt/sas/viya ]; then
        alias vlog='cd /opt/sas/viya/config/var/log'
        alias vlogm='cd /opt/sas/master/config/var/log'
        alias vlogp='cd /opt/sas/playpen/config/var/log'
        alias vlogt='cd /opt/sas/test/config/var/log'
        alias vsys='cd /etc/sysconfig/sas'
        alias kvsrc='source ${NSRC}/toolkit/token'
        export SPREHOME=/opt/sas/spre/home
    export SASVIYAHOME=/opt/sas/viya/home
    export SASVIYAUTIL=$SPREHOME/SASFoundation/utilities
    export PATH=$PATH:$SPREHOME/bin:$SASVIYAHOME/bin:$SASVIYAUTIL/bin
fi

################################################################################
# Functions
################################################################################

function vistart {
  cd ${AUTOROOT}/utility/
  ./az-vm-state.sh --start --subscription sas-ninewb --resource-group sasviya3
  ./sas-viya-service.sh -start > ${LOGDIR}/vistart_${LOGDATE}.log  
}

function vistop {
  cd ${AUTOROOT}/utility/
  ./sas-viya-service.sh -stop > ${LOGDIR}/vistop_${LOGDATE}.log
  ./az-vm-state.sh --stop --subscription sas-ninewb --resource-group sasviya3
}
