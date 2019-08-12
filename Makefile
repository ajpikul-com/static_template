export CONF_FILE ?= ./conf/default.contate

.PHONY: all clean contate css

all: clean clean_css contate css

clean: 
	build_scripts/clean

clean_css:
	build_scripts/clean_css

contate: clean
	build_scripts/main

css: clean_css
	build_scripts/css
