# This facilitates development

# RANT
#   It took some testing and time to figure out all the weirdness/inconsistencies with Terragrunt.
#   Specifically, differences between their apply/plan/destroy commands.
#
#   What it comes down to is this:
#   - TG "run-all destroy" works as expected (finds all sub-modules and deletes them, respecting dependencies)
#   - TG "run-all apply" ignores dependencies (unless you run it interactively)
#   - TG "run-all plan" does not work across dependent modules that have not been built yet.
#     Specifically, it does not give a recursive plan, showing what would happen if you were
#     to run TG Apply and interactively build all dependencies.
#     Per https://terragrunt.gruntwork.io/docs/reference/cli-options/#run-all,
#       "[WARNING] Using run-all with plan is currently broken for certain use cases"
#     Issue comment (on 5/19):
#       https://github.com/gruntwork-io/terragrunt/issues/720#issuecomment-497888756

.PHONY=default FORCE destroy apply validate format graph

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

# The first target will be called by 'make' with no args.
# Name it 'default' for readability.
default: validate

# This forces a target to run even if there is a file in the local dir with the
# name of the target. Also, this is good for readability
FORCE:

format: FORCE
	terraform fmt -recursive
	find ./ -name "*.hcl" 2>/dev/null | grep -v '.terra' | xargs terragrunt hclfmt

update: FORCE
	$(UPDATE)

apply: FORCE
# This is safe, but slower
#	$(UPDATE)
	cd ./global/main && $(APPLY)

validate: apply
	echo "Validating the last run by making sure the plan shows no changes are needed"
	cd ./global/main && $(PLAN)

graph: validate
	$(GRAPH)

destroy: FORCE
	$(DESTROY)
