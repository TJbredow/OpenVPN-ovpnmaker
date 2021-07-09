#!/bin/bash

# First argument: Client identifier

KEY_DIR=pki/private
CRT_DIR=pki/issued
OUTPUT_DIR=client-configs/files
BASE_CONFIG=client-configs/base.conf
TA_DIR=client-configs/keys
CA_DIR=client-configs/keys
./easyrsa gen-req ${1} nopass

./easyrsa sign-req client ${1}

echo Making ${1}.ovpn ...

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${CA_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${CRT_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    ${TA_DIR}/ta.key \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_DIR}/${1}.ovpn

echo Configuration file saved at ${OUTPUT_DIR}/${1}.ovpn
