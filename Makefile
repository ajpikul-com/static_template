CONF_FILE ?= ./conf/default

all: export CONF_FILE = $CONF_FILE)
all:
	build_scripts/main
