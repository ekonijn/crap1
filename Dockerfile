# Try locally building an image, any image
FROM		registry.access.redhat.com/ubi8/ubi:8.7-1026
LABEL		description = "ubi8 image with random modification" \
		maintainer = "imaginary-person@example.net"
RUN		dnf -y update; dnf -y clean all
COPY		sample.txt /root
CMD		["/bin/sh"]
