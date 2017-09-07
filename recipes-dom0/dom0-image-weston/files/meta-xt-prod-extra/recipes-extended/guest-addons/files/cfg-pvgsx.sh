#!/bin/sh
#
# Setup XenStore entries for DRM paravirtualized driver.
#
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

PVDEV_NAME="vgsx"
FRONTEND_ID=$1
BACKEND_ID=0
DEV_ID=0
OSID=$2

usage () {
        echo "Usage: `basename $0` <frontend-id> <osid>"
        echo "    <frontend-id>: the domain id of frontend"
        echo "    <osid>: PVR OSID of the domain"
        exit 1
}

# no default parameters, if not 2 then quit
[ $# -eq 2 ] || usage

# Configure PV generic entries
./cfg-pvback.sh $PVDEV_NAME $FRONTEND_ID $BACKEND_ID $DEV_ID

$XSWRITE /local/domain/$FRONTEND_ID/device/$PVDEV_NAME/$DEV_ID/osid $OSID

