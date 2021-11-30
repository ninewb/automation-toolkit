pathRepository=$1

NOW=$(date +"%m-%d-%Y %T")
cd $pathRepository
regex='nothing to commit, working tree clean'
echo "${NOW} - Script Initiated..."
status=$(git status)

if [[ $status =~ $regex ]]; then
    echo "Nothing Changes"
    exit
fi

userSshAgent=$2
if [[ -n "${userSshAgent:-}" ]]; then
    echo $2 
    ssh-agent bash -c $2
fi

git push
echo "Commits pushed: $NOW"
exit
