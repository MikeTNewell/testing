#!/bin/bash

vagrant halt -f
vagrant destroy -f
vagrant up --provision

# Check that status is 200 OK
status_code=$(vagrant ssh -c "curl -k -s -o /dev/null -w \"%{http_code}\" https://127.0.0.1/" 2> /dev/null)

if [[ $status_code == "200" ]]
then
    echo "Pass: status code is ${status_code}";
else
    echo "Fail: status code is ${status_code}";
fi

response=$(vagrant ssh -c "curl -k https://127.0.0.1/" 2> /dev/null)

# Verify x-forwarded-for is in the response body and not "None"
fwd_for=$(echo "$response" | grep "X-Forwarded-For: 127.0.0.1")
if [[ "${fwd_for}" != "" ]]
then
    echo "Pass: X-Forwarded-For is present and not 'None'";
else
    echo "Fail: X-Forwarded-For should not be 'None'";
fi

# Verify x-real-ip is in the response body and not "None"
real_ip=$(echo "$response" | grep "X-Real-IP: 127.0.0.1")
if [[ "${real_ip}" != "" ]]
then
    echo "Pass: X-Real-IP is present and not 'None'";
else
    echo "Fail: X-Real-IP should not be 'None'";
fi

content=$(echo "$response" | grep "Learn from the mistakes of others. You can never live long enough to make them all yourself.")
if [[ "$content" != "" ]]
then
  echo "Pass: found \"Learn from the mistakes of others. You can never live long enough to make them all yourself.\" in response"
else
  echo "Fail: \"Learn from the mistakes of others. You can never live long enough to make them all yourself.\" missing from response"
fi
