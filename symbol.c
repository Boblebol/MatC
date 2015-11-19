#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol.h"

struct symbol* symbol_alloc() {
    struct symbol* new = malloc(sizeof(*new));
    new->id = NULL;
    new->isconstant = false;
    new->value = 0;
    new->next = NULL;
}

struct symbol* symbol_newtemp(struct symbol** tds) {
    static int nb_symbol = 0;
    char temp_name[SYMBOL_MAX_NAME];
    snprintf(temp_name, SYMBOL_MAX_NAME, "temp_%d", nb_symbol);
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

void symbol_print(struct symbol* tds) {
    while (tds != NULL) {
        printf("id : %s , value : %d // ", tds->id, tds->value);
        tds = tds->next;
    }
}
