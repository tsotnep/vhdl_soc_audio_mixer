from mod_python import apache
import os, urllib, subprocess as sub

def cmd(req):
    str_command = req.parsed_uri[apache.URI_QUERY]

    if str_command.split("=")[0] == "left":
        a = str_command.split("=")[1]
        b = int(a)*38
        c = hex(int(b))
        d = c.split("x")[1]
        if len(d) < 3:
            d = "0"*(3-len(d)) + d
        x = "0f00000" + d

    elif str_command.split("=")[0] == "right":
        a = str_command.split("=")[1]
        b = int(a)*38
        c = hex(int(b))
        d = c.split("x")[1]
        if len(d) < 3:
            d = "0"*(3-len(d)) + d
        x = "1000000" + d


    elif str_command.split("=")[0] == "bal":
        a = str_command.split("=")[1]
        b = hex(int(a))
        c = b.split("x")[1]
        if len(c) < 2:
            c = "0"*(2-len(c)) + c
        x = "11000000" + c

    strcmd = "echo " + x + " > /proc/superip"
    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())

    return strcmd + "\n" + output


