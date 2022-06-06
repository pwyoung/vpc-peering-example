# This facilitates development

.PHONY=default FORCE clean destroy apply build validate format graph

# default shell (for push/pop etc)
SHELL=/bin/bash

# "terragrunt run-all plan --terragrunt-non-interactive" requires that
# dependencies have already been built.
#
# We can use "terragrunt run-all plan --terragrunt-non-interactive"
# to validate the entire system after it is built.
#
# "terragrunt run-all plan" will interactively ask you to call modules
# that are dependencies for the module againstg which the "plan" is run.
# That's good, but not needed here.
#
PLAN=terragrunt run-all plan --terragrunt-non-interactive

# Force terragrunt to build a module and all its dependencies.
#
# The non-interactive version of this will ignore (not run) dependent modules.
APPLY=yes y | terragrunt run-all apply

# Make an image with the dependencies for the project
#
# This works under the current directory.
# It finds modules and builds the graph, respecting dependencies.
GRAPH=terragrunt graph-dependencies | dot -Tsvg > ~/tf-dependencies.svg

# Find all modules under this directory and destroy them
#
# This works under the current directory.
# It finds and destroys modules, respecting dependencies.
DESTROY=terragrunt run-all destroy --terragrunt-non-interactive

# This will fetch the latest module source.
# This is necessary if the module source or location has changed.
UPDATE=terragrunt run-all get -update

RANT=../../../rant.txt

# The first target will be called by 'make' with no args.
# Name it 'default' for readability.
default: build

# Standard "make" targets (for convenience)
build: validate
clean: destroy

# This forces a target to run even if there is a file in the local dir with the
# name of the target. Also, this is good for readability
FORCE:

format: FORCE
	terraform fmt -recursive
	find ./ -name "*.hcl" 2>/dev/null | grep -v '.terra' | xargs terragrunt hclfmt

update: FORCE
	$(UPDATE)

apply: FORCE
	cd ./global/main && $(APPLY)

# Call this right after apply
validate: apply
	echo "Validating the last run by making sure the plan shows no changes are needed"
	cd ./global/main && $(PLAN)

# Do not call plan unless calling it right after apply
plan: FORCE
	if [ -f $(RANT) ]; then cat $(RANT); fi

destroy: FORCE
	$(DESTROY)

graph: validate
	$(GRAPH)
