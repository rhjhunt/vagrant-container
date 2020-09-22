# vagrant-container

![Docker Image CI](https://github.com/rhjhunt/vagrant-container/workflows/Docker%20Image%20CI/badge.svg)

A vagrant container image built on Fedora.

## Pull

You can pull from Quay.io:

```terminal
podman pull quay.io/rhjhunt/vagrant-container
```

You can also build your own:

```terminal
git clone https://github.com/rhjhunt/vagrant-container.git
cd vagrant-container
buildah bud -t vagrant-container .
```

## Run

You can run the container interactively with the following command.

```terminal
podman run --rm -it --volume /run/libvirt:/run/libvirt --volume ${HOME}:${HOME}:rslave \
--env HOME=${HOME} --workdir $(pwd) --net host --privileged --security-opt label=disable \
quay.io/rhjhunt/vagrant-container:latest
```

Or create an alias in your _~/.bashrc_ file.

```bash
alias vagrant='podman run --rm -it \
        --volume /run/libvirt:/run/libvirt \
        --volume "${HOME}:${HOME}:rslave" \
        --env "HOME=${HOME}" \
        --workdir "$(pwd)" \
        --net host \
        --privileged \
        --security-opt label=disable \
        --entrypoint /usr/bin/vagrant \
        quay.io/rhjhunt/vagrant-container:latest'
```

You could then use the alias to run `vagrant` commands.

```terminal
vagrant up
vagrant ssh
vagrant destroy
```

## Install Plugins

The container image doesn't have any Vagrant plugins installed, the decision was made to avoid potential conflicts by not packaging plugins.
To install plugins, assuming you have created the alias to vagrant you can simply install the plugin as you normally would.

```bash
vagrant plugin install vagrant-libvirt
```

You can verify the plugins that are installed by listing them.

```bash
$ vagrant plugin list
vagrant-hostmanager (1.8.9, global)
vagrant-libvirt (0.1.2, global)
```
