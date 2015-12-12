#ifndef SYMBOL_H_
#define SYMBOL_H_

#include <stdbool.h>
#define SYMBOL_MAX_NAME 64

enum symbol_types {
    SYMBOL_INT,
    SYMBOL_FLOAT
};

struct symbol {
    char* id;
    bool isconstant;
    enum symbol_types stype;
    union {
        int int_val;
        float float_val;
    } v;
    struct symbol* next;
};

struct symbol* symbol_alloc();
struct symbol* symbol_newtemp(struct symbol**);
struct symbol* symbol_add(struct symbol**, char*);
struct symbol* symbol_lookup(struct symbol*, char*);
void           symbol_free(struct symbol*);
void           symbol_print(struct symbol*);

#endif
