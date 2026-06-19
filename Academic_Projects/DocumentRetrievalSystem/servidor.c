#include "servidor.h"
#include "hashtable.h"


char DOCUMENT_FOLDER[128]; // buffer para guardar a diretoria dos documentos


typedef struct CacheNode {
    Document doc;
    struct CacheNode *next;
} CacheNode;

CacheNode *cache_head = NULL;
int cache_count = 0;


int last_key = 0; // definição da variável global



// retorna o último key guardado no ficheiro
int lastKeyGuardada(const char *filename){
    int fd = open(filename, O_RDONLY);
    int key = 0;

    if(fd < 0) {
        perror("Erro ao abrir ficheiro para ver última key.\n");
        return -1;
    }

    if(read(fd, &key, sizeof(int)) != sizeof(int)){
        perror("Erro ao ler a key; tamanho diferente ao que é pretendido.\n");
        close(fd);
        return -1;
    }

    close(fd);
    return key;
}


// guarda a nova key no ficheiro
void atualizaKey(const char* filename, int novaKey){
    int fd = open(filename, O_RDWR);

    if(fd < 0) {
        perror("Erro ao abrir ficheiro para atualizar a key.\n");
        return;
    }

    lseek(fd, 0 , SEEK_SET); // escreve no início do ficheiro
    if(write(fd, &novaKey, sizeof(int)) != sizeof(int)){
        perror("Erro ao escrever key.\n");
        close(fd);
    }

    close(fd);
}

// função para garantir que não reutilize keys removidos do cache
int existeKeyNoFicheiro(const char *filename, int key) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) return 0;

    int dummy;
    read(fd, &dummy, sizeof(int));  // ignora last_key

    Document d;
    while (read(fd, &d, sizeof(Document)) == sizeof(Document)) {
        if (d.key == key) {
            close(fd);
            return 1; // existe
        }
    }

    close(fd);
    return 0; // não encontrado
}



// retorna o key do documento
int indexDoc(char* title, char* authors, char* year, char* path) {
    Document d;

    // extrai nome do ficheiro sem diretoria
    char *filename = strrchr(path, '/');
    filename = (filename) ? filename + 1 : path;

    // tenta obter número do início do nome do ficheiro
    char *endptr;
    int key = strtol(filename, &endptr, 10);

    // verifica se é numérico e termina com '.'
    if (!(key > 0 && *endptr == '.')) {
        key = last_key;  // começa pelo last_key
    }

    // tenta encontrar key livre a partir do valor calculado
    while (existeKeyNoFicheiro(DATA_FILE, key)) {
        key++;
    }

    d.key = key;
    if (key >= last_key) {
        last_key = key + 1;
        atualizaKey(DATA_FILE, last_key);
    }

    // preenche os dados
    strcpy(d.title, title);
    strcpy(d.authors, authors);
    strcpy(d.year, year);
    strcpy(d.path, path);

    // guarda no ficheiro e insere na cache
    adicionaDocumento(DATA_FILE, d);
    inserirNaHash(d);

    return d.key;
}


// imprime a informação do documento requerido
void consult(int key, char* info) {
    DocNode* node = procurarNaHash(key);
    
    // se não estiver na cache, tenta carregar do ficheiro
    if (!node) {
        Document temp = leDocumento(DATA_FILE, key);
        if (temp.key >= 0) {
            inserirNaHash(temp);
            node = procurarNaHash(key); // tentar novamente após inserir
        }
    }

    // se ainda não encontrou, é porque não existe
    if (!node) {
        snprintf(info, 512, "Document not found.\n");
        return;
    }

    Document d = node->doc;
    snprintf(info, 512, "Title: %s\nAuthors: %s\nYear: %s\nPath: %s\n",
             d.title, d.authors, d.year, d.path);
}
 

// retorna 0 se removeu o documento com sucesso ou 1 se ocorreu erros
int deleteIndex(int key) {
    int removido = removerDaHash(key);  // tenta remover da cache

    if (removido == 0) {
        removeDocumento(DATA_FILE, key);  // também remove do ficheiro
        return 0;
    }

    // se não estava na cache, tenta carregar do ficheiro
    Document d = leDocumento(DATA_FILE, key);
    if (d.key != -1) {
        removeDocumento(DATA_FILE, key);  // remove mesmo que não esteja na cache
        return 0;
    }

    // Documento não existe nem na cache nem no ficheiro
    return -1;
}



