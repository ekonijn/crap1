# image with gcc+make, intended as build image for s2i
# and beginning of openjdk
# see https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
# see also https://github.com/openshift/source-to-image/issues/966#issuecomment-782186438
# about redhat has no intention of making s2i work with podman
# s2i fails if we don't provide s2i dir.
# tar needed by s2i to unpack sources.

# FROM		registry.access.redhat.com/ubi9/ubi-minimal:9.1.0
FROM		docker.io/ubuntu:latest
LABEL		description="ubi9 minimal with make and gcc" \
		maintainer="imaginary-person@example.net" \
		io.k8s.description="test java in s2i" \
		io.k8s.display-name="test java in s2i" \
		io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"
# do update first, so we dont break layer by installing another package
# RUN		microdnf -y update;
RUN		apt-get update
# wget: for jdk download
# gnupg2: for signature validation
# tar: for s2i save-image
# strace: to debug java
# RUN		microdnf -y install wget gnupg2 tar gcc make; microdnf -y clean all
RUN		apt-get install -y wget gnupg2 tar strace
COPY		./s2i/bin/ /usr/libexec/s2i
COPY		./java/ /opt/java
RUN		cd /opt/java && sh java-install.sh
USER		1001
CMD		["/usr/libexec/s2i/usage"]
