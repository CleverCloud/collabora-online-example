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
    collaboraofficebasis6.4-ar \
    collaboraofficebasis6.4-as \
    collaboraofficebasis6.4-ast \
    collaboraofficebasis6.4-bg \
    collaboraofficebasis6.4-bn-in \
    collaboraofficebasis6.4-br \
    collaboraofficebasis6.4-ca \
    collaboraofficebasis6.4-calc \
    collaboraofficebasis6.4-ca-valencia \
    collaboraofficebasis6.4-core \
    collaboraofficebasis6.4-cs \
    collaboraofficebasis6.4-cy \
    collaboraofficebasis6.4-da \
    collaboraofficebasis6.4-de \
    collaboraofficebasis6.4-draw \
    collaboraofficebasis6.4-el \
    collaboraofficebasis6.4-en-gb \
    collaboraofficebasis6.4-en-us \
    collaboraofficebasis6.4-es \
    collaboraofficebasis6.4-et \
    collaboraofficebasis6.4-eu \
    collaboraofficebasis6.4-extension-pdf-import \
    collaboraofficebasis6.4-fi \
    collaboraofficebasis6.4-fr \
    collaboraofficebasis6.4-ga \
    collaboraofficebasis6.4-gd \
    collaboraofficebasis6.4-gl \
    collaboraofficebasis6.4-graphicfilter \
    collaboraofficebasis6.4-gu \
    collaboraofficebasis6.4-he \
    collaboraofficebasis6.4-hi \
    collaboraofficebasis6.4-hr \
    collaboraofficebasis6.4-hu \
    collaboraofficebasis6.4-id \
    collaboraofficebasis6.4-images \
    collaboraofficebasis6.4-impress \
    collaboraofficebasis6.4-is \
    collaboraofficebasis6.4-it \
    collaboraofficebasis6.4-ja \
    collaboraofficebasis6.4-km \
    collaboraofficebasis6.4-kn \
    collaboraofficebasis6.4-ko \
    collaboraofficebasis6.4-lt \
    collaboraofficebasis6.4-lv \
    collaboraofficebasis6.4-ml \
    collaboraofficebasis6.4-mr \
    collaboraofficebasis6.4-nb \
    collaboraofficebasis6.4-nl \
    collaboraofficebasis6.4-nn \
    collaboraofficebasis6.4-oc \
    collaboraofficebasis6.4-ooofonts \
    collaboraofficebasis6.4-ooolinguistic \
    collaboraofficebasis6.4-or \
    collaboraofficebasis6.4-pa-in \
    collaboraofficebasis6.4-pl \
    collaboraofficebasis6.4-pt \
    collaboraofficebasis6.4-pt-br \
    collaboraofficebasis6.4-ro \
    collaboraofficebasis6.4-ru \
    collaboraofficebasis6.4-sk \
    collaboraofficebasis6.4-sl \
    collaboraofficebasis6.4-sr \
    collaboraofficebasis6.4-sr-latn \
    collaboraofficebasis6.4-sv \
    collaboraofficebasis6.4-ta \
    collaboraofficebasis6.4-te \
    collaboraofficebasis6.4-tr \
    collaboraofficebasis6.4-uk \
    collaboraofficebasis6.4-vi \
    collaboraofficebasis6.4-writer \
    collaboraofficebasis6.4-zh-cn \
    collaboraofficebasis6.4-zh-tw \
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