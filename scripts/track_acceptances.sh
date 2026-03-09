#!/usr/bin/bash
INVITE_UUID=$1;
ST_TOKEN=$2;
INVITE_INFO=$(smartthings edge:channels:invites $INVITE_UUID --json --token $ST_TOKEN);

echo $INVITE_INFO | jq .

NAME=$(echo $INVITE_INFO | jq .metadata.name);
OWNER=$(echo $INVITE_INFO | jq .metadata.owner);
DESCRIPTION=$(echo $INVITE_INFO | jq .metadata.description);
TERMS=$(echo $INVITE_INFO | jq .metadata.termsUrl);
ACCEPTANCES=$(echo $INVITE_INFO | jq .acceptances);
ACCEPT_URL=$(echo $INVITE_INFO | jq .acceptUrl);

python -c "
from sys import argv

template = '''
json```
{}
```
'''

template = template.format(argv[1])

content = None
with open('readme_template', 'r') as template_doc:
    tag = 'channel-info-here'
    content = template_doc.read()
    content = content.replace(tag, template)
    with open('README.md', 'w') as readme:
        readme.write(content)
" "$($INVITE_INFO | jq .)";
