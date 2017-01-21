#!/bin/sh
. /etc/thinstation.global

log()
{
	/bin/logger -t "auto-usb-audio" "${1}"
	echo "`date` ${1}" >> /var/log/auto-usb-audio.log
}

main()
{
	log "Wrapper Start"
	{
	    setsid /etc/udev/scripts/auto-usb-audio.sh >& /dev/null
	} &
	log "Wrapper End"
}

main
