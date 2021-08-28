switch:
	nix-shell --run "flk $(shell uname -n) switch"
.PHONY: switch

build:
	nix-shell --run "flk $(shell uname -n) build"
.PHONY: build
