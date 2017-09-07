#!/bin/sh
#
# Setup XenStore entries for a paravirtualized driver.
#
# Based on the script written by Noboru Iwamatsu <[hidden email]>
# Copyright (c) 2016 Oleksandr Andrushchenko
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

XSWRITE=`which xenstore-write`
XSCHMOD=`which xenstore-chmod`

usage () {
	echo "Usage: `basename $0` <pvdev-name> <frontend-id> <backend-id> <device-id>"
	echo "    <pvdev-name>: PV device name"
	echo "    <frontend-id>: the domain id of frontend"
	echo "    <backend-id>: the domain id of backend"
	echo "    <device-id>: the device id of frontend (instance number)"
	echo ""
	echo "Example:"
	echo "    If you use paravirtual sound driver on Domain ID 1,"
	echo "    simply do"
	echo "    `basename $0` vsnd 1 0 0"
	exit 1
}

# no default parameters, if not 4 then quit
[ $# -eq 4 ] || usage

PVDEV_NAME=$1
FRONTEND_ID=$2
BACKEND_ID=$3
DEV_ID=$4

# Write backend information into the location that frontend looks for.
$XSWRITE /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID/version 1
$XSWRITE /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID/versions 1

$XSWRITE /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID/backend-id $BACKEND_ID
$XSWRITE /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID/backend \
/local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID

# Write frontend information into the location that backend looks for.
$XSWRITE /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID/frontend-id $FRONTEND_ID
$XSWRITE /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID/frontend \
/local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID

# Set permissions
$XSCHMOD -r /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID "b$FRONTEND_ID"
$XSCHMOD -r /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID "b$BACKEND_ID"
$XSCHMOD -r /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID "b$FRONTEND_ID"
$XSCHMOD -r /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID "b$BACKEND_ID"

# Set state to XenbusStateInitialising
$XSWRITE /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID/state 1
$XSWRITE /local/domain/$BACKEND_ID/backend/$PVDEV_NAME/$FRONTEND_ID/$DEV_ID/state 1
