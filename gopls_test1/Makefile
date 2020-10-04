# https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9
# http://www.lunderberg.com/2015/08/25/cpp-makefile-pretty-output/
# http://agdr.org/2020/05/14/Polyglot-Makefiles.html
# https://tech.davis-hansson.com/p/make/

export BASHOPTS						:= extglob:globstar:nullglob:failglob:gnu_errfmt:localvar_unset:dotglob:xpg_echo:functrace:verbose
export SHELLOPTS					:= allexport:braceexpand:emacs:errexit:errtrace:hashall:ignoreeof:interactive-comments:keyword:monitor:noclobber:noglob:nolog:notify:nounset:onecmd:physical:pipefail:posix:vi
export SHELLCHECK_OPTS		?= --shell=bash --check-sourced --external-sources
export TERM								?= xterm-256color

.DEFAULT_GOAL							:= all
# .DELETE_ON_ERROR:
MAKEFLAGS 								+= --environment-overrides --warn-undefined-variables #--no-builtin-rules --no-builtin-variables #--print-directory

# .ONESHELL:
SHELL										:= bash
# IFS											= $'\n\t'

export SCREEN_RESET			:= $(shell tput reset)
export SCREEN_CLEAR			:= $(shell tput clear)
export TAB							:= $(shell printf '\011')
export INDENT						:= $(shell tput ht)
# export INDENT						:= "  "

export RESET						:= $(shell tput sgr0)
export BOLD   					:= $(shell tput bold)
export RED							:= $(shell tput bold; tput setaf 1)
export GREEN						:= $(shell tput bold; tput setaf 2)
export YELLOW						:= $(shell tput bold; tput setaf 3)

export DIR_NAME					:= $(shell basename $(shell pwd))
export DIR_FULL_PATH		:= $(shell pwd)
export VERBOSE					:=

export PATH							:= $(shell echo ${GOPATH}/bin:${PATH})
export MODULE_NAME			:= github.com/banaio/vscode-settings/golang

export VERBOSE_FLAGS		?= -v -x
export VERBOSE_FLAGS		?=

# 1 = print_separator_prefix: prevent warnings from turning on `--warn-undefined-variables` `Makefile` flag.
1 :=
define print_separator
	@print_separator_prefix=$(if $1,$1,$@); \
		prefix="$${print_separator_prefix}:  "; \
		line_terminator=$$'\n'; \
		printf "%b" "${GREEN}" "$${prefix}" `printf -- '-%.0s' $$(seq 1 $$(expr $$(tput cols) - $${#prefix} - $${#line_terminator}))` "${RESET}" "$${line_terminator}"
endef

.PHONY: all
all: pre_commit

# This allows us to accept extra arguments (by doing nothing when we get a job that doesn't match, rather than throwing an error).
%:
	@:

.PHONY: pre_commit
pre_commit:
	$(print_separator)
	$(call print_separator,"started $@")
	@$(MAKE) debug_env
	@$(MAKE) clean
	@$(MAKE) format
	@$(MAKE) run
	$(call print_separator,"completed $@")

.PHONY: run
run:
	$(print_separator)
	$(call print_separator,"started $@")
	go run main.go
	$(call print_separator,"completed $@")

.PHONY: modules
modules:
	go list -f echo github.com/banaio/vscode-settings/golang/mod{1,2,3}
	go list -m echo github.com/banaio/vscode-settings/golang/mod{1,2,3}

.PHONY: format
format:
	$(print_separator)
	$(call print_separator,"$@: cleaning up modules running go mod tidy")
	go list -f {{.Dir}} ./... | xargs -n1 -I{} bash -c 'cd {}; go mod tidy -v'
	$(call print_separator,"$@: formatting files running goimports")
	@for DIR in $(shell go list -f {{.Dir}} ./...); do \
		printf "%s: ${GREEN}%s${RESET}=%s\n" "formatting" "dir" $$(realpath --relative-to=. "$${DIR}"); \
		goimports -v -e -w -local ${MODULE_NAME} $${DIR}/; \
	done

# When cleaning we are only interested in errors hence the pipe to `/dev/null` for stdout.
.PHONY: clean
clean:
	$(print_separator)
	$(call print_separator,"$@: dry run started on go clean")
	@go clean -n -i -r -cache -testcache -modcache ./... 1>/dev/null || (printf "${YELLOW}WARN:${RESET} %s\n" "failed on go clean dry run, exit_code=$$?"; exit 0)
	$(call print_separator,"$@: proper go clean")
	@go clean ${VERBOSE_FLAGS} -i -r -cache -testcache -modcache ./... 1>/dev/null || (printf "${YELLOW}YELLOW:${RESET} %s\n" "failed on go clean, exit_code=$$?"; exit 0)
	@printf "${GREEN}INFO:${RESET} %s\n" "go clean completed"


.PHONY: debug_env
debug_env: VARS_BUILD:=DIR_NAME DIR_FULL_PATH VERBOSE
debug_env:
	$(print_separator)
	$(call print_separator,"VARS_BUILD $@")
	@VARS_BUILD_PRINT=$$( \
		printf '%s\n' ${VARS_BUILD} | \
		xargs -n1 -IV bash -c 'printf "$${INDENT}$${GREEN}%s$${RESET}=%s\n" 'V' "$$(eval "echo $${V}")"' | \
		sort -i \
	); \
	echo "$${VARS_BUILD_PRINT}"
	$(call print_separator,"VARIABLES $@")
	@printf -- '%s\n' $(foreach V, $(filter-out  SCREEN_RESET SCREEN_CLEAR .VARIABLES, $(sort $(.VARIABLES))), \
		$(if $(filter file, $(origin $(V))), \
			'${INDENT}${GREEN}$V${RESET}=$($V) ($(value $V))' \
		) \
	)

# https://github.com/mvdan/gofumpt
.PHONY: install_tools
install_tools: lint
	$(print_separator)
	cd ${GOPATH}; \
		go get mvdan.cc/gofumpt; \
		go get mvdan.cc/gofumpt/gofumports; \
		go get -u github.com/rakyll/gotest; \
		printf -- '%s\n' \
			"gofumpt=$$(command -v gofumpt 2> /dev/null)" \
			"gofumports=$$(command -v gofumports 2> /dev/null)" \
			"gotest=$$(command -v gotest 2> /dev/null)"
