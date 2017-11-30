#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>	
#include "global.h"

//queue
PathNode* queue[100];
int head ;
int tail ;

void Insert(PathNode* pathnode){
	queue[tail] = pathnode;
	tail = (tail+1)%100;
}

PathNode* Delete(){
	head = (head+1)%100;
	return queue[(head-1)%100];
}

int Is_Empty(){
	if(head == tail)
		return 1;
	else
		return 0;
}

PathNode* Q[100];
int Qhead ;
int Qtail ;

void QInsert(PathNode* pathnode){
	Q[Qtail] = pathnode;
	Qtail = (Qtail+1)%100;
}

PathNode* QDelete(){
	Qhead = (Qhead+1)%100;
	return Q[(Qhead-1)%100];
}

int QIs_Empty(){
	if(Qhead == Qtail)
		return 1;
	else
		return 0;
}


void after_run(const char *op_name){
	for(int i=0;i<numPath;i++){
		OpNode* p = root[i].ophead;
		int flag_restrict = 0;
		while(p!=NULL){
			if(strcmp(p->name,op_name) == 0){
				flag_restrict = 1;
				break;
			}
			p = p->next;
		}
		
		if(flag_restrict == 0){
			continue;
		}

		head =0; tail =0;
		PathNode* cur;
		Insert(root[i].pathloc.head);
		while(!Is_Empty()){
			cur = Delete();
			if(cur->start >= 1 && strcmp(cur->opname,op_name)==0){
				cur->start -= 1 ;
				cur->finish += 1; 
				break;
			}
			else{
				for(int j=0;j<cur->next_count;j++){
					Insert(cur->next[j]);
				}
			}
		}

		PathNode* precur = cur;  
		while(cur->next[0]->type == 2 || cur->next[0]->type == 4){
			cur = cur->next[0];
			if(cur->type == 4){
				cur->con_num++;
				if(cur->con_num == cur->find_begin->con_num){
					cur->con_num = 0;
					cur->find_begin->con_num = 0;
					cur->find_begin->finish = 0;
				}
				else{
					precur->finish -= 1;
					break;
				}
			}
		}
	}
					
			
	

}

void pre_run(const char *op_name){
	for(int i=0;i<numPath;i++){
		if(restrict_path[i] == 0){
			continue;
		}
		PathNode* cur = pre_state[i];
		cur->start += 1;

		Qhead =0; Qtail =0;
		for(int j=0;j<cur->parent_count;j++){
			QInsert(cur->parent[j]);
		}

		while(!QIs_Empty()){
			PathNode* tmp = QDelete();
			if(tmp->finish >= 1){
				tmp->finish -= 1;
				break;
			}
			else{
				for(int j=0;j<tmp->parent_count;j++){
					QInsert(tmp->parent[j]);
				}
				if(tmp == root[i].pathloc.head){
					QInsert(root[i].pathloc.tail);
				}
			}
		}
		
		if(cur->type == 0){
			while(cur->parent[0]->type == 1 || cur->parent[0]->type == 3){
				cur = cur->parent[0];
				if(cur->type == 3){
					cur->finish = 1;
					cur->con_num++;
				}
			}
		}

	}



}
int enter_test(const char *op_name){
	int test_result = 1;	
	for(int i=0;i<numPath;i++){
		OpNode* p = root[i].ophead;
		int flag_restrict = 0;
		while(p!=NULL){
			if(strcmp(p->name,op_name) == 0){
				flag_restrict = 1;
				break;
			}
			p = p->next;
		}
		
		if(flag_restrict == 0){
			restrict_path[i] = 0;
			continue;
		}

		restrict_path[i] = 1;
		
		//bfs tree
		int flag_match = 0;
		head = 0;
		tail = 0;
		Insert(root[i].pathloc.head);
		while(!Is_Empty()){
			PathNode* cur = Delete();
			if(cur->finish >= 1){ 
				//test
				Qhead =0;
				Qtail=0;
				for(int j=0;j<cur->next_count;j++){ 
					QInsert(cur->next[j]);
				}
				while(!QIs_Empty()){
					PathNode* tmp = QDelete(); 
					if(tmp->type == 0){
						if(strcmp(tmp->opname,op_name) == 0){
							flag_match = 1;
							pre_state[i] = tmp;
							break;
						}
					}
					else{
						if(tmp == root[i].pathloc.tail){
							QInsert(root[i].pathloc.head);
						}
						for(int j=0;j<tmp->next_count;j++){
							QInsert(tmp->next[j]);
						}
					}
				}
				if(flag_match == 1){
					break;
				}	
			}
			for(int j=0;j<cur->next_count;j++){
				Insert(cur->next[j]);
			}
		}
		
		if(flag_match == 0){
			test_result = 0;
			break;
		}
	}
	return test_result;
			
}
	
