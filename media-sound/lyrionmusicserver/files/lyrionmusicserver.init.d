#!/sbin/openrc-run
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# These fit the Lyrion Music Server ebuild and so shouldn't need to be
# changed; user-servicable parts go in /etc/conf.d/lyrionmusicserver.
lms=lyrionmusicserver
rundir=/run/${lms}
bindir=/opt/${lms}

lmsuser=${lms}
pidfile=${rundir}/${lms}.pid
lmsbin=${bindir}/slimserver.pl

depend() {
	need net
}

start_pre() {
	checkpath -q -d -o ${lmsuser}:${lmsuser} -m 0770 "${rundir}"
}

start() {
	ebegin "Starting Lyrion Music Server"

	cd /
	start-stop-daemon \
		--start --exec ${lmsbin} \
		--pidfile ${pidfile} \
		--user ${lmsuser} \
		--background \
		-- \
		--quiet \
		--nomysqueezebox \
		--pidfile ${pidfile} \
		${LMS_OPTS}

	eend $? "Failed to start Lyrion Music Server"
}

stop() {
	ebegin "Stopping Lyrion Music Server"
	start-stop-daemon --retry 10 --stop --pidfile ${pidfile}
	eend $? "Failed to stop Lyrion Music Server"
}
