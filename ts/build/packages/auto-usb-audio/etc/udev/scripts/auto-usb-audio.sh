#!/bin/sh
. /etc/thinstation.global

log()
{
	/bin/logger -t "auto-usb-audio" "${1}"
	echo "`date` ${1}" >> /var/log/auto-usb-audio.log
}

wait_for_pulseaudio()
{
	log "waiting for pulseaudio"
	i=0
	while [ $i -le 120 ]; do
		((i++))
		pulsepid=`pidof pulseaudio`
		if [ $pulsepid ]; then
			log "pulse found, PID = $pulsepid"
			break
		fi
	done
	log "wait 5 seconds after"
	sleep 5s
}

set_usb_output()
{
	usbout=`pacmd list-sinks | grep 'name:' | grep usb | grep output | sed 's/.*<//g;s/>.*//g;' | head -n 1`
	log "usbout is ${usbout}"

	if [ ! -z "${usbout// }" ]; then
		log "found usb output: ${usbout}"
		pacmd set-default-sink "${usbout}"
	fi
}

set_usb_input()
{
	usbin=`pacmd list-sources | grep 'name:' | grep usb | grep input | sed 's/.*<//g;s/>.*//g;' | head -n 1`
	log "usbin is ${usbin}"

	if [ ! -z "${usbin// }" ]; then
		log "found usb input: ${usbin}"
		pacmd set-default-source "${usbin}"
	fi
}

main()
{
	log "Script Start, waiting"
	wait_for_pulseaudio
	set_usb_output
	set_usb_input
	log "Script End"
}

main
