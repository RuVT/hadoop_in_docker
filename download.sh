url=${1}
directory=${2:-"./"}

while [ 1 ]; do
	wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --continue -P ${directory} ${url} 
	if [ $? = 0 ]; then break; fi; # check return value, break if successful (0)
	sleep 1s;
done;

