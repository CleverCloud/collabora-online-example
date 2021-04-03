FROM ubuntu:18.04

ENV LC_CTYPE C.UTF-8

RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    fonts-open-sans \
    gnupg2 \
    ca-certificates \
    openssh-client \
    curl

RUN echo "deb https://collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu1804 /" > /etc/apt/sources.list.d/collabora.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0C54D189F4BA284D

RUN apt-get update -y && apt-get install -y \
    loolwsd \
    collaboraoffice6.4-dict* \
    collaboraofficebasis6.4-calc \
    collaboraofficebasis6.4-ca-valencia \
    collaboraofficebasis6.4-core \
    collaboraofficebasis6.4-draw \
    collaboraofficebasis6.4-en-gb \
    collaboraofficebasis6.4-en-us \
    collaboraofficebasis6.4-eu \
    collaboraofficebasis6.4-extension-pdf-import \
    collaboraofficebasis6.4-fr \
    collaboraofficebasis6.4-graphicfilter \
    collaboraofficebasis6.4-images \
    collaboraofficebasis6.4-impress \
    collaboraofficebasis6.4-ooofonts \
    collaboraofficebasis6.4-ooolinguistic \
    collaboraofficebasis6.4-writer \
    code-brand

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Remove WOPI Proof key generated by the package, we need unique key for each container
RUN rm -rf /etc/loolwsd/proof_key*

# Fix permissions
# cf. start-collabora-online.sh that is run by lool user
# # Fix domain name resolution from jails
# cp /etc/resolv.conf /etc/hosts /opt/lool/systemplate/etc/
RUN chown lool:lool /opt/lool/systemplate/etc/hosts /opt/lool/systemplate/etc/resolv.conf
# generated ssl cert/key and WOPI proof key go into /etc/loolwsd
RUN chown lool:lool /etc/loolwsd

# switch to lool user (use numeric user id to be compatible with Kubernetes Pod Security Policies)
USER 104

# Fix domain name resolution from jails
RUN cp /etc/resolv.conf /etc/hosts /opt/lool/systemplate/etc/

# Setup scripts for Collabora Online
ADD /scripts/start-collabora-online.sh /

# Entry point
CMD bash start-collabora-online.sh