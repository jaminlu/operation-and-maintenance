#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: lmj
import json
import sys
import commands
from datetime import datetime
def main(config_dict):
    domains = config_dict['domains']
    for domain in domains:
        cmd = "echo | openssl s_client -servername %s -connect %s:443 2>/dev/null | openssl x509 -noout -dates | grep After" %(domain,domain)
        (status, output) = commands.getstatusoutput(cmd)
        if status == 0:
            deadline=output.split('=')[1]  #GMT时间
        GMT_FORMAT = '%b %d %H:%M:%S %Y GMT'
        nowDate = datetime.utcnow().strftime(GMT_FORMAT)

        #format nowtime-->GMT
        newTime = datetime.strptime(nowDate,"%b %d %H:%M:%S %Y %Z")
        deadline1 = datetime.strptime(deadline,"%b %d %H:%M:%S %Y %Z")


        gapTime = deadline1 - newTime
        print("The domain %s ca has  %s days left" % (domain,gapTime.days))

if __name__ == '__main__':

    if len(sys.argv) !=2:
        print('Usage: %s domain.conf' % (sys.argv[0]))
        sys.exit(1)
    config_dict = {}
    with open(sys.argv[1],"r") as fp:
        config_dict=json.loads(fp.read())

    if not config_dict:
        print("ERROR: domain.conf can NOT be empty: %s" %(sys.argv[1]))
        sys.exit(1)

    main(config_dict)
