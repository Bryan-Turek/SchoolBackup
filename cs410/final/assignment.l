letter   [A-Za-z]
word     {letter}+
words    ({word}*\ *)*{word}+
comma    [,]    
d        [0-9]
number   {d}+
float    {d}+\.{d}+
year     {d}{4}

%s NODE

%{

#include <stdio.h>
#include <string.h>

typedef struct {
    char name[50], desc[1000];
} Node;

typedef struct {
    Node* nodes;
    int size;
} Graph;

Node* getNode(Graph* graph, char* name);
void initGraph(Graph* graph);

Node* node;

int initialized = 0;
Graph graph;

%}

%%
<INITIAL>.  {
    if(!initialized) {
        initGraph(&graph);
        initialized = 1;
    }
}
!{word}\n|\:{word}\n {
    printf("%s", yytext);
    graph.size++;
    node = getNode(&graph, yytext);
}
{words}\n   {
}
[:blank:] {
    BEGIN(0);
}
.   ;

%%

Node* getNode(Graph* graph, char* name) {
    int i = 0;
    Node* newNode;
    printf("%d\n", graph->size);
    for(i=0; i<graph->size; i++) {
        if(i == graph->size - 1) {
            strcpy(newNode->name, name);
            return newNode;
        }
    }
}

void initGraph(Graph* graph) {
    graph->nodes = (Node*)malloc(sizeof(Node));
    graph->size = 0;
}

main() {

    yylex();
    
    //printf("%d\n", graph.size);
    
}