// retorna o número de linhas que contém a keyword no key documento
int lookUpWordInDoc(int key, char* keyword) {
    DocNode* node = procurarNaHash(key);

    // se não estiver na cache, tenta carregar do ficheiro
    if (!node) {
        Document temp = leDocumento(DATA_FILE, key);
        if (temp.key >= 0) {
            inserirNaHash(temp);
            node = procurarNaHash(key);
        }
    }

    if (!node) {
        return -1; // documento não encontrado
    }

    char caminho_completo[256];
    snprintf(caminho_completo, sizeof(caminho_completo), "%s/%s", DOCUMENT_FOLDER, node->doc.path);
    int fd = open(caminho_completo, O_RDONLY); // garante path correto caso não esteja na mesma diretoria do código
    if (fd < 0) {
        perror("Erro ao abrir ficheiro em lookUpWordInDoc.\n");
        return -1;
    }

    char buffer[1024]; // guarda a leitura direta do ficheiro
    char linha[2048]; // reconstrói as linhas completas com base nos dados lidos do buffer
    int linha_len = 0, count = 0;
    ssize_t bytes_lidos;

    while ((bytes_lidos = read(fd, buffer, sizeof(buffer))) > 0) {
        for (ssize_t i = 0; i < bytes_lidos; i++) {
            if (buffer[i] == '\n' || linha_len >= sizeof(linha) - 1) {
                linha[linha_len] = '\0'; // termina a linha
                if (strstr(linha, keyword)) count++;
                linha_len = 0; // reinicia linha
            } else {
                linha[linha_len++] = buffer[i];
            }
        }
    }

    close(fd);
    return count;
}



// função auxiliar para verificar se eiste a palavra
int contemKeyword(const char *buffer, ssize_t tam, const char *keyword) {
    size_t keyword_len = strlen(keyword);

    if (keyword_len == 0 || tam < keyword_len) {
        return 0;
    }

    for (ssize_t i = 0; i <= tam - keyword_len; i++) {
        int j = 0;
        while (j < keyword_len && buffer[i + j] == keyword[j]) {
            j++;
        }
        if (j == keyword_len) {
            return 1; // rncontrou a palavra
        }
    }
    return 0; // não encontrou
}



// retorna uma string com os keys dos docs que contém o keyword separados por vírgula
void lookUpWord(char *keyword, char *resultado) {
    pid_t pids[HASH_SIZE]; // armazena todos os PIDs dos processos filhos criados
    int keys[HASH_SIZE];
    int count = 0;

    for (int i = 0; i < HASH_SIZE; i++) {
        for (DocNode* doc = hash_table[i]; doc; doc = doc->next) {

            pid_t pid = fork();

            // Filho: é criado um filho por documento para procurar mais rápido
            if (pid == 0) {
                char caminho_completo[256];
                snprintf(caminho_completo, sizeof(caminho_completo), "%s/%s", DOCUMENT_FOLDER, doc->doc.path);

                int fd = open(caminho_completo, O_RDONLY); // garante path correto caso não esteja na mesma diretoria do código

                if (fd < 0) _exit(0);

                char buf[1024];
                ssize_t n;
                int found = 0;

                while ((n = read(fd, buf, sizeof(buf))) > 0) {
                    if (contemKeyword(buf, n, keyword)) {
                        found = 1;
                        break;
                    }
                }

                close(fd);
                _exit(found);
            } 
            else if (pid > 0) {
                pids[count] = pid;
                keys[count] = doc->doc.key;
                count++;
            }
        }
    }

    // Pai: espera os filhos todos terminarem
    for (int i = 0; i < count; i++) {
        int status;
        waitpid(pids[i], &status, 0);

        if (WIFEXITED(status) && WEXITSTATUS(status) == 1) {
            char str[16];
            snprintf(str, sizeof(str), "%d, ", keys[i]);
            strncat(resultado, str, 512 - strlen(resultado) - 1);
        }
    }

    // remove vírgula final se houver
    size_t len = strlen(resultado);
    if (len > 0 && resultado[len - 2] == ',') {
        resultado[len - 2] = '\0';
    }
}


