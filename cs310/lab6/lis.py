#!/usr/bin/python

################ Lispy: Scheme Interpreter in Python

## (c) Peter Norvig, 2010; See http://norvig.com/lispy.html

################ Symbol, Env classes

from __future__ import division

Symbol = str

class Env(dict):
    "An environment: a dict of {'var':val} pairs, with an outer Env."
    def __init__(self, parms=(), args=(), outer=None):
        self.update(zip(parms,args))
        self.outer = outer
    def find(self, var):
        "Find the innermost Env where var appears."
        return self if var in self else self.outer.find(var)
    def depth(self):
        n = 0
        x = self.outer
        while x:
            n += 1
            x = x.outer
        return n

def add_globals(env):
    "Add some Scheme standard procedures to an environment."
    import math, operator as op
    env.update(vars(math)) # sin, sqrt, ...
    env.update(
     {'say': lambda x: say(x), 'quit' : goodbye,
      '+':op.add, '-':op.sub, '*':op.mul, '/':op.div, 'not':op.not_,
      '>':op.gt, '<':op.lt, '>=':op.ge, '<=':op.le, '=':op.eq,
      'equal?':op.eq, 'eq?':op.is_, 'length':len, 'cons':lambda x,y:[x]+y,
      'car':lambda x:x[0],'cdr':lambda x:x[1:], 'append':op.add,
      'list':lambda *x:list(x), 'list?': lambda x:isa(x,list),
      'null?':lambda x:x==[], 'symbol?':lambda x: isa(x, Symbol)})
    return env

def say(x): print x
def goodbye(): print ";; Bye."; quit()

global_env = add_globals(Env())

isa = isinstance

################ eval

def eval(x, env=global_env,lvl=0):
    "Evaluate an expression in an environment."
    this = x[0] if isa(x,list) else x
    print "|.. " * lvl + str(this)
    if isa(x, Symbol):             # variable reference
        return env.find(x)[x]
    elif not isa(x, list):         # constant literal
        return x
    elif x[0] == 'load':
      tmp=eval(x[1],env,lvl+1)
      return eload(tmp)
    elif  x[0] == 'quote' or  x[0] == "'":
        (_, exp) = x
        return exp
    elif x[0] == 'if':             # (if test conseq alt)
        (_, test, conseq, alt) = x
        return eval((conseq if eval(test, env) else alt), env,lvl+1)
    elif x[0] == 'set!':           # (set! var exp)
        (_, var, exp) = x
        env.find(var)[var] = eval(exp, env,lvl+1)
    elif x[0] == 'define':         # (define var exp)
        (_, var, exp) = x
        env[var] = eval(exp, env,lvl+1)
    elif x[0] == 'lambda':         # (lambda (var*) exp)
        (_, vars, exp) = x
        return lambda *args: eval(exp, Env(vars, args, env),lvl+1)
    elif x[0] == 'begin':          # (begin exp*)
        for exp in x[1:]:
            val = eval(exp, env,lvl+1)
        return val
    else:                          # (proc exp*)
        exps = [eval(exp, env,lvl+1) for exp in x]
        proc = exps.pop(0)
        #print ">calling", proc
        return proc(*exps)

################ parse, read, and user interaction

def read(s):
    "Read a Scheme expression from a string."
    return read_from(tokenize(s))

parse = read

def tokenize(s):
    "Convert a string into a list of tokens."
    return s.replace('(',' ( ').replace(')',' ) ').split()

def read_from(tokens):
    "Read an expression from a sequence of tokens."
    if len(tokens) == 0:
        raise SyntaxError('unexpected EOF while reading')
    token = tokens.pop(0)
    if '(' == token:
        L = []
        while tokens[0] != ')':
            L.append(read_from(tokens))
        tokens.pop(0) # pop off ')'
        return L
    elif ')' == token:
        raise SyntaxError('unexpected )')
    else:
        return atom(token)

def atom(token):
    "Numbers become numbers; every other token is a symbol."
    try: return int(token)
    except ValueError:
        try: return float(token)
        except ValueError:
            return Symbol(token)

def to_string(exp):
    "Convert a Python object back into a Lisp-readable string."
    return '('+' '.join(map(to_string, exp))+')' if isa(exp, list) else str(exp)

def repl(prompt='lis.py> '):
    "A prompt-read-eval-print loop."
    print ";; LITHP ITH LITHTENING ...(v0.1)"
    while True:
        val = eval(parse(raw_input(prompt)))
        if val is not None: print to_string(val)

import string
def sexp(s) :
  level,keep = 0,""
  while s:
    if s[0] == ";":
      while s and s[0] != "\n": s=s[1:]
      if not s: break
    if s[0] == "(": level += 1
    if level > 0  : keep += s[0]
    if s[0] == ")":
      level -= 1
      if level==0:
        yield keep
        keep=""
    s = s[1:]
  if keep:
    yield keep


def eload(f) :
  with open(f) as contents:
    code = contents.read()
  for part in  sexp(code):
    eval(parse(part))

import sys
if len(sys.argv) > 1:
  eload(sys.argv[1])
else:
  repl()
  quit()
