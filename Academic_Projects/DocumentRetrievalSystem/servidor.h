#ifndef SERVIDOR_H
#define SERVIDOR_H

#include <stdio.h>  
#include <stdlib.h>  
#include <string.h>     
#include <unistd.h>    
#include <fcntl.h>   
#include <sys/types.h>
#include <sys/wait.h>   
#include <signal.h>    
#include <errno.h>     
#include <sys/stat.h>

#define DATA_FILE "servidor.db" // ficheiro para guardar as informações de dserver



typedef struct {
    int key;
    char title[200];
    char authors[200];
    char year[5];
    char path[64];
} Document;


typedef struct {
    int key;
    char command;
    char title[200];
    char authors[200];
    char year[5];
    char path[64];
    char keyword[64];
    int n_processes;
    char client_fifo[64];
} Request;


// com extern todos que inclui servidor.h podem ter acesso a esta variável ( = public em java)
extern int last_key; 

extern char DOCUMENT_FOLDER[128];



// retorna o último key guardado no ficheiro
int lastKeyGuardada(const char *filename);

// guarda a nova key no ficheiro
void atualizaKey(const char* filename, int novaKey);

// função para garantir que não reutilize keys removidos do cache
int existeKeyNoFicheiro(const char *filename, int key);

// retorna o key do documento
int indexDoc(char* title, char* authors, char* year, char* path);

// imprime a informação do documento requerido
void consult(int key, char* info);

// retorna 0 se removeu o documento com sucesso ou 1 se ocorreu erros
int deleteIndex(int key);

// retorna o número de linhas que contém a keyword no key documento
int lookUpWordInDoc(int key, char* keyword);

// retorna uma string com os keys dos docs que contém o keyword separados por vírgula
void lookUpWord(char *keyword, char *resultado);

// pesquisa concorrente
void lookUpWordNProcesses(char *keyword, char *resultado, int maxprocesses);


// função auxiliar para verificar se eiste a palavra
int contemKeyword(const char *buffer, ssize_t tam, const char *keyword);

// função que adiciona UM documento no final do ficheiro
void adicionaDocumento(const char *filename, Document d);

// função que lê UM documento do ficheiro com base na key
Document leDocumento(const char* filename, int key);

// função que remove UM documento do ficheiro (marca como key == -1)
void removeDocumento(const char *filename, int key);

// função que lê do ficheiro e reconstrói docs[] e last_key na memória
void carregaInformacao(const char *filename);

// função que atualiza o ficheiro removendo os documentos inválidos
void atualizaInformacao(const char *filename);

// função para testar se guarda tudo no ficheiro
//void imprimeTotalNoFicheiro(const char *filename);

// imprime todos os documentos atualmente na cache (hash_table)
//void imprimeCache();



#endif