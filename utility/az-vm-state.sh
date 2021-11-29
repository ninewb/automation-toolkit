#!/bin/sh
# Used to remotely manage Azure VM state.

function main__HELP()
{
  echo "
Usage:
  az-vm-state [options] 

Options:
  -u, --start             Start all VM's allocated in a Resource Group
  -d, --stop              Stop all VM's allocated in a Resource Group
  -s, --status            Check VM status in a Resource Group
  -g, --resource-group    Set the Azure Resource Group
  -a, --subscription      Set the Azure Subscription
  -h, --help              This small usage guide

Description:
  Used to remotely manage Azure VM state. Passing the subscroption ensures the correct account is grounded.  The resource group is necessary to query all VM's. 
  "
  exit 0
}

function main()
{
  local -xgr program="$(readlink -f "${BASH_SOURCE[0]}")"
  local -r OPTIONS=$(getopt -o g:a::sudh -l "resource-group:,subscription:,start,stop,status,help" -n "${FUNCNAME[0]}" -- "$@") || return
  eval set -- "$OPTIONS"

  ResourceGroup=
  Subscription=
  State=
  while true ; do
    case "$1" in
      -g|--resource-group)    ResourceGroup="$2"; shift 2;;
      -a|--subscription)      Subscription="$2"; shift 2;;
      -u|--start)             State=execStart; shift;;
      -d|--stop)              State=execStop; shift;;
      -s|--status)            State=execStatus; shift;;
      -h|--help)              main__HELP; shift;;
      --)                  shift; break;;
      *)                   break;;
    esac
  done

  # Verify Flags
  [[ -n $ResourceGroup ]] || { echo "ABORTED: Missing Azure Resource Group"; return 1; }
  [[ -n $Subscription ]] || { echo "ABORTED: Missing Azure Subscription"; return 1; }
  [[ -n $State ]] || { echo "Choose a desired state: Start, Stop, Status"; return 1; }

${State}
}

function execStatus()
{
  az account set --subscription="${Subscription}"
  az vm list --resource-group ${ResourceGroup} --show-details --query "[?contains(powerState,'VM')]" -o table
}

function execStart()
{
  echo "Executing startup of VM's allocated under ${ResourceGroup}."
  az account set --subscription="${Subscription}"
  az vm start --ids $(az vm list -g ${ResourceGroup} --query "[].id" -o tsv) > /dev/null 2>&1
}

function execStop()
{
  echo "Executing shutdown of VM's allocated under ${ResourceGroup}."
  az account set --subscription="${Subscription}"
  az vm stop --ids $(az vm list -g ${ResourceGroup} --query "[].id" -o tsv) > /dev/null 2>&1
}

main "$@"
