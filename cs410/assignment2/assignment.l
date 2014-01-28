LINE \n
DIGIT [0-9]
NAME [a-zA-Z].?*
GENDER "his"|"she"|"him"|"hers"
FULLNAME {NAME}",  "{DIGIT}{DIGIT}","|{NAME}", "{DIGIT}{DIGIT}","|{NAME}", "{DIGIT}{DIGIT}" years old,"|"Mrs. "{NAME}", "{DIGIT}{DIGIT}","
MRNAME "Mr. "{NAME}" who died"
WELLKNOWN {NAME}", a well known"
MRSDIED "Mrs. "{NAME}" died"
TOWNS "Brushy Run"|"LAHMANSVILLE"|"Cumberland"|"Wellsburg"|"Weirton"|"Murraysville"|"Kearneysville"|"Petersburg"|"Winchester"|"Manassas"|"Washington"|"West Jefferson"|"Oakland"|"Brownsville"|"Harman"
COUNTY "Hancock"|"Franklin"|"Pendleton"|"Allegany"
STATE "W. VA."|"Md."|"WV"|"PA"|"Va."|"Ohio"|"TX"
DOD "5 January 1928"|"Friday, Dec. 4, 1998"|"Friday, August 1, 2008"|"Friday, May 11"|"26 February 1897"|"Aug. 25"|"July 9"|"May  2"|"died May 25"|"Dec. 26, 2004"|"Sunday, Oct. 21, 2001"|"Dec. 10"|"March 20, 1903"|"Feb. 21, 1926"|"Aug. 14"|"Thursday, May 20, 2004"|"Saturday, September 2, 1911"
REFERENCE "Grant\ County\ Press"|"Cumberland\ Times-News"|"Chambers\ Funeral\ Home"|"Pendleton\ Times"|"Elkins\ Intermountain"|"The\ Evening\ Post\ Newspaper"

%array
	int fullNameCount = 0,
	mrNameCount = 0,
	wellNameCount = 0,
	diedNameCount = 0,
	randomCount = 0;
	char *deathName= NULL;
  	char *father = "father";
	char *gender = "son";
	char *mother = "mother";
	char *DOB = "2/27/1992";
	char *town = "reading";
	char *county = "exeter";
	char *state = "pa";
	char *DOD = "12/12/2012";
	char *reference = "Newspaper";
	char *gender2 = NULL;

%%
	deathName = (char *) malloc(sizeof(char) * 1024);
	father = (char *) malloc(sizeof(char) * 1024);
	gender = (char *) malloc(sizeof(char) * 1024);
	mother = (char *) malloc(sizeof(char) * 1024);
	DOB = (char *) malloc(sizeof(char) * 1024);
	town = (char *) malloc(sizeof(char) * 1024);
	county = (char *) malloc(sizeof(char) * 1024);
	state = (char *) malloc(sizeof(char) * 1024);
	DOD = (char *) malloc(sizeof(char) * 1024);
	reference = (char *) malloc(sizeof(char) * 1024);
	
{LINE} break;
{DOD} {strcpy(DOD, yytext);}
{REFERENCE} {strcpy(reference, yytext);}
{TOWNS} {strcpy(town, yytext);}
{COUNTY} {strcpy(county, yytext);}
{STATE} {strcpy(state, yytext);}
{FULLNAME} {fullNameCount++; tokenizeFULL();}
{MRNAME} {mrNameCount++; tokenizeMR();}
{WELLKNOWN} {wellNameCount++;	if (strstr(yytext, "R. Cox") != NULL) {
		strcpy(DOB, "about 1850");
		strcpy(town, "Brushy Run");
		strcpy(county, "Pendleton County");
		strcpy(state, "WV");
		strcpy(reference, "Grant County Press");
	} tokenizeWELL();}
{MRSDIED} {diedNameCount++; tokenizeDIED();}
.
%%


void biography(char* deathName, char* gender, char* father, char* mother, char* DOB, char* town, char* county, char* state, char* DOD, char* reference) {
	gender2 = (char *) malloc(sizeof(char) * 1024);
	if (strstr(gender, "son") != NULL) strcpy(gender2, "He");
	else strcpy(gender2, "She");
	printf("\n%s, %s of %s and %s, was born %s at %s, %s, %s. %s married at %s, %s.  %s died %s in %s. Reference: %s.\n\n",deathName,gender,father,mother,DOB,town,county,state,gender2,town,state,gender2,DOD,state,reference);

}

int tokenizeFULL()
{

	if (strstr(yytext, "Mrs") != NULL) strcpy(gender, "daughter");
	else strcpy(gender, "son");
	if (strstr(yytext, "Text:") != NULL) {
		strcpy(deathName, "Iva Catherine (Borror) Porter");
		strcpy(gender, "daughter");
	}
	else deathName = strtok(yytext, ",");

	biography(deathName, gender, father, mother, DOB, town, county, state, DOD, reference);
	return 0;
}

int  tokenizeMR()
{
	if (strstr(yytext, "Mrs") != NULL) strcpy(gender, "daughter");
	else strcpy(gender, "son");
	
	deathName=strtok(yytext, "who");
	strcat(deathName, "okum");
	biography(deathName, gender, father, mother, DOB, town, county, state, DOD, reference);
	
	return 0;
}

int  tokenizeWELL()
{
	if (strstr(yytext, "Mrs") != NULL) strcpy(gender, "daughter");
	else strcpy(gender, "son");
	deathName=strtok(yytext, ",");

	biography(deathName, gender, father, mother, DOB, town, county, state, DOD, reference);
	return 0;
}

int  tokenizeDIED()
{
	if (strstr(yytext, "Mrs") != NULL) strcpy(gender, "daughter");
	else strcpy(gender, "son");
	
	deathName=strtok(yytext, "died");
	biography(deathName, gender, father, mother, DOB, town, county, state, DOD, reference);

	return 0;
}



int main()
{

	yyin = fopen("obituaries.txt","r");
	yylex();

	return 0;
}