// pesquisa concorrente
void lookUpWordNProcesses(char *keyword, char *resultado, int maxprocesses) {
    pid_t pids[HASH_SIZE];
    int keys[HASH_SIZE];
    int count = 0;
    int activeprocesses = 0;

    for (int i = 0; i < HASH_SIZE; i++) {
        for (DocNode* doc = hash_table[i]; doc; doc = doc->next) {
            
            // Se já temos processos máximos, esperamos que um termine
            while (activeprocesses >= maxprocesses) {
                int status;
                pid_t ended = wait(&status);
                activeprocesses--;

                // Verifica qual PID terminou e guarda o resultado se necessário
                for (int j = 0; j < count; j++) {
                    if (pids[j] == ended && WIFEXITED(status) && WEXITSTATUS(status) == 1) {
                        char str[16];
                        snprintf(str, sizeof(str), "%d, ", keys[j]);
                        strncat(resultado, str, 512 - strlen(resultado) - 1);
                        break;
                    }
                }
            }

            // Cria novo processo
            pid_t pid = fork();
            if (pid == 0) {
                char caminho_completo[256];
                snprintf(caminho_completo, sizeof(caminho_completo), "%s/%s", DOCUMENT_FOLDER, doc->doc.path);
                int fd = open(caminho_completo, O_RDONLY);
                if (fd < 0) _exit(0);

                char buf[1024];
                ssize_t n;
                int found = 0;
                while ((n = read(fd, buf, sizeof(buf))) > 0) {
                    if (contemKeyword(buf, n, keyword)) {
                        found = 1;
                        break;
                    }
                }
                close(fd);
                _exit(found);
            }
            else if (pid > 0) {
                pids[count] = pid;
                keys[count] = doc->doc.key;
                count++;
                activeprocesses++;
            }
        }
    }

    // Espera por todos os restantes processos
    while (activeprocesses > 0) {
        int status;
        pid_t ended = wait(&status);
        activeprocesses--;

        for (int j = 0; j < count; j++) {
            if (pids[j] == ended && WIFEXITED(status) && WEXITSTATUS(status) == 1) {
                char str[16];
                snprintf(str, sizeof(str), "%d, ", keys[j]);
                strncat(resultado, str, 512 - strlen(resultado) - 1);
                break;
            }
        }
    }

    // remove vírgula final se houver
    size_t len = strlen(resultado);
    if (len > 1 && resultado[len - 2] == ',') {
        resultado[len - 2] = '\0';
    }
}



// função que adiciona UM documento no final do ficheiro
void adicionaDocumento(const char *filename, Document d) {
    int fd = open(filename, O_RDWR | O_CREAT, 0644);
    if(fd < 0) {
        perror("Erro ao abrir ficheiro para guardar.\n");
        return;
    }

    // move para o fim do ficheiro
    lseek(fd, 0, SEEK_END);

    // escreve apenas o novo documento
    if(write(fd, &d, sizeof(Document)) != sizeof(Document)) {
        perror("Erro ao escrever documento.\n");
    }

    close(fd);
}


Document leDocumento(const char* filename, int key) {
    Document d;
    d.key = -1; // valor padrão para erro

    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("Erro ao abrir ficheiro.\n");
        return d;
    }

    // lê e ignora o last_key (int inicial)
    int dummy;
    if (read(fd, &dummy, sizeof(int)) != sizeof(int)) {
        perror("Erro ao ler last_key.\n");
        close(fd);
        return d;
    }

    // lê documentos um a um até encontrar a key
    while (read(fd, &d, sizeof(Document)) == sizeof(Document)) {
        if (d.key == key) {
            close(fd);
            return d;
        }
    }

    // não encontrou o documento
    perror("Erro: documento com a key fornecida não encontrado.\n");
    d.key = -1;
    close(fd);
    return d;
}


// função que remove UM documento do ficheiro (marca como key == -1)
void removeDocumento(const char *filename, int key) {
    int fd = open(filename, O_RDWR);
    if (fd < 0) {
        perror("Erro ao abrir ficheiro para remoção lógica.\n");
        return;
    }

    int dummy;
    if (read(fd, &dummy, sizeof(int)) != sizeof(int)) {
        perror("Erro ao ler last_key.\n");
        close(fd);
        return;
    }

    Document doc;
    off_t offset = sizeof(int);  // após last_key
    while (read(fd, &doc, sizeof(Document)) == sizeof(Document)) {
        if (doc.key == key) {
            doc.key = -1;  // marca como removido
            lseek(fd, offset, SEEK_SET);
            write(fd, &doc, sizeof(Document));
            break;
        }
        offset += sizeof(Document);
    }

    close(fd);
}


