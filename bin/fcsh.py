#!/usr/bin/python2.7

# This script is a wrapper for fcsh to give it a better user interface and to
# make it compatible with make. It runs as a daemon process which manages a
# fcsh process.

import glob
import os
import signal
import sys
import time

# If true, supress the Recompile: and Reason: notes printed by fcsh.
# WARNING: Heuristic is weak. May suppress overzealously.
LESS_CHATTER = True

timeout = 43200   # seconds
got_sighup = False


def main():

   global got_sighup
   
   # Cleanup command
   if (sys.argv[1] == 'killall'):
      for fn in glob.glob('FW.pid.*'):
         pid = pid_from_file(fn)
         print '*** killing process %d' % (pid)
         os.kill(pid, signal.SIGTERM)
      sys.exit(0)

   # Main logic
   target = sys.argv[-1]
   pidfile = 'FW.pid.%s' % (target)
   donefile = 'FW.done.%s' % (target)
   if (os.access(pidfile, os.F_OK)):
      print '*** fcsh-wrap process exists, hupping it'
      pid = pid_from_file(pidfile)
      os.kill(pid, signal.SIGHUP)
      while (not os.access(donefile, os.F_OK)):
         time.sleep(0.2)
      os.unlink(donefile)
   else:
      print '*** starting fcsh child'
      (fcsh_in, fcsh_out) = os.popen2('fcsh', 1)
      dump(fcsh_out)
      print '*** compiling %s' % (target)
      fcsh_in.write(' '.join(['mxmlc'] + sys.argv[1:]) + '\n')
      fcsh_in.flush()
      dump(fcsh_out)
      print '*** backgrounding'
      if (os.fork() != 0):
         os._exit(0)  # parent exits
      open(pidfile, 'w').write('%d\n' % (os.getpid()))
      print '*** setting up signal handlers'
      signal.signal(signal.SIGTERM, sigterm)
      signal.signal(signal.SIGHUP, sighup)
      print '*** waiting for signals'
      while True:
         time.sleep(timeout)
         if (not got_sighup):
            # got either SIGTERM or sleep ended (we timed out); exit
            break
         print '*** recompiling %s' % (target)
         got_sighup = False
         fcsh_in.write('compile 1\n')
         fcsh_in.flush()
         dump(fcsh_out)
         open(donefile, 'w').close()
      os.unlink(pidfile)
      print '*** fcsh-wrap exiting'


def dump(fp):
   ignore_till_newline = False
   chars = list()
   while ''.join(chars) != '(fcsh) ':
      if (len(chars) == 7):
         if (LESS_CHATTER and ''.join(chars) in ('Reason:', 'Recompi')):
            ignore_till_newline = True
         c = chars.pop(0)
         if (not ignore_till_newline):
            sys.stdout.write(c)
         if (c == '\n'):
            ignore_till_newline = False
      chars.append(fp.read(1))
      assert (len(chars) <= 7)
      

def pid_from_file(filename):
   return int(open(filename).read())


def sighup(signum, frame):
   global got_sighup
   got_sighup = True

def sigterm(signum, frame):
   'Do nothing, but sleep() is ended.'
   pass


if (__name__ == '__main__'):
   main()
