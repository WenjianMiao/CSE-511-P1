%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "global.h"
#include "path.yacc.h"


extern int yylex();
%}

%union {
	char name[20];
	int  ival;
	PathLocation pathloc;
	
}

%token PATH END 
%token OP
%token LBRACE RBRACE LPAREN RPAREN PLUS SEMICOLON


%left PLUS
%left SEMICOLON

%type <name> OP
%type <pathloc> Path PlusList

%%



PathUnit	
	: PathUnit PATH Path END
	{
		printf("PathUnit + PATH Path END\n");

		PathNode* pathstart = (PathNode*)malloc(sizeof(PathNode));
		pathstart->next[0] = $3.head;
		pathstart->next_count = 1;
		pathstart->parent[0] = NULL;
		pathstart->parent_count = 0;
		pathstart->type = 5;
		pathstart->start = 0;
		pathstart->finish = 1;
		PathNode* pathend = (PathNode*)malloc(sizeof(PathNode));
		pathend->next[0] == NULL;
		pathend->next_count = 0;
		pathend->parent[0] = $3.tail;
		pathend->parent_count = 1;
		pathend->type = 6;
		pathend->start = 0;
		pathend->finish = 0;

		$3.tail->next[0] = pathend;
		$3.head->parent[0] = pathstart; 
		root[global_count_yacc].pathloc.head = pathstart;
		root[global_count_yacc].pathloc.tail = pathend;
		global_count_yacc++;
	}
	| PATH Path END
	{
		printf("PATH Path END\n");
		PathNode* pathstart = (PathNode*)malloc(sizeof(PathNode));		
		pathstart->next[0] = $2.head;		
		pathstart->next_count = 1;
		pathstart->parent[0] == NULL;
		pathstart->parent_count = 0;
		pathstart->type = 5;
		pathstart->start = 0;
		pathstart->finish = 1;
		PathNode* pathend = (PathNode*)malloc(sizeof(PathNode));		
		pathend->next[0] == NULL;
		pathend->next_count = 0;
		pathend->parent[0] = $2.tail;
		pathend->parent_count = 1;
		pathend->type = 6;
		pathend->start = 0;
		pathend->finish = 0;

		$2.tail->next[0] = pathend;
		$2.head->parent[0] = pathstart; 
		root[global_count_yacc].pathloc.head = pathstart;
		root[global_count_yacc].pathloc.tail = pathend;
		

		global_count_yacc++;	
	}


PlusList
	: PlusList PLUS Path
	{
		printf("PlusList + Path\n");

		$1.head->next[$1.head->next_count] = $3.head;
		$1.head->next_count += 1;
		$1.tail->parent[$1.tail->parent_count] = $3.tail;
		$1.tail->parent_count += 1;
		$3.tail->next[0] = $1.tail;
		$3.head->parent[0] = $1.head;
		

		$$.head = $1.head;
		$$.tail = $1.tail;
	}
	| Path PLUS Path
	{
		printf("Path + Path\n");

		PathNode* begin = (PathNode*)malloc(sizeof(PathNode));
		PathNode* end = (PathNode*)malloc(sizeof(PathNode));
		begin->next[0] = $1.head;
		begin->next[1] = $3.head;
		begin->next_count = 2;
		begin->parent[0] = NULL;
		begin->parent_count = 1;
		begin->type = 1;
		begin->start = 0;
		begin->finish = 0;
		//maybe need begin->opname;
		end->next[0] = NULL;
		end->next_count = 1;
		end->parent[0] = $1.tail;
		end->parent[1] = $3.tail;
		end->parent_count = 2;
		end->type = 2;
		end->start = 0;
		end->finish = 0;
		//maybe need end->opname;
		$1.tail->next[0] = end;
		$1.head->parent[0] = begin;
		$3.tail->next[0] = end;
		$3.head->parent[0] = begin;

		$$.head = begin;
		$$.tail = end;
	}


Path
	: LBRACE Path RBRACE
	{
		printf("{ Path }\n");

		PathNode* begin = (PathNode*)malloc(sizeof(PathNode));
		PathNode* end = (PathNode*)malloc(sizeof(PathNode));
		begin->next[0] = $2.head;
		begin->next_count = 1;
		begin->parent[0] = NULL;
		begin->parent_count = 1;
		begin->type = 3;
		begin->start = 0;
		begin->finish = 0;
		begin->con_num = 0;
		end->next[0] = NULL;
		end->next_count = 1;
		end->parent[0] = $2.tail;
		end->parent_count = 1;
		end->type = 4;
		end->start = 0;
		end->finish = 0;
		end->con_num = 0;
		end->find_begin = begin;
		
		$2.tail->next[0] = end;
		$2.head->parent[0] = begin;

		$$.head = begin;
		$$.tail = end;
	}
	| LPAREN Path RPAREN
	{
		printf("( Path )\n");

		$$.head = $2.head;
		$$.tail = $2.tail;
	}
	| PlusList
	{
		printf("PlusList\n");

		$$.head = $1.head;
		$$.tail = $1.tail;
	}
	| Path SEMICOLON Path
	{
		printf("Path ; Path\n");
		
		
		$1.tail->next[0] = $3.head;
		$3.head->parent[0] = $1.tail;
		
		$$.head = $1.head;
		$$.tail = $3.tail;
	}
	| OP
	{
		printf("%s\n",$1);


		if(root[global_count_yacc].ophead == NULL){
			OpNode* opnode = (OpNode*)malloc(sizeof(OpNode));
			opnode->next = NULL;
			strcpy(opnode->name,$1);
			root[global_count_yacc].ophead = opnode;
		}
		else
		{ 
			OpNode* p = root[global_count_yacc].ophead;
			int flag_insert = 1;
			while(1){
				if(strcmp($1,p->name) == 0){
					flag_insert = 0;
					break;
				}
				if(p->next == NULL)
					break;
				p = p->next;
			}
			if(flag_insert){
				OpNode* opnode = (OpNode*)malloc(sizeof(OpNode));
				opnode->next = NULL;
				strcpy(opnode->name,$1);
				p->next = opnode;
			}
		}



		PathNode* pathnode = (PathNode*)malloc(sizeof(PathNode));
		strcpy(pathnode->opname,$1);
		pathnode->next[0] = NULL;
		pathnode->next_count = 1;
		pathnode->parent[0] = NULL;
		pathnode->parent_count = 1;
		pathnode->type = 0;
		pathnode->start = 0;
		pathnode->finish = 0;
		
		$$.head = pathnode;
		$$.tail = pathnode;
		
	}

%%

void yyerror()
{
	printf("Unacceptable grammar of path expression!\n");
} 

