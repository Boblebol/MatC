struct quad {
    char op;
    struct symbol* arg1;
    struct symbol* arg2;
    struct symbol* res;
    struct quad* next;
};

void quad_add(struct quad** list, struct quad* new);
struct quad* quad_gen(char op, struct symbol* arg1, struct symbol* arg2, struct symbol* res);
void quad_print(struct quad* list);
