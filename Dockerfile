FROM fedora:32

ARG UID=1000

# Standard RPM build tools
RUN dnf install -y \
  fedora-packager \
  rpmdevtools

# Create a packager user
RUN useradd makerpm -o -u $UID \
  && usermod -a -G mock makerpm

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER makerpm
RUN mkdir -p /home/makerpm/rpmbuild/BUILD
RUN mkdir -p /home/makerpm/rpmbuild/BUILDROOT
RUN mkdir -p /home/makerpm/rpmbuild/RPMS
RUN mkdir -p /home/makerpm/rpmbuild/SOURCES
RUN mkdir -p /home/makerpm/rpmbuild/SPECS
RUN mkdir -p /home/makerpm/rpmbuild/SRPMS

VOLUME ["/home/makerpm/rpmbuild/SPECS"]
WORKDIR /home/makerpm

USER root

# BuildRequires
RUN dnf install -y \
  git \
  qt-devel \
  make \
  golang

USER makerpm
