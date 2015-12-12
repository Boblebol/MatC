#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//#include "error.h"
#include "symbol.h"

struct symbol* symbol_alloc() {
    struct symbol* new = malloc(sizeof(*new));
    new->id = NULL;
    new->isconstant = false;
    new->next = NULL;
    return new;
}

struct symbol* symbol_newtemp(struct symbol** tds) {
    static int nb_symbol = 0;
    char temp_name[SYMBOL_MAX_NAME];
    snprintf(temp_name, SYMBOL_MAX_NAME, "temp_%d", nb_symbol++);
    return symbol_add(tds, temp_name);
}

struct symbol* symbol_add(struct symbol** tds, char* id) {
    if (*tds == NULL) {
        *tds = symbol_alloc();
        (*tds)->id = strdup(id);
        return *tds;
    } else {
        struct symbol* scan = *tds;
        while (scan->next != NULL) {
            scan = scan->next;
        }
        scan->next = symbol_alloc();
        scan->next->id = strdup(id);
        return scan->next;
    }
}

struct symbol* symbol_lookup(struct symbol* list, char* id) {
    if (id == NULL)
        return NULL;
    if (list != NULL) {
        struct symbol* scan = list;
		if (scan->id != NULL && strncmp(scan->id, id, SYMBOL_MAX_NAME) == 0) {
                return scan;
		} else {
        while (scan->next != NULL) {
            if (scan->id != NULL && strncmp(scan->id, id, SYMBOL_MAX_NAME) == 0) {
                return scan;
            }
            scan = scan->next;
        }
    }
}
    return NULL;
}

void symbol_free(struct symbol* tds) {
    if (tds != NULL) {
        if (tds->next != NULL) {
            symbol_free(tds->next);
        }
        free(tds);
        tds = NULL;
    }
}

void symbol_print(struct symbol* tds) {
    while (tds != NULL) {
        switch (tds->stype) {
            case SYMBOL_INT:
                printf("--> %s:%d\n", tds->id, tds->v.int_val);
                break;
            case SYMBOL_FLOAT:
                printf("--> %s:%f\n", tds->id, tds->v.float_val);
                break;
            default:
                break;
        }
        tds = tds->next;
    }
}
