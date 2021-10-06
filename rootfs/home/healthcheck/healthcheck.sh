#!/usr/bin/env bash

# Import healthchecks-framework
source /opt/healthchecks-framework/healthchecks.sh

# MSGTIMELIMIT is maximum time in seconds that the system has reported the last MSG before things go UNHEALTHY
MSGTIMELIMIT=300

APPNAME="$(hostname)/healthcheck"

touch /run/msgtimelimit
[[ "$(cat /run/msgtimelimit | wc -l)" == "0" ]] && echo "0" > /run/msgtimelimit

if (( "$(date +%s)" - "$(cat /run/msgtimelimit)" > "$MSGTIMELIMIT" ))
then
    echo "[$APPNAME][$(date)] Warning: Last MSG entry in the logs was "$(( "$(date +%s)" - "$(cat /run/msgtimelimit)" ))" seconds ago, which is within the $MSGTIMELIMIT secs limit. Setting state to UNHEALTHY"
    exit 1
else
    echo "[$APPNAME][$(date)] Last MSG entry in the logs was "$(( "$(date +%s)" - "$(cat /run/msgtimelimit)" ))" seconds ago, which is within the $MSGTIMELIMIT secs limit. Setting state to HEALTHY"
fi
exit 0
