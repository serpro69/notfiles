# About

This directory provides testing capabilities for these dotfiles. It is possible to test things via docker or vagrant (with virtualbox provider)

### Docker

#### Requirements

- `docker`

#### Building an image

To build the image run: `docker build -f test/Dockerfile -t dotfiles-test:latest .`

### Vagrant

#### Requirements

- `vagrant`
- `virtualbox`

#### Building a VM

To power up a vagrant box run: `vagrant up`
