#include "servidor.h"
#include "hashtable.h"
#include <locale.h>

// lê do server_fifo e escreve a resposta no client_fifo

int main(int argc, char *argv[]) { // ./dserver document_folder cache_size

    if (argc < 3) {
        fprintf(stderr, "Uso: %s <document_folder> <cache_size>\n", argv[0]);
        exit(1);
    }

    // define a diretoria dos documentos a indexar (útil para aceder ao path correto)
    strcpy(DOCUMENT_FOLDER, argv[1]);


    // define o tamanho da cache
    CACHE_SIZE = atoi(argv[2]);

    // para imprimir os caracteres específicos em português
    setlocale(LC_ALL, ""); 


    // cria o FIFO: server_fifo (não estava a compilar num ficheiro separado)
    int res = mkfifo("server_fifo", 0600);
    if (res < 0 && errno != EEXIST) {
        perror("Erro ao criar o FIFO do servidor.\n");
        return 1;
    }


    // verifica se é a primeira execução do programa (não tem nada no ficheiro)
    int fd_check = open(DATA_FILE, O_RDONLY);

    if (fd_check < 0) { // ficheiro não existe, cria estrutura base
        int fd = open(DATA_FILE, O_WRONLY | O_CREAT, 0644);
        if (fd >= 0) {
            int zero = 0;
            write(fd, &zero, sizeof(int)); // só escreve last_key = 0
            close(fd);
            printf("Ficheiro de dados inicializado.\n");
        } else {
            perror("Erro a criar ficheiro inicial.\n");
            return 1;
        }
    }
    
    // carrega os dados do ficheiro (mesmo na primeira vez, só vai ler o 0)
    carregaInformacao(DATA_FILE);

    // testar se colocou correto no ficheiro
    //imprimeCache();
    //imprimeTotalNoFicheiro(DATA_FILE);


    // abre o FIFO para leitura e escrita (escrita para evitar erro quando ainda não tem clientes)
    int server_fd = open("server_fifo", O_RDWR);
    if (server_fd < 0) {
        perror("Erro ao abrir o FIFO do servidor.\n");
        return 1;
    }


    // apenas cria o espaço de struct para o servidor poder processar o pedido
    Request pedido;


    // o pai está sempre à espera de receber pedidos, encontra um e cria o filho para responder
    while (1) {

        // lê o pedido do server_fifo, preenchendo a struct criada com os dados recebidos
        read(server_fd, &pedido, sizeof(Request));


        // verifica se argv[1] é "-f", que encerra o programa
        if (pedido.command == 'f') {

            // responde ao cliente
            int reply_fd = open(pedido.client_fifo, O_WRONLY);
            if (reply_fd >= 0) {
                char resposta[] = "Server is shutting down.\n";
                write(reply_fd, resposta, strlen(resposta));
                close(reply_fd);
            }

            atualizaInformacao(DATA_FILE); // atualiza o ficheiro
            unlink("server_fifo"); // evita lixo no sistema
            exit(0); // evita zumbis, o pai termina normalmente
        }


        // cria um pipe anónimo para comunicar o novo key indexado entre o filho e o pai
        int key_pipe[2];
        if (pipe(key_pipe) == -1) {
            perror("Erro ao criar pipe.\n");
            continue;
        }

    
        // cria processo filho para tratar o pedido
        pid_t pid = fork();

        if(pid == 0) {

            close(key_pipe[0]); // fecha leitura no filho

            // array para guardar a resposta para dps enviar ao cliente
            char resposta[512];
            resposta[0] = '\0';  // reseta a string para cada processo


            // verifica se argv[1] é "-a", que indexa um novo documento
            if(pedido.command == 'a') {
                int res = indexDoc(pedido.title, pedido.authors, pedido.year, pedido.path);
                write(key_pipe[1], &res, sizeof(int)); // envia a key real para o pai
                close(key_pipe[1]); // fecha escrita no filho
                snprintf(resposta, sizeof(resposta), "Document %d indexed.\n", res);
            }

            // verifica se argv[1] é "-c", que imprime as informações guardadas do documento pedido
            else if(pedido.command == 'c') {
                consult(pedido.key, resposta);
            }

            // verifica se argv[1] é "-d", que remove a indexação de um documento (não elimina o documento)
            else if(pedido.command == 'd') {
                int res = deleteIndex(pedido.key);
                if(res == 0) {
                    snprintf(resposta, sizeof(resposta), "Index entry %d deleted.\n", pedido.key);
                } else {
                    snprintf(resposta, sizeof(resposta), "Document not found.\n");
                } 
            }

            // verifica se argv[1] é "-l", que devolve o número de linhas que contém "keyword" de um dado documento 
            else if(pedido.command == 'l') {
                int res = lookUpWordInDoc(pedido.key, pedido.keyword);
                if(res < 0) {
                    snprintf(resposta, sizeof(resposta), "Document not found.\n");
                }
                else if(res == 0) { // se não encontrar em nenhuma linha
                    snprintf(resposta, sizeof(resposta), "Document does not include the word: \"%s\".\n", pedido.keyword);
                } else {
                    snprintf(resposta, sizeof(resposta), "Document %d have %d lines with word: \"%s\".\n", 
                    pedido.key, res, pedido.keyword);
                }    
            }

            // verifica se argv[1] é "-s", que devolve uma lista de documentos indexados que contém "keyword"
            else if(pedido.command == 's') {
                char ids[500];
                ids[0] = '\0';
                if (pedido.n_processes > 0) { // se pedir limite de processos
                    lookUpWordNProcesses(pedido.keyword, ids, pedido.n_processes);
                } else {
                    lookUpWord(pedido.keyword, ids);
                }

                if(ids[0] == '\0') {
                    snprintf(resposta, sizeof(resposta), "No documents with the word: \"%s\".\n", pedido.keyword);
                } else {
                    snprintf(resposta, sizeof(resposta), "[%s]\n", ids);
                }
            }


            // envia a resposta ao cliente
            int reply_fd = open(pedido.client_fifo, O_WRONLY);
            if (reply_fd >= 0) {
                write(reply_fd, resposta, strlen(resposta));
                close(reply_fd);
            } 
            else {
                perror("Erro ao abrir FIFO do cliente.\n");
            }


            // termina o filho
            exit(0);
        }
        else { // o pai precisa de atualizar na sua memória as alterações

            close(key_pipe[1]); // fecha escrita no pai

            int status;
            waitpid(pid, &status, 0);
        
            if (WIFEXITED(status)) {
                if (pedido.command == 'a') { 
                    int key_recebida;
                    if (read(key_pipe[0], &key_recebida, sizeof(int)) == sizeof(int)) {
                        Document novo_doc = leDocumento(DATA_FILE, key_recebida);
                        if (novo_doc.key != -1) {
                            inserirNaHash(novo_doc);
                        }
                    } else {
                        perror("Erro ao ler key do filho via pipe.\n");
                    }

                    close(key_pipe[0]); // fecha leitura no pai
                } 
                
                else if (pedido.command == 'd') {
                    removerDaHash(pedido.key);
                }
            }
        }
    }

    return 0;
}


