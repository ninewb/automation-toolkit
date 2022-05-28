#!/bin/bash

function f_rc {
    "$@"
    local RC=$?
    echo $RC
    if [ $RC != 0 ] 
    then
      if [ $RC == 1 ]
      then
        echo "WARNING detected in $1" >&2
      elif [ $RC == 2 ]
      then
        echo "ERROR detected in $1" >&2
      elif [ $RC == 3 ]
      then
        echo "User issued ABORT on $1" >&2
      elif [ $RC == 4 ]
      then
       echo "User issued ABORT RETURN on $1" >&2
      elif [ $RC == 5 ]
      then 
        echo "User issued ABORT ABEND on $1" >&2
      elif [ $RC == 6 ]
      then
        echo "SAS Internal Error Occured on $1" >&2
      else 
        echo "Something went wrong in processing on $1, Return Code: $RC" >&2
      fi
    fi
    return ${status}
}

# Usage: f_rc [command][optios]




