#!/bin/bash
trap "kill -- -$BASHPID" SIGINT SIGTERM EXIT
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
hasuser=0
user=""
terminal=""
forceupdate=0

spinner()
{
    local pid=$1
    local delay=0.5
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}


#gatherusers() {
#	for HOST in moore{00..24} sslab{00..24} borg{00..24} xinu{00..21} sac{01..13} pod{1..5}-{1..5} pod0-0 mc{01..18}; do
#		echo $HOST
# who > who.txt && sed -i 's/^/data /' who.txt && awk '{ print $1,$2,$3 }' who.txt >> users.log 
#		ssh -o StrictHostKeyChecking=no `whoami`@${HOST}.cs.purdue.edu "who > who.txt && sed -i 's/^/${HOST} /' who.txt && awk '{ print \$1,\$2,\$3 }' who.txt >> ~/users.log"  >>/tmp/deploy_test 2>&1
#	done

#	echo "Done."
#}
LOGFILE=~/users.log

buildusers()
{
	rm $LOGFILE
	./gatherusers.bash & 
	spinner $!
}

attemptbuildusers() {
	if [ $forceupdate -eq 1 ]; then
		buildusers
	else 
		if [ `find "$LOGFILE" -mmin +30` ]; then
			buildusers
		else
			if [ $verbose ]; then
				echo Using old logfile.
			fi
		fi
	fi
}

show_help()
{
	echo -e "Search for users on Purdue CS computers."
	echo -e "Usage: ./getAllUsers.bash -u USERNAME [-t TERMINAL] [-v|-f|-?|-h]"
	echo -e "\t-u USERNAME"
	echo -e "\t\tThe username of the user to search for."
	echo -e "\t-t TERMINAL"
	echo -e "\t\tThe terminal the user is logged in on. Allows for immediate messaging of a user."
	echo -e "\t-v\n\t\tVerbose output"
	echo -e "\t-f"
	echo -e "\t\tForce an update of the users log. This can take a while, so default operation reuses files under 30m old" 
	echo -e "\t-h | -?"
	echo -e "\t\tDisplay this help"
}


while getopts "h?u:t:fv" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    u)  hasuser=1
    	user=$OPTARG
        ;;
    t)  terminal=$OPTARG
        ;;
    f)	forceupdate=1
    	;;
    v) 	verbose=1
    	;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ $verbose ]; then
	echo "user=$user, terminal='$terminal', verbose=$verbose, forceupdate=$forceupdate, Leftovers: $@"
fi

if [[ $hasuser ]]; then
	attemptbuildusers 
	found=$(grep $user ~/users.log)
	if [ -n "$found"  ]; then
		echo "The user $user is logged in on: $found"
	else
		echo "The user $user is not logged in."
	fi
fi
exit 0





