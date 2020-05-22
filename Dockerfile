FROM registry.fedoraproject.org/fedora:31

LABEL name="vagrant-container" \
      version="1.0" \
      architecture="x86_64" \
      URL="https://github.com/rhjhunt/vagrant-container" \
      vcs-type="git" \
      vcs-url="https://github.com/rhjhunt/vagrant-container.git" \
      distribution-scope="public" \
      summary="vagrant is a tool to quickly create virtual machines" \
      maintainer="Jacob Hunt <jhunt@redhat.com>" \
      run="podman run --rm -it --volume /run/libvirt:/run/libvirt --volume ${HOME}:${HOME}:rslave \
           --env HOME=${HOME} --workdir $(pwd) --net host --privileged --security-opt label=disable \
           quay.io/rhjhunt/vagrant-container:latest"

RUN dnf -y --setopt=tsflags='' update && \ 
    dnf -y --setopt=tsflags='' install openssh-clients vagrant vagrant-libvirt \
    vagrant-registration vagrant-sshfs vagrant-hostmanager ansible && \
    dnf clean all && \
    rm -rf /var/cache/yum 

ENTRYPOINT ["/bin/bash"]