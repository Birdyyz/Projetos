#include "servidor.h"
#include <locale.h>


// escreve no server_fifo e lê a resposta do client_fifo

int main(int argc, char *argv[]) {

    // para imprimir os caracteres específicos em português
    setlocale(LC_ALL, ""); 


    // verifica se o comando está no formato adequado
    if (argc < 2) {
        perror("Argumentos inválidos.\n");

        // imprime um guião de uso do programa dclient
        printf("Comandos disponíveis:\n");
        printf("Indexação: dclient -a \"title\" \"authors\" \"year\" \"path\"\n");
        printf("Consulta: dclient -c \"key\"\n");
        printf("Remoção: dclient -d \"key\"\n");
        printf("Pesquisa sobre o conteúdo no documento: dclient -l \"key\" \"keyword\"\n");
        printf("Pesquisa sobre o conteúdo geral: dclient -s \"keyword\"\n");
        printf("Sair: -f\n");
        return 1;
    }


    // cria o novo struct para organizar o pedido recebido e inicializa a 0 para evitar erros
    Request r;
    memset(&r, 0, sizeof(Request));


    // cria e atribui o nome ao FIFO de resposta
    snprintf(r.client_fifo, sizeof(r.client_fifo), "client_%d_fifo", getpid());
    if (mkfifo(r.client_fifo, 0600) < 0) {
        perror("Erro ao criar FIFO do cliente");
        return 1;
    }


    // verifica se argv[1] é "-a", que indexa um novo documento
    else if (strcmp(argv[1], "-a") == 0) {
        r.command = 'a';
        strcpy(r.title, argv[2]);
        strcpy(r.authors, argv[3]);
        strcpy(r.year, argv[4]);
        strcpy(r.path, argv[5]);
    }

    // verifica se argv[1] é "-c", que imprime as informações guardadas do documento pedido
    else if(strcmp(argv[1],"-c") == 0) {
        r.command = 'c';
        r.key = atoi(argv[2]);
    }

    // verifica se argv[1] é "-d", que remove a indexação de um documento (não elimina o documento)
    else if(strcmp(argv[1],"-d") == 0) {
        r.command = 'd';
        r.key = atoi(argv[2]);
    
    }

    // verifica se argv[1] é "-l", que devolve o número de linhas que contém "keyword" de um dado documento 
    else if(strcmp(argv[1],"-l") == 0) {
        r.command = 'l';
        r.key = atoi(argv[2]);
        strcpy(r.keyword, argv[3]);
    }

    // verifica se argv[1] é "-s", que devolve uma lista de documentos indexados que contém "keyword"
    else if(strcmp(argv[1],"-s") == 0) {
        r.command = 's';
        strcpy(r.keyword, argv[2]);
        r.n_processes = (argc == 4) ? atoi(argv[3]) : 0;  // 0 significa "usar todos"
    }

    // verifica se argv[1] é "-f", que encerra o programa e atualiza o estado no ficheiro
    else if(strcmp(argv[1], "-f") == 0) {
        r.command = 'f';
    }    

    else {
    perror("Comando inválido.\n");
    unlink(r.client_fifo);
    return 1;
    }


    // envia o pedido ao servidor
    int server_fd = open("server_fifo", O_WRONLY);
    if (server_fd < 0) {
        perror("Erro ao abrir server_fifo");
        unlink(r.client_fifo);
        return 1;
    }
    write(server_fd, &r, sizeof(Request)); // envia a struct r ao dserver
    close(server_fd);


    // lê a resposta do servidor
    int reply_fd = open(r.client_fifo, O_RDONLY);
    if (reply_fd < 0) {
        perror("Erro ao abrir o FIFO do cliente");
        unlink(r.client_fifo);
        return 1;
    }
    char buffer[1024];
    ssize_t n = read(reply_fd, buffer, sizeof(buffer) - 1);
    if (n > 0) {
        buffer[n] = '\0'; // garante que a imprimiu tudo
        printf("%s\n", buffer);
    }
    close(reply_fd);
    unlink(r.client_fifo);


    return 0;
}



