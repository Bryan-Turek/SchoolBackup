#!/usr/bin/env python
import re
import models
from copy import copy, deepcopy

class StageReader:
  def __init__(self, file):
    self.graph = self.stages(models.Graph(), file) #initialize empty graph.
    self.graph.m = self.createAdjMatrix() #create the adjacency matrix.
    self.graph.mPrime = self.createPrimeMatrix() #create transitive closure matrix.
    self.report();

  def stages(self, graph, file):
    name = ""
    p = re.compile('#.*'); #compile a patttern to look for comments.
    for line in open(file, 'r'):
      line = p.sub('', line.strip())
      nodeName = re.match(r"(?P<name>(!)?\w+(.)?$)", line)
      outLine = re.match(r"^> (?P<next>\w+(.)?) (?P<description>.*)", line)
      cacheItems = re.match(r"^\^ (?P<items>.*)", line)
      preqItems = re.match(r"^:> (?P<items>.*)", line)
      if line == "":
        continue
      if nodeName:
        name = nodeName.group("name")
        graph.node(name) #create new node.
      elif cacheItems:
        graph.node(name).cache.extend(re.split(", ", cacheItems.group("items")))
      elif preqItems:
        graph.node(name).preq.extend(re.split(", ", preqItems.group("items")))
      elif outLine:
        models.Edge(graph.node(name),graph.node(outLine.group("next")), outLine.group("description"))
      elif not outLine:
        graph.node(name).also(line) #add node description.
    return graph

  def createAdjMatrix(self):
    ln = len(self.graph.nodes)
    matrix = [[0 for col in range(ln)] for row in range(ln)] #create blank matrix
    for node in self.graph.nodes: #for each node in the graph
      for out in node.out: #for each way out in the node
        matrix[node.id][out.there.id] += 1
    return matrix

  def createPrimeMatrix(self):
    ln = len(self.graph.nodes)
    matrix = deepcopy(self.graph.m)
    for path in range(0,ln):
      for row in range(0,ln):
        for col in range(0,ln):
          matrix[row][col] = matrix[row][col] or (matrix[row][path] and matrix[path][col])
    return matrix

  def printMatrix(self, matrix):
    symbols=list("0123456789abcdefghojklmnopqrstuvwzyz=?+*-@$:;ABCDEFGHIJKLMNOPQRSTUVWYZ")
    ln = len(self.graph.nodes)
    for r in range(ln):
      print symbols[r+1],
    print "\n"
    for row in range(0,ln):
      for col in range(0,ln):
        print matrix[row][col],
      print "", symbols[row+1], self.graph.nodes[row].name,"\n"

  def report(self):
    ln = len(self.graph.nodes)
    startNodes, endNodes = [], []
    for node in self.graph.nodes:
      if re.match(r"^!\w+", node.name):
        startNodes.append(node)
      elif re.match(r"\w+(\.)$", node.name):
        endNodes.append(node)
    if len(startNodes) > 1:
      print "More than one start node!"
    if len(endNodes) > 1:
      print "More than one end node!"
    for end in endNodes:
      if end.out:
        print "End node can't have outgoing edges!"
    for row in range(0,ln):
      for col in range(0,ln):
        if self.graph.mPrime[row][col] != 0 and col == 0:
          print "Start node can't have incoming edges!"
        if self.graph.mPrime[row][col] == 0 and col > 0 and row == 0:
          print "Start node can't reach node", self.graph.nodes[col].name

def match(string, edges):
  words = [edge.there.name for edge in edges if(re.match("^"+string, edge.there.name))]
  return words, len(words)

stageFile = raw_input("Enter the stage text filename: ").strip()
reader = StageReader(stageFile)
reader.printMatrix(reader.graph.m)
reader.printMatrix(reader.graph.mPrime)

current = reader.graph.nodes[0]
cache = ""
while True:
  print cache
  print "\n"+current.description
  if len(current.out) > 0:
    for edge in current.out:
      print "(",edge.there.name,")", edge.description
    next = raw_input("\nWhat would you like to do next? > ").strip()
    matched, length = match(next, current.out)
    if length > 1 or length < 1:
      current = current
      print "\nThe name you entered matched", "none" if length < 1 else "more than one", "!"
    else:
      next = reader.graph.node(matched[0])
      try:
        cache = next.cache[current.cache.index(cache)] if cache != "" else next.cache[0]
      except:
        print "You do not have the prerequisites!"
        next = current if next.cache else next
      current = next
  else:
    print cache
    print "Congratulations, you have finished the game!"
    break
