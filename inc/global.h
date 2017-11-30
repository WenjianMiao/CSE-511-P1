#ifndef _GLOBAL_H_
#define _GLOBAL_H_

//restricted operation 
typedef struct OpNode{
	char name[20];
	struct OpNode *next;
} OpNode;



//basic PathNode
typedef struct PathNode{
	char opname[20];
	struct PathNode *next[20];
	int next_count;
	struct PathNode *parent[20];
	int parent_count;
	int type;   //type 0->opname node || 1->+begin 2->+end 3->{}begin 4->{}end 5->pathstart 6->pathend 
	int start;
	int finish; 
	int con_num;
	struct PathNode *find_begin;
} PathNode;

//PathLocation
typedef struct {
	PathNode* head;
	PathNode* tail;
} PathLocation;

typedef struct {
	//restricted operation list
	OpNode* ophead;

	PathLocation pathloc;

} PathInfo;


extern PathInfo* root;

	
extern int numPath;
extern int global_count_lex;
extern int global_count_yacc;

extern PathNode* pre_state[100];
extern int restrict_path[100];


#endif
