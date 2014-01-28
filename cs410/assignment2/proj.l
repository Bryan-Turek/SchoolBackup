cap       [A-Z]
letter    [A-Za-z]
word      {letter}+
words     ({word},?\ *)*{word}*
capWord   {cap}{letter}*

d         [0-9]
num       {d}+
float     {d}+\.{d}+

year      {d}{4}
month     January|February|March|April|May|June|July|August|September|October|November|December|(Jan|Feb|Mar|Apr|Aug|Sept|Oct|Nov|Dec).
day       Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday
date      ({day},\ +)?{month}\ +{num},\ +{year}

death     ((died|passed\ +away)\ .*)
birth     ((born|Born)\ .*)
age       ,\ +{num}

name      John\ R.\ Cox|Iva\ Catherine\ \(Borror\)\ Porter|Carol\ Sue\ Reed\ Cox|Eston\ Theodore\ \"Buck\"\ Kimble\ Jr\.|Junior\ William\ Cox|Ronald\ Edward\ Mauzy|Joseph\ K\.\ Oates|Mrs\.\ Vera\ M\.\ Cox|Richard\ Ervin\ Borror|Ervin\ Rexrode|Mrs\.\ Myrtle\ Anice\ Propst\ Rexrode|Jonathan\ Keith\ Hiser|GEORGE\ F.\ CUNNINGHAM
parents   son\ of\ (.*){name}and\ +{name}|daughter\ of\ (.*){name}and\ +{name}

daughter   daughter|Daughter
son       son|Son

place     "Brushy\ Run"|"LAHMANSVILLE"|"Cumberland"|"Wellsburg"|"Weirton"|"Murraysville"|"Kearneysville"|"Petersburg"|"Winchester"|"Manassas"|"Washington"|"West\ Jefferson"|"Oakland"|"Brownsville"|"Harman"|Brushy\ Run\ Sunday
county "Hancock"|"Franklin"|"Pendleton"|"Allegany"
state "W. VA."|"Md."|"WV"|"PA"|"Va."|"Ohio"|"TX"
dod "5 January 1928"|"Friday, Dec. 4, 1998"|"Friday, August 1, 2008"|"Friday, May 11"|"26 February 1897"|"Aug. 25"|"July 9"|"May  2"|"died May 25"|"Dec. 26, 2004"|"Sunday, Oct. 21, 2001"|"Dec. 10"|"March 20, 1903"|"Feb. 21, 1926"|"Aug. 14"|"Thursday, May 20, 2004"|"Saturday, September 2, 1911"
news "Grant\ County\ Press"|"Cumberland\ Times-News"|"Chambers\ Funeral\ Home"|"Pendleton\ Times"|"Elkins\ Intermountain"|"The\ Evening\ Post\ Newspaper"

%s VALUE

%{

#include <stdio.h>
#include <string.h>

typedef struct {
  char name[100], dod[100], place[100], county[100], state[100], born[2048], death[2048], ref[100], sex[100], call[100];
} Person;

void initPerson(Person *person);

Person person;

%}

%%

<INITIAL>. {
    initPerson(&person);
    BEGIN(VALUE);
}

<VALUE>{news} {
    if(strcmp(person.ref, "") == 0)
        strcpy(person.ref, yytext);
}
<VALUE>{place} {
    if(strcmp(person.place, "") == 0)
        strcpy(person.place, yytext);
}
<VALUE>{county} {
    if(strcmp(person.county, "") == 0)
        strcpy(person.county, yytext);
}
<VALUE>{state} {
    if(strcmp(person.state, "") == 0)
        strcpy(person.state, yytext);
}
<VALUE>{birth} {
    if(strcmp(person.born, "") == 0)
        strcpy(person.born, yytext);
}
<VALUE>{death} {
    if(strcmp(person.death, "") == 0)
        strcpy(person.death, yytext);
}
<VALUE>{name} {
    if(strcmp(person.name, "") == 0) {
        strcpy(person.name, yytext);
    }
}
<VALUE>{son} {
    if(strcmp(person.sex, "") == 0) {
        strcpy(person.sex, yytext);
        strcpy(person.call, "he");
    }
}
<VALUE>{daughter} {
    if(strcmp(person.sex, "") == 0) {
        strcpy(person.sex, yytext);
        strcpy(person.call, "she");
    }
}
<VALUE>{dod} {
    if(strcmp(person.dod, "") == 0)
        strcpy(person.dod, yytext);
}
<VALUE>\n   break;
<VALUE>--- {
    if(strcmp(person.name, "") != 0)
        printf("%s, %s %s %s\nReference: %s\n\n", person.name,person.born,person.call,person.death,person.ref);
    BEGIN(0);
}
<VALUE>.   ;

%%

int main()
{

	yyin = fopen("obituaries.txt","r");
	yylex();

	return 0;
}

void initPerson(Person *person) {
    person->name[0] = '\0';
    person->dod[0] = '\0';
    person->place[0] = '\0';
    person->county[0] = '\0';
    person->state[0] = '\0';
    person->born[0] = '\0';
    person->death[0] = '\0';
    person->ref[0] = '\0';
    person->sex[0] = '\0';
    person->call[0] = '\0';
}