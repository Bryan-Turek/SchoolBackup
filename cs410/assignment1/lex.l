letter   [A-Za-z]
word     {letter}+
words    ({word}*\ *)*{word}+
comma    [,]
d        [0-9]
number   {d}+
float    {d}+\.{d}+
year     {d}{4}

%s HOUSENUM DNUMBER FNUMBER LNAME FNAME RELATE OWN FORR SEX RACE AGE UNDER6 MARITAL IMMYEAR NAT NATYEAR ATTSCH READ WRITE BPLACE LANG FPLACE FLANG MPLACE MLANG ENG PROF IND EMP FSCHED

%{
#include <stdio.h>
#include <string.h>

typedef struct {
  int line;
  float hnumber;
  int dnumber, fnumber;
  char lname[50], fname[50], relate[50];
  int own, forr; //boolean own and 1 for rent, 0 for free
  char sex, race;
  int age, month;
  char marital;
  int immYear, nat;
  int natYear, attSch, read, write;
  char bPlace[30], lang[30], fPlace[30], fLang[30], mPlace[30], mLang[30];
  int eng;
  char prof[50], ind[50], emp[50];
} person;

typedef struct {
  char places[100][100];
  int freq[100];
  int count;
} hMapBP;

typedef struct {
  int year[100];
  int month[100];
  int freq[100];
  int count;
} hMapAges;

int isRailRoader(char *);
void collectAges(int, int, hMapAges *);
void putInBucket(char[], hMapBP *);
void initPerson(person *);

person p;
person people[100];
int pc = 0;

%}

%%
<INITIAL>{number}    {initPerson(&p); p.line = atoi(yytext);}
<INITIAL>,           BEGIN(HOUSENUM);
<HOUSENUM>{float}     p.hnumber = atof(yytext);
<HOUSENUM>,           BEGIN(DNUMBER);
<DNUMBER>{number}    p.dnumber = atoi(yytext);
<DNUMBER>,           BEGIN(FNUMBER);
<FNUMBER>{number}    p.fnumber = atoi(yytext);
<FNUMBER>,           BEGIN(LNAME);
<LNAME>{word}        strcpy(p.lname, yytext);
<LNAME>,             BEGIN(FNAME);
<FNAME>{words}       strcpy(p.fname, yytext);
<FNAME>,             BEGIN(RELATE);
<RELATE>{word}       strcpy(p.relate, yytext);
<RELATE>,            BEGIN(OWN);
<OWN>{letter}        p.own = strcmp(yytext, "O");
<OWN>,               BEGIN(FORR);
<FORR>{letter}       p.forr = strcmp(yytext, "M");
<FORR>,              BEGIN(SEX);
<SEX>{letter}        p.sex = yytext[0];
<SEX>,               BEGIN(RACE);
<RACE>{letter}       p.race = yytext[0];
<RACE>,              BEGIN(AGE);
<AGE>\"\"            BEGIN(UNDER6);
<AGE>{d}+            p.age = atoi(yytext);
<UNDER6>"/12"        ;
<UNDER6>{d}/"-"      p.age = atoi(yytext);
<UNDER6>{d}+/"/12"   p.month = atoi(yytext);
<AGE,UNDER6>,        BEGIN(MARITAL);
<MARITAL>{letter}    p.marital = yytext[0];
<MARITAL>,           BEGIN(IMMYEAR);
<IMMYEAR>{year}      p.immYear = atoi(yytext);
<IMMYEAR>,           BEGIN(NAT);
<NAT>Na              p.nat = 1;
<NAT>,               BEGIN(NATYEAR);
<NATYEAR>{year}      p.natYear = atoi(yytext);
<NATYEAR>,           BEGIN(ATTSCH);
<ATTSCH>yes          p.attSch = 1;
<ATTSCH>,            BEGIN(READ);
<READ>yes            p.read = 1;
<READ>,              BEGIN(WRITE);
<WRITE>yes           p.write = 1;
<WRITE>,             BEGIN(BPLACE);
<BPLACE>{words}      strcpy(p.bPlace, yytext);
<BPLACE>,            BEGIN(LANG);
<LANG>{word}         strcpy(p.lang, yytext);
<LANG>,              BEGIN(FPLACE);
<FPLACE>{words}      strcpy(p.fPlace, yytext);
<FPLACE>,            BEGIN(FLANG);
<FLANG>{word}        strcpy(p.fLang, yytext);
<FLANG>,             BEGIN(MPLACE);
<MPLACE>{words}      strcpy(p.mPlace, yytext);
<MPLACE>,            BEGIN(MLANG);
<MLANG>{word}        strcpy(p.mLang, yytext);
<MLANG>,             BEGIN(ENG);
<ENG>yes             p.eng = 1;
<ENG>,               BEGIN(PROF);
<PROF>{words}        strcpy(p.prof, yytext);
<PROF>,              BEGIN(IND);
<IND>{words}         strcpy(p.ind, yytext);
<IND>,               BEGIN(EMP);
<EMP>{word}          strcpy(p.emp, yytext);
<EMP>,               BEGIN(FSCHED);
<FSCHED>\n           {people[pc++] = p; BEGIN(0);}
.                    ;

