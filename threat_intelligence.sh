#!/bin/bash

echo
echo "threat intelligence"
echo

echo "web/http/https:"
echo
echo "<IfDefine REJECT>"
echo "<AuthzProviderAlias ip reject-ips \"`cat /tmp/web.txt`\">"
echo "</AuthzProviderAlias>"
echo "</IfDefine>"
echo
echo
echo
echo "mail/smtp:"
echo
cat /tmp/mail.txt
