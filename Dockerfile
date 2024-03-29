# image intended for jdk task in tekton with openjdk.
# hangs with s2i-task 0.3, because needs newer buildah image
# see https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
# see also https://github.com/openshift/source-to-image/issues/966#issuecomment-782186438
# about redhat has no intention of making s2i work with podman
# s2i fails if we don't provide s2i dir.
# tar needed by s2i to unpack sources.

FROM		registry.access.redhat.com/ubi9/ubi-minimal:9.2-750
LABEL		description="test java" \
		maintainer="imaginary-person@example.net" \
		io.k8s.description="test java" \
		io.k8s.display-name="test java" \
		io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"
# do update first, so we dont break layer by installing another package
RUN		microdnf -y update;
# wget: for jdk download
# gnupg2: for signature validation
# tar: for unpack java/mvn images
# gzip: for tar.gz files
# shadow-utils: for useradd
RUN		microdnf -y install shadow-utils wget gnupg2 tar gzip; microdnf -y clean all
COPY		./java/ /opt/java
COPY		./mvn/ /opt/mvn
RUN		cd /opt/java && sh java-install.sh
RUN		cd /opt/mvn && sh mvn-install.sh
# user must exist with homedir, to have a place for .m2
RUN		useradd -u 1001 app
USER		app
CMD		["/bin/sh"]
