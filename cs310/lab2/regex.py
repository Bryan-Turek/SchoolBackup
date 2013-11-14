#!/usr/bin/python

import re

def match(string, words):
  words = [word for word in words if(re.match("^"+string, word))]
  return len(words), words

words = ["hoho", "home", "hat", "hairy","homosapien"]
print match("ho", words)