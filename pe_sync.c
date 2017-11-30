/* Toy synchronizer: Sample template
 * Your synchronizer should implement the three functions listed below. 
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>	
#include "global.h"

extern int yylex();
extern int yyparse();

extern int enter_test(const char *op_name);
extern void pre_run(const char *op_name);
extern void after_run(const char *op_name);

//lock
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;


//define some global variables
int global_count_lex = 0;
int global_count_yacc = 0;
int numPath;
PathInfo* root;

PathNode* pre_state[100];
int restrict_path[100];




void ENTER_OPERATION(const char *op_name)
{
	pthread_mutex_lock(&m);
	
	int if_enter = enter_test(op_name); 
	while(!if_enter){
		pthread_cond_wait(&c,&m);
		if_enter = enter_test(op_name);
	}
	pre_run(op_name);
	pthread_mutex_unlock(&m);
}

void EXIT_OPERATION(const char *op_name)
{
	pthread_mutex_lock(&m);
	after_run(op_name);
	pthread_cond_broadcast(&c);
	pthread_mutex_unlock(&m);

}

void INIT_SYNCHRONIZER(const char *path_exp)
{	

	FILE* fp;
	fp = fopen("path_exp.txt","w");
	fprintf(fp,"%s", path_exp);
	fclose(fp);
	fp = fopen("path_exp.txt","r");
	extern FILE* yyin;
	yyin = fp;
	while(yylex()){
		;
	}
	numPath = global_count_lex;
	root = (PathInfo*)malloc(sizeof(PathInfo) * numPath);
	for(int i=0;i<numPath;i++){
		root[i].ophead = NULL;
	}


	fclose(fp);
	fp = fopen("path_exp.txt","r");
	yyin = fp;
	yyparse();


	fclose(fp);


	
	

  printf("Initializing Synchronizer with path_exp %s\n", path_exp);
}


