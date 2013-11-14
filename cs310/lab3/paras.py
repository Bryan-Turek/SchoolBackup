import re

def paras(file):
  buff = ""
  p = re.compile('#.*');
  for line in open(file, 'r'):
    if line != "\n":
      buff += p.sub('', line)
    else:
      yield buff
      buff = ""
  yield buff

def _parser():
  n= 0
  for para in paras("310st.txt"):
    print "\n--|",n,"|----------------------"
    print para
    print "<end>"
    n += 1

_parser()
