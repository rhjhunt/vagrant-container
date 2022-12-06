FROM registry.fedoraproject.org/fedora:37

LABEL name="vagrant-container" \
      version="2.3.3-1" \
      architecture="x86_64" \
      url="https://github.com/rhjhunt/vagrant-container" \
      vcs-type="git" \
      vcs-url="https://github.com/rhjhunt/vagrant-container.git" \
      distribution-scope="public" \
      summary="vagrant is a tool to quickly create virtual machines" \
      maintainer="Jacob Hunt <jhunt@redhat.com>" \
      run="podman run --rm -it --volume /run/libvirt:/run/libvirt --volume ${HOME}:${HOME}:rslave \
           --env HOME=${HOME} --workdir $(pwd) --net host --privileged --security-opt label=disable \
           quay.io/rhjhunt/vagrant-container:latest"

RUN INSTALL_PKGS=" https://releases.hashicorp.com/vagrant/2.3.3/vagrant-2.3.3-1.x86_64.rpm \
	openssh-clients libvirt-daemon-kvm qemu-kvm libvirt-devel xz \
	make rdesktop ansible gcc gcc-c++ ruby ruby-devel rubygems rubygem-fog-libvirt rubygem-nokogiri cpio cmake \
	rubygem-bundler rubygem-rdoc rubygem-rspec rubygem-thor rubygems-devel libxml2-devel dnf-plugins-core \
	flex bison libxml2-devel libxslt-devel wget perl-vars crontabs" && \
    dnf install -y --setopt=install_weak_deps=0 --nodocs ${INSTALL_PKGS} && \
    dnf clean all --enablerepo='*'

ENTRYPOINT ["/bin/bash"]
