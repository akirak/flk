switch:
	nix-shell --run "bud rebuild $(shell uname -n) switch"
.PHONY: switch

build:
	nix-shell --run "bud rebuild $(shell uname -n) build"
.PHONY: build
