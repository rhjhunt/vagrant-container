FROM registry.fedoraproject.org/fedora:33

LABEL name="vagrant-container" \
      version="2.2.15" \
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
    dnf -y --setopt=tsflags='' install https://releases.hashicorp.com/vagrant/2.2.15/vagrant_2.2.15_x86_64.rpm && \
    dnf -y --setopt=tsflags='' install openssh-clients libvirt-daemon-kvm qemu-kvm libvirt-devel xz \
    make rdesktop ansible gcc gcc-c++ ruby rubygems rubygem-fog-libvirt rubygem-nokogiri cpio cmake \
    rubygem-bundler rubygem-rdoc rubygem-rspec rubygem-thor rubygems-devel libxml2-devel dnf-plugins-core \
    flex bison libxml2-devel libxslt-devel wget perl-vars && \
    # The following steps are a workaround for the following bugs
    # https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1127
    # https://github.com/hashicorp/vagrant/issues/11020
    echo 'export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"' >> /etc/profile && \
    mkdir workaround && \
    cd workaround && \
    wget http://vault.centos.org/8.2.2004/BaseOS/Source/SPackages/krb5-1.17-18.el8.src.rpm && \
    rpm2cpio krb5-1.17-18.el8.src.rpm | cpio -imdV && \
    tar xf krb5-1.17.tar.gz && \
    cd krb5-1.17/src && \
    LDFLAGS='-L/opt/vagrant/embedded/' ./configure && \
    make && \
    cp lib/libk5crypto.so.3 /opt/vagrant/embedded/lib64 && \
    cd ../../ && \
    dnf download --source libssh && \
    rpm2cpio libssh-0.9.5-1.fc33.src.rpm | cpio -imdV && \
    tar xf libssh-0.9.5.tar.xz && \
    mkdir build && \
    cd build && \
    cmake ../libssh-0.9.5 -DOPENSSL_ROOT_DIR=/opt/vagrant/embedded/ && \
    make && \
    cp lib/libssh* /opt/vagrant/embedded/lib64 && \
    cd ../../ && \
    rm -rf workaround && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENTRYPOINT ["/bin/bash"]
