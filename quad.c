#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "quad.h"
#include "symbol.h"

struct quad* quad_gen(char* op, struct symbol* arg1, struct symbol* arg2, struct symbol* res) {
	struct quad* new = malloc(sizeof(*new));	
    new->op = strdup(op);	
    new->arg1 = arg1;
    new->arg2 = arg2;
    new->res = res;
    new->next = NULL;
    return new;
}

void quad_add(struct quad** list, struct quad* new) {    
	if (*list == NULL) {
        *list = new;
    } else {
        struct quad* scan = *list;
        while (scan->next != NULL) {
            scan = scan->next;
        }
        scan->next = new;
    }
}

void quad_print(struct quad* list) {
	while (list != NULL) {
        printf("%s %7s %7s %7s\n", list->op, list->arg1->id, list->arg2->id, list->res->id);
        list = list->next;
    }
}

void quad_free(struct quad* list) {
    if (list != NULL) {
        if (list->next != NULL) {
            quad_free(list->next);
        }
        free(list);
        list = NULL;
    }
}
