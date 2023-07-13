ROOT_DIR!= git rev-parse --show-toplevel
export ROOT_DIR
include ${ROOT_DIR}/conf/make.conf
export STAGE_SYNC_DIR
export PRODUCTION_SYNC_DIR
export OUTPUT_DIR=$(ROOT_DIR)/compiled/public
export STAGE_DIR=$(ROOT_DIR)/compiled/stage
export DEPLOY_DIR=$(ROOT_DIR)/compiled/deploy
export WEBPACK_MODE:=development

.PHONY: all clean raw css stage lint eslint lintspell clean_css clean_js js # TODO EXPAND THIS

all: clean default-js default-css raw 
default-raw: clean raw
default-js: clean_js js
default-css: clean_css css 

stage: export OUTPUT_DIR=$(STAGE_DIR)
stage: export SYNC_DIR=$(STAGE_SYNC_DIR)
stage: all sync

stage-css: export OUTPUT_DIR=$(STAGE_DIR)
stage-css: export SYNC_DIR=$(STAGE_SYNC_DIR)
stage-css: default-css sync

stage-js: export OUTPUT_DIR=$(STAGE_DIR)
stage-js: export SYNC_DIR=$(STAGE_SYNC_DIR)
stage-js: default-js sync

stage-raw: export OUTPUT_DIR=$(STAGE_DIR)
stage-raw: export SYNC_DIR=$(STAGE_SYNC_DIR)
stage-raw: clean raw sync

restage: export OUTPUT_DIR=$(STAGE_DIR)
restage: export SYNC_DIR=$(STAGE_SYNC_DIR)
restage: sync

deploy: export WEBPACK_MODE=production
deploy: export OUTPUT_DIR=$(DEPLOY_DIR)
deploy: export SYNC_DIR=$(PRODUCTION_SYNC_DIR)
deploy: all sync

deploy-css: export OUTPUT_DIR=$(DEPLOY_DIR)
deploy-css: export SYNC_DIR=$(PRODUCTION_SYNC_DIR)
deploy-css: default-css sync

deploy-js: export WEBPACK_MODE=production
deploy-js: export OUTPUT_DIR=$(DEPLOY_DIR)
deploy-js: export SYNC_DIR=$(PRODUCTION_SYNC_DIR)
deploy-js: default-js sync

deploy-raw: export OUTPUT_DIR=$(DEPLOY_DIR)
deploy-raw: export SYNC_DIR=$(PRODUCTION_SYNC_DIR)
deploy-raw: clean raw sync

redeploy: export OUTPUT_DIR=$(DEPLOY_DIR)
redeploy: export SYNC_DIR=$(PRODUCTION_SYNC_DIR)
redeploy: sync

sync:
	@echo "***sync***"
	@echo SYNC_DIR: $(SYNC_DIR)
	@ ! [ -z $(SYNC_DIR) ] || echo "You need make.conf, see README"
	@ ! [ -z $(SYNC_DIR) ]
	rsync -tr --delete $(OUTPUT_DIR)/ $(SYNC_DIR)/

clean:
	@echo "***clean***"
	sudo -E -u nobody -- rm ${OUTPUT_DIR}/* -rf

clean_css: 
	@echo "***clean_css***"
	sudo -E -u nobody -- rm ${ROOT_DIR}/compiled/css/* ${OUTPUT_DIR}/css/* -rf

clean_js: 
	@echo "***clean_js***"
	sudo -E -u nobody -- rm ${ROOT_DIR}/compiled/js/* ${OUTPUT_DIR}/js/* -rf

raw: 
	@echo "***raw***"
	sudo -E -u nobody -- mkdir -p $(OUTPUT_DIR)/js
	sudo -E -u nobody -- mkdir -p $(OUTPUT_DIR)/css
	OUTPUT_DIR=${OUTPUT_DIR}/js sudo -E -u nobody -- build_scripts/main ${ROOT_DIR}/compiled/js
	OUTPUT_DIR=${OUTPUT_DIR}/css sudo -E -u nobody -- build_scripts/main ${ROOT_DIR}/compiled/css
	sudo -E -u nobody -- build_scripts/main

css:
	@echo "***css***"
	sudo -E -u nobody -- build_scripts/css
	sudo -E -u nobody -- mkdir -p $(OUTPUT_DIR)/css
	OUTPUT_DIR=${OUTPUT_DIR}/css sudo -E -u nobody -- build_scripts/main ${ROOT_DIR}/compiled/css

js:
	@echo "***js***"
	sudo -E -u nobody -- build_scripts/jstranspile
	sudo -E -u nobody -- mkdir -p $(OUTPUT_DIR)/js
	OUTPUT_DIR=${OUTPUT_DIR}/js sudo -E -u nobody -- build_scripts/main ${ROOT_DIR}/compiled/js

lint: 
	@echo "***lint***"
	sudo -E -u nobody -- build_scripts/lint

lintspell: export INTERACTIVE=true
lintspell:
	@echo "***lintspell***"
	sudo -E -u nobody -- /bin/bash build_scripts/lint

eslint:
	@echo "***eslint***"
	sudo -E -u nobody -- build_scripts/eslint

