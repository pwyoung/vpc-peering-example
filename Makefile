.PHONY=default apply plan format FORCE

D:=./aws/non-prod/Development

# Just go into the directory specified in $D and run the given target

default: plan

apply: FORCE
	cd $(D) && make $1

plan: FORCE
	cd $(D) && make $1

format: FORCE
	terraform fmt -recursive

FORCE:
