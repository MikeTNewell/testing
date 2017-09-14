#!/bin/bash
#
# Author : Jon Zobrist <jon@jonzobrist.com>
# Homepage : http://www.jonzobrist.com
# License : BSD http://en.wikipedia.org/wiki/BSD_license
# Copyright (c) 2012, Jon Zobrist
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Purpose : This script aims to gather all public ssh keys on a server and put them in a directory, with appropriate names
# Usage : gather-public-ssh-keys.sh [Directory]

if [ "${1}" ]
 then
	OUTPUT_DIR="${1}"
 else
	OUTPUT_DIR="./pubkeys"
fi

mkdir -p ${OUTPUT_DIR}
echo "Writing keys to ${OUTPUT_DIR}"

HOME_DIR="/home"
CHOWN_USER="root:root"
CHMOD_PERMS="400"
KEYFILES="id_rsa.pub id_dsa.pub identity.pub id_ecdsa.pub authorized_keys"

for USER in $(/bin/ls -1 ${HOME_DIR})
 do
 	for KEY in ${KEYFILES}
	 do
		if [ -f "${HOME_DIR}/${USER}/.ssh/${KEY}" ]
		 then
			FILE=${OUTPUT_DIR}/${USER}-${KEY}
			echo "${USER} has public keys, copied to ${FILE}"
			touch ${FILE}
			chown ${CHOWN_USER} ${FILE}
			chmod ${CHMOD_PERMS} ${FILE}
			cp ${HOME_DIR}/${USER}/.ssh/authorized_keys ${FILE}
		else
			echo "${USER} has no public keys"
		fi
	done
done

