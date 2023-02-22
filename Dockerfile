# image with gcc+make, intended as build image for s2i
# see https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
# see also https://github.com/openshift/source-to-image/issues/966#issuecomment-782186438
# about redhat has no intention of making s2i work with podman
# no builder provided assemble script, perhaps we can keep that with src
FROM		registry.access.redhat.com/ubi9/ubi-minimal:9.1.0
LABEL		description = "ubi9 minimal with make and gcc" \
		maintainer = "imaginary-person@example.net"
RUN		microdnf -y install gcc make; microdnf -y update; microdnf -y clean all
COPY		sample.txt /root
CMD		["/bin/sh"]
