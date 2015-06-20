from mod_python import apache
import os, urllib, subprocess as sub

def cmd(req):
    str_command = req.parsed_uri[apache.URI_QUERY]

    if str_command.split("=")[0] == "1":
        if str_command.split("=")[1] == "1":
            if str_command.split("=")[2] == "1":
                x = "1b00000111" #111
            else:
                x = "1b00000110" #110
        else:
            if str_command.split("=")[2] == "1":
                x = "1b00000101" #101
            else:
                x = "1b00000100" #100
    else:
        if str_command.split("=")[1] == "1":
            if str_command.split("=")[2] == "1":
                x = "1b00000011" #011
            else:
                x = "1b00000010" #010
        else:
            if str_command.split("=")[2] == "1":
                x = "1b00000001" #001
            else:
                x = "1b00000000" #000





    if str_command.split("=")[3] == "1":
        if str_command.split("=")[4] == "1":
            if str_command.split("=")[5] == "1":
                y = "1900000000" #000
            else:
                y = "1900000001" #001
        else:
            if str_command.split("=")[5] == "1":
                y = "1900000010" #010
            else:
                y = "1900000011" #011
    else:
        if str_command.split("=")[4] == "1":
            if str_command.split("=")[5] == "1":
                y = "1900000100" #100
            else:
                y = "1900000101" #101
        else:
            if str_command.split("=")[5] == "1":
                y = "1900000110" #110
            else:
                y = "1900000111" #111




    strcmd = "echo " + x + " > /proc/superip"
    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())

    strcmd = "echo " + y + " > /proc/superip"
    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())

    return strcmd + "\n" + output

