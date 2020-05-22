# vagrant-container

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
