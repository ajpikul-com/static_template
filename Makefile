export CONF_FILE ?= ./conf/default.contate

.PHONY: all clean contate css stage lint eslint lintspell

export STAGE_DIR=""
export PRODUCTION_DIR=""

all: clean clean_css contate css

stage: export CONF_FILE = ./conf/stage.contate
stage: all
ifeq (, $(STAGE_DIR))
	echo "****"
	echo "Please specify a STAGE_DIR"
	echo "****"
	exit 1
endif
	rsync -tr --delete stage/ $(STAGE_DIR)

deploy: export CONF_FILE = ./conf/deploy.contate
deploy: all
ifeq (, $(PRODUCTION_DIR))
	echo "****"
	echo "Please specify a PRODUCTION_DIR"
	echo "****"
	exit 1
endif
	rsync -tr --delete deploy/ $(PRODUCTION_DIR)

clean: 
	build_scripts/clean

clean_css:
	build_scripts/clean_css

clean_tsc:
	biuild_scripts/clean_js

contate: clean
	build_scripts/main

css: clean_css
	build_scripts/css

tsc: clean_tsc
	build_scripts/typescript

lint:
	build_scripts/lint

lintspell: export INTERACTIVE=true
lintspell:
	/bin/bash build_scripts/lint

eslint:
	build_scripts/eslint

tsling:
	#place holder