%%
main() {
  yylex();
  hMapBP birthPlaces;
  birthPlaces.count = 0;
  hMapAges ages;
  ages.count = 0;
  int i;
  for(i=0; i<pc; i++) {
    putInBucket(people[i].bPlace, &birthPlaces);
    if(people[i].age <= 5) {
      collectAges(people[i].age, people[i].month, &ages);
    }
  }
  printf("Birth Places:\n");
  for(i=0; i<birthPlaces.count; i++) {
    printf("%s: %i\n", birthPlaces.places[i], birthPlaces.freq[i]);
  }
  printf("\nNumber of kids 5 or under:\n");
  for(i=0; i<ages.count; i++) {
    printf("%i years %i months: %i\n", ages.year[i], ages.month[i], ages.freq[i]);
  }
  int wivesEmployed=0, headsRR=0, notAllRRs=0, j, headCount=0, neighRRCount, neighCount;
  person *head, *neighbor, wife;
  for(i=0; i<pc; i++) {
    head = &people[i];
    if(strcmp(head->relate, "head") == 0 && isRailRoader(head->ind)) {
      neighCount=0, neighRRCount=0;
      for(j=0; j<pc; j++) {
        neighbor = &people[j];
        if(neighbor->hnumber < head->hnumber+4 && neighbor->hnumber > head->hnumber-4) {
          if(strcmp(neighbor->relate, "head") == 0) {
            if(isRailRoader(neighbor->ind)) {
              neighRRCount++;
              }
            neighCount++;
          }
        }
      }

      if(neighCount == neighRRCount) {
        headsRR++;
      } else {
        notAllRRs++;
      }
      headCount++;
    }
  }
  printf("\nThere are %i households with the head of households being a railroader and all neighbor heads of households also being railroaders.\n", headsRR);
  printf("\nThere are %i households with the head of households being a railroader and at least one, but not all, neighbor head of household not a railroader.\n", notAllRRs);
  printf("\nThere are %i households with the head of household being a railroader and no neighbor head of household a railroader.\n", headCount-headsRR-notAllRRs);
  for(i=0; i<pc; i++) {
    wife = people[i];
    if(strcmp(wife.relate, "wife") == 0) {
      if(strlen(wife.emp) != 0) {
        wivesEmployed++;
      }
    }
  }
  printf("\nThere are %i wives employed.\n", wivesEmployed);
}

int isRailRoader(char *emp) {
  if(strcmp(emp, "Steam Rairoad") && strcmp(emp, "Railroad shop") && strcmp(emp, "Railroad yard")) {
    return 0;
  } else return 1;
}

void collectAges(int year, int month, hMapAges *ages) {
  int i;
  if(year == 0 && month == -1)
    return;
  for(i=0; i<ages->count; i++) {
    if(year == ages->year[i] && month == ages->month[i]) {
      ages->freq[i]++;
      break;
    }
  }
  if(i == ages->count) {
    ages->year[i] = year;
    ages->month[i] = (month>=0)?month:0;
    ages->freq[i] = 1;
    ages->count++;
  }
}

void putInBucket(char place[], hMapBP *bp) {
  int i;
  for(i=0; i<bp->count; i++) {
    if(strcmp(place, bp->places[i]) == 0) {
      bp->freq[i]++;
      break;
    }
  }
  if(i==bp->count) {
    strcpy(bp->places[i], place);
    bp->freq[i] = 1;
    bp->count++;
  }
}

void initPerson(person *per) {
  per->line = 0;
  per->fname[0] = '\0';
  per->relate[0] = '\0';
  per->own = 0;
  per->forr = 0;
  per->sex = '\0';
  per->race = '\0';
  per->age = 0;
  per->month = -1;
  per->marital = '\0';
  per->immYear = 0;
  per->nat = 0;
  per->natYear = 0;
  per->attSch = 0;
  per->read = 0;
  per->write = 0;
  per->bPlace[0] = '\0';
  per->lang[0] = '\0';
  per->fPlace[0] = '\0';
  per->fLang[0] = '\0';
  per->mPlace[0] = '\0';
  per->mLang[0] = '\0';
  per->eng = 0;
  per->prof[0] = '\0';
  per->ind[0] = '\0';
  per->emp[0] = '\0';
}