// função que lê do ficheiro e reconstrói a tabela na memória
void carregaInformacao(const char *filename) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("Erro ao abrir ficheiro para leitura.\n");
        return;
    }

    // lê o valor de last_key guardado no início do ficheiro
    if (read(fd, &last_key, sizeof(int)) != sizeof(int)) {
        perror("Erro ao ler last_key.\n");
        close(fd);
        return;
    }

    // buffer circular com capacidade máxima definida pela cache
    Document ultimos[CACHE_SIZE];
    int total_validos = 0; // número total de documentos válidos lidos

    Document doc;
    // lê os documentos do ficheiro um a um
    while (read(fd, &doc, sizeof(Document)) == sizeof(Document)) {
        if (doc.key >= 0) {
            // substitui o documento mais antigo se o buffer estiver cheio (circular)
            ultimos[total_validos % CACHE_SIZE] = doc;
            total_validos++;
        }
    }

    close(fd);

    // calcula quantos documentos finais devem ser carregados (máx. CACHE_SIZE)
    int count = (total_validos < CACHE_SIZE) ? total_validos : CACHE_SIZE;
    // determina o ponto inicial correto no buffer circular
    int inicio = (total_validos >= CACHE_SIZE) ? (total_validos % CACHE_SIZE) : 0;

    // insere os documentos finais na hash_table (a cache)
    for (int i = 0; i < count; i++) {
        int idx = (inicio + i) % CACHE_SIZE;
        inserirNaHash(ultimos[idx]);
    }
}




// função que atualiza o ficheiro removendo os documentos inválidos
void atualizaInformacao(const char *filename) {
    int fd_old = open(filename, O_RDONLY);
    if (fd_old < 0) {
        perror("Erro ao abrir ficheiro original para limpeza.\n");
        return;
    }

    int fd_new = open("temp.db", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd_new < 0) {
        perror("Erro ao criar ficheiro temporário.\n");
        close(fd_old);
        return;
    }

    // Copia o valor de last_key
    int last;
    if (read(fd_old, &last, sizeof(int)) != sizeof(int)) {
        perror("Erro ao ler last_key.\n");
        close(fd_old); close(fd_new);
        return;
    }

    // Escreve o last_key no novo ficheiro
    write(fd_new, &last, sizeof(int));

    // Copia apenas os documentos com key válida
    Document doc;
    while (read(fd_old, &doc, sizeof(Document)) == sizeof(Document)) {
        if (doc.key >= 0) {
            write(fd_new, &doc, sizeof(Document));
        }
    }

    close(fd_old);
    close(fd_new);

    // Substitui o ficheiro antigo pelo novo
    remove(filename);
    rename("temp.db", filename);
}

/*

// função para testar se guarda tudo no ficheiro
void imprimeTotalNoFicheiro(const char *filename) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("Erro ao abrir ficheiro.\n");
        return;
    }

    int total_validos = 0;

    int last;
    if (read(fd, &last, sizeof(int)) != sizeof(int)) {
        perror("Erro ao ler last_key.\n");
        close(fd);
        return;
    }

    Document doc;
    while (read(fd, &doc, sizeof(Document)) == sizeof(Document)) {
        if (doc.key >= 0) {
            total_validos++;
        }
    }

    close(fd);
    printf("Total de documentos válidos no ficheiro: %d\n", total_validos);
}


// imprime todos os documentos atualmente na cache (hash_table)
void imprimeCache() {
    printf("Documentos atualmente na cache:\n");

    int total = 0;
    for (int i = 0; i < HASH_SIZE; i++) {
        DocNode* atual = hash_table[i];
        while (atual) {
            Document* d = &atual->doc;
            printf("Key: %d | Title: %s | Year: %s | Path: %s\n",
                   d->key, d->title, d->year, d->path);
            total++;
            atual = atual->next;
        }
    }

    printf("Total de documentos na cache: %d\n", total);
}

*/




