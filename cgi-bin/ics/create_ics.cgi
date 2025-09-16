#!/bin/bash

# Output HTTP headers
echo "Content-Type: text/calendar"
echo "Content-Disposition: attachment; filename=event.ics"
echo ""

# Read POST data (form input) into QUERY_STRING variable
read -r QUERY_STRING

# Function to URL decode
url_decode() {
  echo -e "$(sed 's/+/ /g;s/%/\\x/g' <<<"$1")"
}

# Parse form fields
for kv in ${QUERY_STRING//&/ }
do
  IFS='=' read -r key val <<< "$kv"
  val=$(url_decode "$val")
  case $key in
    summary) summary=$val ;;
    description) description=$val ;;
    location) location=$val ;;
    date) date=$val ;;
    start_time) start_time=$val ;;
    end_time) end_time=$val ;;
  esac
done

# Default values if empty
summary=${summary:-No Title}
description=${description:-}
location=${location:-}
date=${date:-}
start_time=${start_time:-}
end_time=${end_time:-}

# Output iCalendar content
cat <<EOF
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//YourProduct//EN
BEGIN:VEVENT
SUMMARY:$summary
DESCRIPTION:$description
LOCATION:$location
DTSTART:${date}T${start_time}00Z
DTEND:${date}T${end_time}00Z
END:VEVENT
END:VCALENDAR
EOF
