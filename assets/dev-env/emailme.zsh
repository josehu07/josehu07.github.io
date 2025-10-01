#!/usr/bin/env zsh

# Required setup: https://w.amazon.com/bin/view/AmazES/RoutingLayer/TheMystiqueReloaded/dev-dekstop-emails/
#
# Usage: emailme [-s] [-m "message body"]

EMAIL_METHOD=mailx
MESSAGE_BODY=N/A
MESSAGE_SUBJECT="[DevDesk Notification] Check Host: $HOSTNAME"

SNS_TOPIC_ARN=arn:aws:sns:us-west-2:503876630877:DevDesk-Notifications
MAILX_ADDRESS=$USER@amazon.com

while getopts "sm:" opt; do
    case $opt in
        s)
            EMAIL_METHOD=sns
            ;;
        m)
            MESSAGE_BODY="$OPTARG"
            ;;
    esac
done

if [[ "$EMAIL_METHOD" == "mailx" ]]; then
    echo "$MESSAGE_BODY" | mailx -s "$MESSAGE_SUBJECT" $MAILX_ADDRESS
    
elif [[ "$EMAIL_METHOD" == "sns" ]]; then
    aws sns publish --topic-arn $SNS_TOPIC_ARN --subject "$MESSAGE_SUBJECT" --message "$MESSAGE_BODY" --no-cli-pager
    
else
    echo "Error: unknown email method '$EMAIL_METHOD'" >&2
    exit 1
fi
