#!/usr/bin/python

def ihaveSomeerrors(lst):
#run down the list, adding the first, third, firth etc items to output
  out = [] #created output list
  for x in range(0,len(lst)): #proper indentation and for loop
    odd = (x+1) % 2 #calculate if it's odd
    if odd:
      out.append(lst[x]) #add odd string index to output
  return out #return out, not odd.

print ihaveSomeerrors(["one", "two", "three", "four", "five"])