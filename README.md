**Deprecation notice: I have migrated this configuration to [a new repository](https://github.com/akirak/nix-config), so I am not maintaining this repository any more**

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]

This is my configuration for NixOS and home-manager, based on [DevOS][devos].

## Installation

This repository is currently made public for referencing, so it may not be possible
to run it on your machine.

I clone this repository to `~/flk` directory:

```sh
git clone https://github.com/akirak/flk.git
```

Each NixOS host must be configured in [hosts/](hosts/) directory in this repository.
Once you configure the host, you can update the machine by running

```sh
make switch
```

## License
DevOS is licensed under the [MIT License][mit].

[mit]: https://mit-license.org
[devos]: https://github.com/divnix/devos
