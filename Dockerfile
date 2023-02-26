# image intended for s2i task in tekton with openjdk.
# hangs with s2i-task 0.3, because needs newer buildah image
# see https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
# see also https://github.com/openshift/source-to-image/issues/966#issuecomment-782186438
# about redhat has no intention of making s2i work with podman
# s2i fails if we don't provide s2i dir.
# tar needed by s2i to unpack sources.

FROM		registry.access.redhat.com/ubi9/ubi-minimal:9.1.0
LABEL		description="test java in s2i" \
		maintainer="imaginary-person@example.net" \
		io.k8s.description="test java in s2i" \
		io.k8s.display-name="test java in s2i" \
		io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"
# do update first, so we dont break layer by installing another package
RUN		microdnf -y update;
# wget: for jdk download
# gnupg2: for signature validation
# tar: for s2i save-image
# gzip: for tar.gz files
RUN		microdnf -y install wget gnupg2 tar gzip; microdnf -y clean all
COPY		./s2i/bin/ /usr/libexec/s2i
COPY		./java/ /opt/java
RUN		cd /opt/java && sh java-install.sh
USER		1001
CMD		["/usr/libexec/s2i/usage"]
