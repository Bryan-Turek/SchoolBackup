letter   [A-Za-z]
word     {letter}+
words    ({word}*\ *)*{word}+
comma    [,]
d        [0-9]
number   {d}+
float    {d}+\.{d}+
year     {d}{4}

%s VALUE

%{

#include <stdio.h>
#include <string.h>

typedef struct {
  int id, hn, age, month, someNeighbors, noNeighbors;
  char pbp[50], prof[50], rel[50];
} Person;

typedef struct {
  char places[100][100];
  int count[100];
} Places;

void initPerson(Person *person);
void recordPlace(char *place, Places *places);
int isRailRoadWorker(Person *person);

Person person;
Places places;
Person people[100];
int count = 0, placeCount = 0;
int value = 0;

int months[59] = {0};

%}

%%

<INITIAL>{number}  {
                      initPerson(&person);
                      person.id = atoi(yytext);
                   }
<INITIAL>{comma}   BEGIN(VALUE);
<VALUE>{words}     {
                      switch(value) {
                        case 18:
                          strcpy(person.pbp, yytext);
                          recordPlace(yytext, &places);
                        case 5:
                          strcpy(person.rel, yytext);
                      }
                   }
<VALUE>{number}    {
                      switch(value) {
                        case 0:   person.hn = atoi(yytext);
                        case 10:  person.age = atoi(yytext);
                      }
                   }
<VALUE>"/12"       ;
<VALUE>{d}/"-"     person.age = atoi(yytext);
<VALUE>{d}+/"/12"  person.month = atoi(yytext);
<VALUE>{comma}     {value++;}
<VALUE>\n          {
                      value = 0;
                      people[count] = person;
                      count++;
                      BEGIN(0);
                   }
.                  ;

%%

main() {
  yylex();

  //Main loop to grap data
  int i,j, empWives = 0, nIsRRW = 0, nHNRRW = 0, noNRRW = 0;
  for(i=2; i<=count; i++) {
    Person current = people[i];
    if(current.age < 5) months[(current.age*12)+(current.month)]++;
    if(strcmp(current.rel, "wife") == 0) empWives++;
    printf("%s\n", current.rel);
    if(isRailRoadWorker(&current) && (strcmp(current.rel, "head") == 0)) {
      printf("hit");
      for(j=2; j<=count; j++) {
        if(isRailRoadWorker(&people[j]) && current.hn > 0 && (current.hn-4 <= people[j].hn <= current.hn+4) && strcmp(people[j].rel, "head") == 0) current.someNeighbors++;
        if(!isRailRoadWorker(&people[j]) && current.hn > 0 && (current.hn-4 <= people[j].hn <= current.hn+4) && strcmp(people[j].rel, "head") == 0) current.noNeighbors++;
      }
      printf("%d %d \n", current.someNeighbors, current.noNeighbors);
    }
  }

  //Number of people born in each state or country other than USA
  printf("\n");
  for(i=1; i<placeCount; i++) {
    printf("There are %d people born from %s.\n", places.count[i], places.places[i]);
  }
  printf("\n");

  //List number of children of each monthly age.
  for(i=1; i<=59; i++) {
    if(months[i] != 0) printf("There are %d children of %d months old.\n", months[i], i);
  }

  //Number of heads of households based on certain criteria.
  for(i=2; i<count; i++) {
    Person current = people[i];
    if(current.someNeighbors > 0 && current.noNeighbors == 0) nIsRRW++;
    if(current.someNeighbors > 0 && current.noNeighbors > 0) nHNRRW++;
    if(current.someNeighbors == 0 && current.noNeighbors > 0) noNRRW++;
  }
  printf("\nThere are %d heads of households who work for the railroad and all neighbors work for the railroad.\n", nIsRRW);
  printf("There are %d heads of households who work for the railroad and some neighbors work for the railroad.\n", nHNRRW);
  printf("There are %d heads of households who work for the railroad and no neighbors work for the railroad.\n", noNRRW);

  //Number of wives that are employed.
  printf("\nThere are %d wives that are employed.\n", empWives);
}

void recordPlace(char *place, Places *places) {
  int i;
  for(i=0; i<=placeCount; i++) {
    if(strcmp(places->places[i], place) == 0)  {
      places->count[i]++;
      break;
    } else if(i == placeCount) {
      strcpy(places->places[i], place);
      places->count[i]++;
      placeCount++;
      break;
    }
  }
}

int isRailRoadWorker(Person *person) {
  if((strcmp(person->prof, "Steam Rairoad") == 0) || (strcmp(person->prof, "Railroad shop") == 0) || (strcmp(person->prof, "Railroad yard") == 0)) return 1;
  else return 0;
}

void initPerson(Person *person) {
  person->id = 0;
  person->age = 0;
  person->month = 0;
  person->hn = 0;
  person->pbp[0] = '\0';
  person->prof[0] = '\0';
  person->rel[0] = '\0';
  person->someNeighbors = 0;
  person->noNeighbors = 0;
}