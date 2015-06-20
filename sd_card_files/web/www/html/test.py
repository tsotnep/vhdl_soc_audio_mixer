from __future__ import division
import os, urllib, subprocess as sub
from scipy import signal
from mod_python import apache
def cmd(req):
    req_query = req.parsed_uri[apache.URI_QUERY]
    
    #low pass filter
    def lowpass(x):
        cutoff = int(x)
        fs = 48000
        Wn = cutoff/(fs/2)
        b, a = signal.butter(2, Wn, 'lowpass', analog=False)
        return b, a


    #band pass filter
    def bandpass(x, y):
        cutoff1 = int(x)
        cutoff2 = int(y)
        fs = 48000
        Wn = [cutoff1/(fs/2), cutoff2/(fs/2)]
        b, a = signal.cheby1(1, 1, Wn, 'bandpass', analog=False)
        return b, a

    #high pass filter
    def highpass(x):
        cutoff = int(x)
        fs = 48000
        Wn = cutoff/(fs/2)
        b, a = signal.butter(2, Wn, 'highpass', analog=False)
        return b, a

    #convert to hex
    def convert(x):
        a = str(x)
        if float(a) < 0:
            b = str(2 + float(a))
            c = int(round(float("0." + b.split(".")[1])*2**30))
            d = str(bin(c)).split("b")[1]
            if not len(d) == 30:
                d = "0"*(30-len(d)) + d
            if int(a.split(".")[0]) == -1:
                e = "10"
            else:
                e = "11"
            f = e + d
            g = str(hex(int(f, 2))).split('x')[1]
            return g
        else:
            b = a
            c = int(round(float("0." + b.split(".")[1])*2**30))
            d = str(bin(c)).split("b")[1]
            if not len(d) == 30:
                d = "0"*(30-len(d)) + d
            e = str(bin(int(b.split(".")[0]))).split("b")[1]
            if not len(e) == 2:
                e = "0"*(2-len(e)) + e
            f = e + d
            g = str(hex(int(f, 2))).split('x')[1]
            if not len(g) == 8:
                g = "0"*(8-len(g)) + g
            return g


    # Retrieve the command from the query string
    # and unencode the escaped %xx chars
    #str_command = urllib.unquote(os.environ['QUERY_STRING'])
    str_command = req_query
    coeff = []

    if str_command.split("=")[0] == "low":
        b, a = lowpass(str_command.split("=")[1])
        coeff.append("00" + convert(b[0]))
        coeff.append("01" + convert(b[1]))
        coeff.append("02" + convert(b[2]))
        coeff.append("03" + convert(a[1]))
        coeff.append("04" + convert(a[2]))
    
    elif str_command.split("=")[0] == "band":
        b, a = bandpass(str_command.split("=")[1], str_command.split("=")[2])
        coeff.append("05" + convert(b[0]))
        coeff.append("06" + convert(b[1]))
        coeff.append("07" + convert(b[2]))
        coeff.append("08" + convert(a[1]))
        coeff.append("09" + convert(a[2]))


    #    a = lowpass(str_command.split("=")[1])
    #    strcmd = "echo 01AABBCCDD > /proc/superip"

    elif str_command.split("=")[0] == "high":
        b, a = highpass(str_command.split("=")[1])
        coeff.append("0a" + convert(b[0]))
        coeff.append("0b" + convert(b[1]))
        coeff.append("0c" + convert(b[2]))
        coeff.append("0d" + convert(a[1]))
        coeff.append("0e" + convert(a[2]))


    for x in coeff:
        strcmd = "echo " + x + " > /proc/superip"
        p = sub.Popen(['/bin/bash', '-c', strcmd], 
            stdout=sub.PIPE, stderr=sub.STDOUT)
        output = urllib.unquote(p.stdout.read())


    x = "1800000001"
    strcmd = "echo " + x + " > /proc/superip"
    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())

    x = "1800000000"
    strcmd = "echo " + x + " > /proc/superip"
    p = sub.Popen(['/bin/bash', '-c', strcmd], 
        stdout=sub.PIPE, stderr=sub.STDOUT)
    output = urllib.unquote(p.stdout.read())


    return strcmd + "\n" + output

#    print """\
#    Content-Type: text/html\n
#    <html><body>
#    <pre>
#    $ %s
#    %s
#    </pre>
#    </body></html>
#    """ % (strcmd, output)