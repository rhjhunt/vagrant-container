FROM registry.fedoraproject.org/fedora:36

LABEL name="vagrant-container" \
      version="2.3.0" \
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

RUN dnf -y --setopt=tsflags='' update && \ 
    dnf -y --setopt=tsflags='' install https://releases.hashicorp.com/vagrant/2.3.0/vagrant-2.3.0-1.x86_64.rpm && \
    dnf -y --setopt=tsflags='' install openssh-clients libvirt-daemon-kvm qemu-kvm libvirt-devel xz \
    make rdesktop ansible gcc gcc-c++ ruby ruby-devel rubygems rubygem-fog-libvirt rubygem-nokogiri cpio cmake \
    rubygem-bundler rubygem-rdoc rubygem-rspec rubygem-thor rubygems-devel libxml2-devel dnf-plugins-core \
    flex bison libxml2-devel libxslt-devel wget perl-vars crontabs && \
    ## The following steps are a workaround for the following bugs
    ## https://github.com/vagrant-libvirt/vagrant-libvirt/issues/1127
    ## https://github.com/hashicorp/vagrant/issues/11020
    #echo 'export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"' >> /etc/profile && \
    #mkdir workaround && \
    #cd workaround && \
    #wget https://vault.centos.org/8.3.2011/BaseOS/Source/SPackages/krb5-1.18.2-5.el8.src.rpm && \
    #rpm2cpio krb5-1.18.2-5.el8.src.rpm | cpio -imdV && \
    #tar xf krb5-1.18.2.tar.gz && \
    #cd krb5-1.18.2/src && \
    #LDFLAGS='-L/opt/vagrant/embedded/' ./configure && \
    #make && \
    #cp lib/libk5crypto.so.3 /opt/vagrant/embedded/lib64 && \
    #cd ../../ && \
    #dnf download --source libssh && \
    #rpm2cpio libssh*.src.rpm | cpio -imdV && \
    #tar xf libssh-*.tar.xz && \
    #mkdir build && \
    #cd build && \
    #cmake ../libssh-* -DOPENSSL_ROOT_DIR=/opt/vagrant/embedded/ && \
    #make && \
    #cp lib/libssh* /opt/vagrant/embedded/lib64 && \
    #cd ../../ && \
    ## Workaround to build vagrant-libvirt on Fedora 34
    #rm -rf workaround && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENTRYPOINT ["/bin/bash"]
