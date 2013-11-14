#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void quit(char *s);
char * input(char *s);
char ** fill(int *maxR, int *maxC);
void printPuzzle(char **p, int maxR, int maxC);
void solvePuzzle(char **p, int maxR, int maxC);
void play(char *word, char **puzzle, int maxR, int maxC);
void foundWord(char *f, char *word, int row, int col);
void releasePuzzle(char **puzzle, int maxC);
void check(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkBounds(int row, int col, int maxRow, int maxCol);
int checkUp(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkDown(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkUpLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkUpRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkDownLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);
int checkDownRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol);

void quit(char *s) {// write error message and quit
  fprintf(stderr, "%s\n", s);
  exit(1);
}

char * input(char *s) {
  int max = 20;
  char* name = malloc(max); // allocate buffer
  if (name == 0) quit("Can't allocate memory!");
  printf("%s", s);
  while (1) { // skip leading whitespace
    int c = getchar();
    if (c == EOF) break; // end of file
    if (!isspace(c)) {
      ungetc(c, stdin);
      break;
    }
  }
  int i = 0;
  while (1) {
    int c = getchar();
    if (isspace(c) || c == EOF) {// at end, add terminating zero
      name[i] = 0;
      break;
    }
    name[i] = c;
    if (i==max-1) { // buffer full
      max = max+max;
      name = realloc(name,max); // get a new and larger buffer
      if (name == 0) quit("Memory exhausted!");
    }
    i++;
  }
  return name;
}

char ** fill(int *maxRows, int *maxCols) {
  char *filename = input("Enter puzzle filename: "); // read input from user
  int r,c;
  FILE *fp;
  fp = fopen(filename, "rt");
  free(filename); // free memory space for filename
  if (fp == NULL) quit("Can't open file!");
  fscanf(fp, "%d %d \n", maxRows, maxCols); // read first line of file for maxRows and maxCols
  char **p, lt;
  p = malloc(*maxRows * sizeof(char*)); // allocate size of rows
  for(r=0; r<*maxCols; r++) p[r] = malloc(*maxCols); // allocate size of columns
  for(r=0; r<*maxCols; r++){
    for(c=0; c<*maxRows; c++) {
      if ( (fscanf(fp, "%c ", &lt) != EOF) ) p[r][c] = lt;
    }
  }
  fclose(fp); // finally close file
  return p;
}

void printPuzzle(char **puzzle, int maxRows, int maxCols) {
  int i,j;
  for(i=0; i<maxRows; i++) {
    for(j=0; j<maxCols; j++) {
      printf("%c ",puzzle[i][j]);
    }
    printf("\n");
  }
}

int main() {
  int maxRows, maxCols;
  char **puzzle = fill(&maxRows, &maxCols); // fill puzzle
  printPuzzle(puzzle, maxRows, maxCols); // display puzzle to user
  solvePuzzle(puzzle, maxRows, maxCols); // start solving puzzle
  releasePuzzle(puzzle, maxCols); // release puzzle memory
}

void check(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int count, wl = strlen(word);
  if((count = checkUp(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkUp", word, row, col);
  if((count = checkDown(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkDown", word, row, col);
  if((count = checkLeft(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkLeft", word, row, col);
  if((count = checkRight(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkRight", word, row, col);
  if((count = checkUpLeft(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkUpLeft", word, row, col);
  if((count = checkUpRight(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkUpRight", word, row, col);
  if((count = checkDownLeft(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkDownLeft", word, row, col);
  if((count = checkDownRight(puzzle, word, row, col, maxRow, maxCol)) == wl-1) foundWord("checkDownRight", word, row, col);
}

int checkBounds(int row, int col, int maxRow, int maxCol) {
  if(row<0 || row>=maxRow) return 0;
  if(col<0 || col>=maxCol) return 0;
  return 1;
}

int checkUp(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row-i, col, maxRow, maxCol) && (puzzle[row-i][col] == word[i])) found++;
  }
  return found;
}

int checkDown(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row+i, col, maxRow, maxCol) && (puzzle[row+i][col] == word[i])) found++;
  }
  return found;
}

int checkLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row, col-i, maxRow, maxCol) && (puzzle[row][col-i] == word[i])) found++;
  }
  return found;
}

int checkRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row, col+i, maxRow, maxCol) && (puzzle[row][col+i] == word[i])) found++;
  }
  return found;
}

int checkUpLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row-i, col-i, maxRow, maxCol) && (puzzle[row-i][col-i] == word[i])) found++;
  }
  return found;
}

int checkUpRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row-i, col+i, maxRow, maxCol) && (puzzle[row-i][col+i] == word[i])) found++;
  }
  return found;
}

int checkDownLeft(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row+i, col-i, maxRow, maxCol) && (puzzle[row+i][col-i] == word[i])) found++;
  }
  return found;
}

int checkDownRight(char **puzzle, char *word, int row, int col, int maxRow, int maxCol) {
  int i, found = 0;
  for(i=1; i<strlen(word); i++) {
    if(checkBounds(row+i, col+i, maxRow, maxCol) && (puzzle[row+i][col+i] == word[i])) found++;
  }
  return found;
}

void solvePuzzle(char **puzzle, int maxRows, int maxCols) {
  char *wordFile = input("Enter words filename: "); // grab filename for words from user
  char *word = malloc(maxRows);
  FILE *fp;
  fp = fopen(wordFile, "rt");
  free(wordFile); // free wordFile memory
  if (fp == NULL) quit("Can't open file!"); // end can't open file.
  while(fscanf(fp, "%s", word) != EOF) {
    play(word, puzzle, maxRows, maxCols); // play puzzle
  }
  fclose(fp); // close file.
  free(word); // finally free word memory
}

void play(char *word, char **puzzle, int maxR, int maxC) {
  int i, j;
  for(i=0; i<maxR; i++) {
    for(j=0; j<maxC; j++) {
      if(puzzle[i][j] == word[0])
        check(puzzle, word, i, j, maxR, maxC);
    }
  }
}

void foundWord(char *f, char *word, int row, int col) {
  printf("The word '%s' was found by function %s beginning at [%d][%d]. \n", word, f, col+1, row+1);
}

void releasePuzzle(char **p, int maxC) {
  int r;
  for(r=0; r<maxC; r++) free(p[r]);
  free(p);
}