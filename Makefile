REBAR := rebar
.DEFAULT_GOAL = start

start: get-deps compile lint-ts compile-ts lint-scss compile-scss start-dev

compile-ts:
	tsc ./priv/static/javascripts/*.ts

lint-ts:
	tslint ./priv/static/javascripts/*.ts

compile-scss:
	sass ./priv/static/stylesheets/*.scss ./priv/static/stylesheets/style.css

lint-scss:
	scss-lint ./priv/static/stylesheets/

start-dev:
	./init-dev.sh

all: get-deps compile compile-app

get-deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

compile-app:
	$(REBAR) boss c=compile

test:
	$(REBAR) boss c=test_functional

help:
	@echo 'Makefile for your chicagoboss app                                      '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make help                        displays this help text            '
	@echo '   make get-deps                    updates all dependencies           '
	@echo '   make compile                     compiles dependencies              '
	@echo '   make compile-app                 compiles only your app             '
	@echo '                                    (so you can reload via init.sh)    '
	@echo '   make test                        runs functional tests              '
	@echo '   make all                         get-deps compile compile-app       '
	@echo '                                                                       '
	@echo 'DEFAULT:                                                               '
	@echo '   make all                                                            '
	@echo '                                                                       '

.PHONY: all get-deps compile compile-app help test
