.ONESHELL:

SHELL := $(shell which bash)

PROJECT_NAME   := files_to_db
ROOT_DIRECTORY := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
TEST_DIRECTORY := $(realpath ./test)
DATABASE       := files.db
DATABASE_TABLE := files

all:
.PHONY: all

test: export FDB_ROOT_DIRECTORY = $(ROOT_DIRECTORY)
test: export FDB_TEST_DIRECTORY = $(TEST_DIRECTORY)
test: export FDB_DATABASE       = $(DATABASE)
test: export FDB_DATABASE_TABLE = $(DATABASE_TABLE)
test: export FDB_COMMAND        = $(ROOT_DIRECTORY)/files_to_db
test:
	@$(TEST_DIRECTORY)/runner.sh
.PHONY: test

clean:
	@rm -rf "$(TEST_DIRECTORY)"/.fdb_*
.PHONY: clean

