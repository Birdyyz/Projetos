#include <stdlib.h>
#include <stdio.h>
#include "hashtable.h"



int CACHE_SIZE = 50; // definido no arranque do servidor
int current_cache_size = 0; // número atual de entradas na hash



DocNode* hash_table[HASH_SIZE] = { NULL };

unsigned int hash(int key) {
    return key % HASH_SIZE;
}

void inserirNaHash(Document d) {
    if (current_cache_size >= CACHE_SIZE) { // verificar se o cache está cheio
        removerElementoMaisAntigo();
    }
    
    unsigned int h = hash(d.key);
    DocNode* novo = (DocNode*)malloc(sizeof(DocNode));
    if (!novo) {
        perror("Erro de alocação");
        return;
    }

    novo->doc = d;
    novo->prev = NULL;
    novo->next = hash_table[h];
    if (hash_table[h]) hash_table[h]->prev = novo;
    hash_table[h] = novo;

    current_cache_size++; // incrementar o tamanho atual ocupado da cache

}

DocNode* procurarNaHash(int key) {
    unsigned int h = hash(key);
    DocNode* atual = hash_table[h];
    while (atual) {
        if (atual->doc.key == key) return atual;
        atual = atual->next;
    }
    return NULL;
}

int removerDaHash(int key) {
    DocNode* node = procurarNaHash(key);
    if (!node) return -1;

    if (node->prev) node->prev->next = node->next;
    else hash_table[hash(key)] = node->next;
    if (node->next) node->next->prev = node->prev;

    free(node);
    return 0;
}

void limparHash() {
    for (int i = 0; i < HASH_SIZE; i++) {
        DocNode* atual = hash_table[i];
        while (atual) {
            DocNode* temp = atual;
            atual = atual->next;
            free(temp);
        }
        hash_table[i] = NULL;
    }
}

// função para remover o elemento mais antigo
void removerElementoMaisAntigo() {
    for (int i = 0; i < HASH_SIZE; i++) {
        if (hash_table[i] != NULL) {
            DocNode* temp = hash_table[i];
            hash_table[i] = temp->next;
            free(temp);
            current_cache_size--;
            return;
        }
    }
}


