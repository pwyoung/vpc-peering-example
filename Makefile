D:=./aws/non-prod/us-east-1/Development/root

# Just go into the directory specified in $D and run the given target
%: FORCE
	cd $(D) && make $1

