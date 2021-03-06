#!/bin/bash
#
# Author : Jon Zobrist <jon@jonzobrist.com>
# Homepage : http://www.jonzobrist.com
# License : BSD http://en.wikipedia.org/wiki/BSD_license
# Copyright (c) 2012, Jon Zobrist
# All rights reserved.
#
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
# Purpose : This script backs up directories & MySQL to a bucket in S3, and restores them
# Usage : bluesun-setup.sh [start|stop|updateS3]
# WARNING : Running this script with start will DELETE your local versions of whatever you have it set to backup
# WARNING : Running this script with start will DELETE your local versions of whatever you have it set to backup
# WARNING : Running this script with start will DELETE your local versions of whatever you have it set to backup

echo "${0} called with ${@}" >> /var/log/bluesun-setup-init.log 2>&1
case "${1}" in
	start)
		/etc/init.d/bluesun-setup.sh start 2>&1 >> /var/log/bluesun-setup-start.log 2>&1
	;;
	stop)
		/etc/init.d/bluesun-setup.sh stop 2>&1 >> /var/log/bluesun-setup-stop.log 2>&1
	;;
	*)
		#Catch any other way we're being called in a logfile
		echo "/etc/init.d/bluesun-setup.sh start 2>&1 >> /var/log/bluesun-setup-wildcard.log 2>&1"
	;;
esac
