#include <stdio.h>
#include <wchar.h>
#include <locale.h>
#include <stdlib.h>

#define MAX_CONJUNTOS 1000
#define MAX_CONJUNTOS4 1000
int extrairvalor(wchar_t carta) {
    return (carta & 0xF);
}
int extrairnaipe(wchar_t carta) {
    return (carta & 0xF0) / 16;
}
void eliminaCarta(wchar_t mao[], wchar_t jogadapretendida[]) {
    // Percorre as cartas da jogada
    for (int i = 0; jogadapretendida[i] != L'\0'; i++) {
        // Percorre as cartas da mão
        for (int j = 0; mao[j] != L'\0'; j++) {
            // Se a carta da jogada for encontrada na mão
            if (jogadapretendida[i] == mao[j]) {
                // Elimina a carta da mão
                for (int k = j; mao[k] != L'\0'; k++) {
                    mao[k] = mao[k + 1];
                   // wprintf(L"encontrouigual\n");
                }
            }
        }
    }
                  //wprintf(L"mao depois da jogada: %ls\n", mao);

}
int compararcartas(wchar_t carta1, wchar_t carta2) {
    int valor1 = extrairvalor(carta1);
    int valor2 = extrairvalor(carta2);

    if (valor1 > valor2) {
        return 1;
    } else if (valor1 < valor2) {
        return -1;
    } else {
        int naipe1 = extrairnaipe(carta1);
        int naipe2 = extrairnaipe(carta2);
        
        if (naipe1 > naipe2) {
            return 1;
        } else if (naipe1 < naipe2) {
            return -1;
        } else {
            return 0;
        }
    }
}
void organizar(wchar_t mao[], int tamanho) {
    for (int i = 0; i < tamanho - 1; i++) {
        for (int j = 0; j < tamanho - i - 1; j++) {
            int atual = extrairvalor(mao[j]);
            int proximo = extrairvalor(mao[j + 1]);
            
            if (atual > proximo || (atual == proximo && mao[j] > mao[j + 1])) {
                wchar_t temp = mao[j];
                mao[j] = mao[j + 1];
                mao[j + 1] = temp;
            }
        }
    }
}
int consecutiva(wchar_t carta1, wchar_t carta2) {
    int s = 0;
    if ((extrairvalor(carta1) + 1) == (extrairvalor(carta2))) {
        s = 1;
    }
    return s;
}
int tipocombinacoes(wchar_t mao[]) {
    int tamanho = wcslen(mao);
    organizar(mao, tamanho); 

    if (tamanho == 1) {
        return 1;
    }

    for (int i = 0; i < tamanho - 1; i++) {
        if (extrairvalor(mao[i]) == extrairvalor(mao[i + 1])) {
            if (i + 2 < tamanho && consecutiva(mao[i], mao[i + 2]) && tamanho >= 6) {
                return 3;
            } else {
                return 1;
            }
        } else {
            if (consecutiva(mao[i], mao[i + 1]) && tamanho >= 3) {
                return 2;
            } else {
                return -1;
            }
        }
    }
    return -1;
}

int contarCaracter(wchar_t *str, wchar_t valork) {
    int contador = 0;
    while (*str != L'\0') {
        if (extrairvalor(*str) == extrairvalor(valork)) {
            contador++;
        }
        str++;
    }
    return contador;
}

//Conjuntos normais (sem caso K)
void encontrarconjuntos(wchar_t mao[], int tamanho, wchar_t conjuntos_encontrados[][14], int *num_conjuntos, wchar_t conjunto[], int tamanhoconjunto, int posicao, int tamanhoant, int naipeCartaMaisAlta, int valorCartaMaisAlta) {
    if (tamanhoconjunto == tamanhoant) {
        if((extrairvalor(conjunto[tamanhoconjunto-1]) == valorCartaMaisAlta && extrairnaipe(conjunto[tamanhoconjunto-1])<naipeCartaMaisAlta) ){
            return;
        } else {
            for (int i = 0; i < tamanhoant; i++) {
                conjuntos_encontrados[*num_conjuntos][i] = conjunto[i];
            }
            (*num_conjuntos)++;
            return;
        }
    }
    for (int i = posicao; i < tamanho; i++) {
        if (extrairvalor(mao[i]) == extrairvalor(conjunto[0]) && (extrairnaipe(mao[i]) != extrairnaipe(conjunto[0]))) { //comparar a carta que queremos adicionar com a que já temos
            conjunto[tamanhoconjunto++] = mao[i];
            encontrarconjuntos(mao, tamanho, conjuntos_encontrados, num_conjuntos, conjunto, tamanhoconjunto, i + 1, tamanhoant, naipeCartaMaisAlta, valorCartaMaisAlta);
            tamanhoconjunto--;
        }
    }
}
void criaconjuntos(wchar_t mao[], int tamanho, wchar_t jogadaanterior[], wchar_t conjuntos_encontrados[][14], int *num_conjuntos, int tamanhoant) {
    int valorCartaMaisAlta= extrairvalor(jogadaanterior[tamanhoant-1]);
    int naipeCartaMaisAlta= extrairnaipe(jogadaanterior[tamanhoant-1]);

    for (int i = 0; i < tamanho; i++) {
        if ((extrairvalor(mao[i])>valorCartaMaisAlta) || ( (extrairvalor(mao[i])== valorCartaMaisAlta && extrairnaipe(mao[i])>naipeCartaMaisAlta ) ) || ( (extrairvalor(mao[i])== valorCartaMaisAlta && extrairnaipe(mao[i])<naipeCartaMaisAlta)) ) {
            wchar_t conjunto[4];
            conjunto[0] = mao[i];
            int tamanho_conjunto = 1;
            encontrarconjuntos(mao, tamanho, conjuntos_encontrados, num_conjuntos, conjunto, tamanho_conjunto, i + 1, tamanhoant, naipeCartaMaisAlta, valorCartaMaisAlta);
        }
    }
}
void imprimir_conjuntosvalormaisalto(wchar_t conjuntos_encontrados[][14],int comprimentoconjuntos) {
            for (int j = 0; j < comprimentoconjuntos; j++) {
                wprintf(L"%lc", conjuntos_encontrados[0][j]);
                if (j < comprimentoconjuntos - 1) {
                    wprintf(L" ");

            }
        }
                    wprintf(L"\n");
                   // wprintf(L"valormaisalto\n");

        }


void imprimirconjuntosAux (wchar_t conjuntos_encontrados[][14], wchar_t mao[], int naipeCartaMaisAlta){
    if (extrairnaipe(conjuntos_encontrados[1][1])>naipeCartaMaisAlta){
        int comprimentoconjuntos1 = wcslen(conjuntos_encontrados[1]);
        for (int j = 0; j < comprimentoconjuntos1; j++) {
            wprintf(L"%lc", conjuntos_encontrados[1][j]);
            if (j < comprimentoconjuntos1 - 1) {
                wprintf(L" ");
            }
        }
        wprintf(L"\n");
          //wprintf(L"terceiro if\n");

        eliminaCarta(mao, conjuntos_encontrados[1]); 
        return;
    }
    else {
        wprintf(L"PASSO");
        return;
    }
}
void imprimir_conjuntos(wchar_t conjuntos_encontrados[][14], int num_conjuntos, wchar_t jogadaanterior[], int tamanhoant, wchar_t mao[]) {
    int valorCartaMaisAlta = extrairvalor(jogadaanterior[tamanhoant - 1]);
    int comprimentoconjuntos = wcslen(conjuntos_encontrados[0]);

    if (extrairvalor(conjuntos_encontrados[0][comprimentoconjuntos - 1]) > valorCartaMaisAlta) {
        imprimir_conjuntosvalormaisalto(conjuntos_encontrados, comprimentoconjuntos);
        eliminaCarta(mao, conjuntos_encontrados[0]); 
        return;
                            //wprintf(L"primeiro if\n");

    }

    int naipeCartaMaisAlta = extrairnaipe(jogadaanterior[tamanhoant - 1]);
    if (extrairnaipe(conjuntos_encontrados[0][comprimentoconjuntos - 1]) > naipeCartaMaisAlta) {
        for (int j = 0; j < comprimentoconjuntos; j++) {
            wprintf(L"%lc", conjuntos_encontrados[0][j]);
            if (j < comprimentoconjuntos - 1) {
                wprintf(L" ");
            }
        }
        wprintf(L"\n");
                                    //wprintf(L"segundo if\n");
        eliminaCarta(mao, conjuntos_encontrados[0]);
        return;
    } else if (num_conjuntos > 1) {
      imprimirconjuntosAux(conjuntos_encontrados,mao,naipeCartaMaisAlta);
      return;
    }
}
//Conjunto para responder a um K
void imprimir_conjuntos4(wchar_t conjuntos[][4], int num_conjuntos4, wchar_t ultimajogada[], int tamanhoant, wchar_t mao[]) {
    int naipeCartaMaisAlta = extrairnaipe(ultimajogada[tamanhoant - 1]);

    if (extrairnaipe(conjuntos[num_conjuntos4 - 1][3]) > naipeCartaMaisAlta) {
        for (int j = 0; j < 4; j++) {
            wprintf(L"%lc", conjuntos[num_conjuntos4 - 1][j]); 
            if (j != 3) {
                wprintf(L" "); 
            }
        }
        wprintf(L"\n");
        eliminaCarta(mao, conjuntos[num_conjuntos4 - 1]); 
    } else {
        wprintf(L"PASSO");
    }
}


void criarConjunto4(wchar_t mao[], int tamanho, wchar_t conjuntos4[][4], int *num_conjuntos4) {
    for (int i = tamanho - 1; i >= 0; i--) { // Começa da última carta e anda para trás
        if (i >= 3 && extrairvalor(mao[i]) == extrairvalor(mao[i - 1]) &&
            extrairvalor(mao[i]) == extrairvalor(mao[i - 2]) &&
            extrairvalor(mao[i]) == extrairvalor(mao[i - 3])) {
            conjuntos4[*num_conjuntos4][0] = mao[i - 3];
            conjuntos4[*num_conjuntos4][1] = mao[i - 2];
            conjuntos4[*num_conjuntos4][2] = mao[i - 1];
            conjuntos4[*num_conjuntos4][3] = mao[i]; 
            (*num_conjuntos4)++; 
            i -= 3; 
        }
    } 
}


//Sequencias
void imprimesequencia(wchar_t mao[], int indices[], int tamanhoSequencia) {
    wchar_t cartasRemover[tamanhoSequencia + 1];
    for (int i = 0; i < tamanhoSequencia; i++) {
        cartasRemover[i] = mao[indices[i]];
    }
    cartasRemover[tamanhoSequencia] = L'\0';

    for (int i = 0; i < tamanhoSequencia; i++) {
        wprintf(L"%lc", mao[indices[i]]);
        if (i != tamanhoSequencia - 1) {
            wprintf(L" ");
        }
    }
    wprintf(L"\n");
    eliminaCarta(mao, cartasRemover);
}

void criasequencias(wchar_t mao[], int tamanho, int tamanhoSequencia, wchar_t cartaMaisAlta, int *encontradoSeq, int indices[14]) {
    int i, j;
    for (i = 0; i < tamanhoSequencia; i++) {
        indices[i] = i;
    }
    int r = 0;
    while (!r && !(*encontradoSeq)) {
        int sequenciaValida = 1;
        for (i = 0; i < tamanhoSequencia - 1; i++) {
            if (!consecutiva(mao[indices[i]], mao[indices[i + 1]])) {
                sequenciaValida = 0;
            }
        }
        if (sequenciaValida && (extrairvalor(mao[indices[tamanhoSequencia - 1]]) > extrairvalor(cartaMaisAlta) || (extrairvalor(mao[indices[tamanhoSequencia - 1]]) == extrairvalor(cartaMaisAlta) && extrairnaipe(mao[indices[tamanhoSequencia - 1]]) > extrairnaipe(cartaMaisAlta)))) {
            imprimesequencia(mao, indices, tamanhoSequencia);
            *encontradoSeq = 1; // encontradoSeq 1 se uma sequência for encontrada
        }

        i = tamanhoSequencia - 1;
        while (i >= 0 && indices[i] == tamanho - (tamanhoSequencia - i)) {
            i--;
        }
        if (i < 0) {
            r = 1;
        } else {
            indices[i]++;
            for (j = i + 1; j < tamanhoSequencia; j++) {
                indices[j] = indices[j - 1] + 1;
            }
        }
    }
}


//Dupla sequencia 

void imprimeduplasequencia(wchar_t mao[], int indices[], int tamanhoDupSequencia) {
    wchar_t cartasRemover[tamanhoDupSequencia];
    for (int i = 0; i < tamanhoDupSequencia; i += 2) {
        cartasRemover[i] = mao[indices[i]];
        cartasRemover[i + 1] = mao[indices[i + 1]];
    }
    cartasRemover[tamanhoDupSequencia] = L'\0';
    for (int i = 0; i < tamanhoDupSequencia; i += 2) {
        wprintf(L"%lc %lc", mao[indices[i]], mao[indices[i + 1]]);
        if (i != tamanhoDupSequencia - 2) {
            wprintf(L" ");
        }
    }
    wprintf(L"\n");

    eliminaCarta(mao, cartasRemover);
}
void criaduplasequencias(wchar_t mao[], int tamanho, int tamanhoDupSequencia, wchar_t cartaMaisAlta, int *encontradoDupSeq, int indices[14]) {
    
    int i, j;
    for (i = 0; i < tamanhoDupSequencia; i++) {
        indices[i] = i;
    }
    int r = 0;
    while (!r && !(*encontradoDupSeq)) {
        int dupsequenciaValida = 1;
        for (i = 0; i < tamanhoDupSequencia - 3; i += 2) {
            if (!consecutiva(mao[indices[i]], mao[indices[i + 2]]) ||
                extrairvalor(mao[indices[i]]) != extrairvalor(mao[indices[i + 1]]) ||
                extrairvalor(mao[indices[i + 2]]) != extrairvalor(mao[indices[i + 3]])) {
                dupsequenciaValida = 0;
            }
        }
        if (dupsequenciaValida &&
            (extrairvalor(mao[indices[tamanhoDupSequencia - 1]]) > extrairvalor(cartaMaisAlta) ||
            (extrairvalor(mao[indices[tamanhoDupSequencia - 1]]) == extrairvalor(cartaMaisAlta) &&
            extrairnaipe(mao[indices[tamanhoDupSequencia - 1]]) > extrairnaipe(cartaMaisAlta)))) {
            imprimeduplasequencia(mao, indices, tamanhoDupSequencia);
            *encontradoDupSeq = 1; // encontradoDupSeq 1 se uma dupla sequência for encontrada
        }

        i = tamanhoDupSequencia - 1;
        while (i >= 0 && indices[i] == tamanho - (tamanhoDupSequencia - i)) {
            i--;
        }
        if (i < 0) {
            r = 1;
        } else {
            indices[i]++;
            for (j = i + 1; j < tamanhoDupSequencia; j++) {
                indices[j] = indices[j - 1] + 1;
            }
        }
    }
}

//Duplas sequencias para caso K
void criaduplasequenciasK(wchar_t mao[], int tamanho, int tamanhoDupSequencia, int *encontradoDupSeq, int indices[14]) {
    
    int i, j;

    // Inicializa os índices
    for (i = 0; i < tamanhoDupSequencia; i++) {
        indices[i] = i;
    }
    
    // Loop para gerar e imprimir todas as duplas sequências possíveis
    int r = 0;
    while (!r && !(*encontradoDupSeq)) {
        // Verifica se a dupla sequência é válida
        int dupsequenciaValida = 1;
        for (i = 0; i < tamanhoDupSequencia - 3; i += 2) {
            if (!consecutiva(mao[indices[i]], mao[indices[i + 2]]) ||
                extrairvalor(mao[indices[i]]) != extrairvalor(mao[indices[i + 1]]) ||
                extrairvalor(mao[indices[i + 2]]) != extrairvalor(mao[indices[i + 3]])) {
                dupsequenciaValida = 0;
            }
        }

        // Se a dupla sequência for válida, imprime
        if (dupsequenciaValida) {
            imprimeduplasequencia(mao, indices, tamanhoDupSequencia);
            if (encontradoDupSeq != NULL) {
                *encontradoDupSeq = 1; // encontradoDupSeq 1 se uma dupla sequência for encontrada
            }
        }

        // Encontra o próximo índice a ser incrementado
        i = tamanhoDupSequencia - 1;
        while (i >= 0 && indices[i] >= tamanho - (tamanhoDupSequencia - i)) {
            i--;
        }
        if (i < 0) {
            r = 1;
        } else {
            indices[i]++;
            // Atualiza os índices seguintes
            for (j = i + 1; j < tamanhoDupSequencia; j++) {
                indices[j] = indices[j - 1] + 1;
            }
        }
    }
}



void casoK1rei(wchar_t ultimaJogada[], wchar_t mao[], int tamanhoMao, int numReisMao, wchar_t conjuntos_encontrados[][14], int *num_conjuntos, int tamanhoant,  wchar_t conjuntos4[][4],int *num_conjuntos4,int indices[14]){
    int encontradoDupSeq = 0;
        criaduplasequenciasK(mao, tamanhoMao, 6, &encontradoDupSeq, indices);
        if(!encontradoDupSeq){
          criarConjunto4(mao, tamanhoMao, conjuntos4, num_conjuntos4); 
          if(*num_conjuntos4==0){
            if(numReisMao>=1){
                 criaconjuntos(mao, tamanhoMao, ultimaJogada, conjuntos_encontrados, num_conjuntos, tamanhoant);
              if(*num_conjuntos==0){
                wprintf(L"PASSO\n");
              } else {
                imprimir_conjuntos(conjuntos_encontrados,*num_conjuntos,ultimaJogada,tamanhoant,mao);
              }
            }else if (*num_conjuntos==0){
                 wprintf(L"PASSO\n");

            }
          } else {
            imprimir_conjuntos4(conjuntos4, *num_conjuntos4,ultimaJogada,tamanhoant,mao);
          }
        } 
}

//cria combinacoes quando a jogada anterior é k
void casoKconjuntos(wchar_t ultimaJogada[], wchar_t mao[], int tamanhoMao, int numReis, wchar_t conjuntos_encontrados[][14], int *num_conjuntos, int tamanhoant,  wchar_t conjuntos4[][4],int *num_conjuntos4,int indices[14]) {
    int numReisMao= contarCaracter(mao, 0xE);
    if (numReis == 1) {
        casoK1rei(ultimaJogada,mao,tamanhoMao,numReisMao,conjuntos_encontrados,num_conjuntos,tamanhoant,conjuntos4,num_conjuntos4,indices);
    } else if (numReis == 2) {
        if (extrairnaipe(ultimaJogada[1]==3)){
                wprintf(L"PASSO\n");
        }
        int encontradoDupSeq = 0;
        criaduplasequenciasK(mao, tamanhoMao, 8, &encontradoDupSeq, indices);
        if(!encontradoDupSeq){
          if(numReisMao>=2){
                       // wprintf(L"esta a tentar imprimir conjunto\n");
            criaconjuntos(mao, tamanhoMao, ultimaJogada, conjuntos_encontrados, num_conjuntos, tamanhoant); //conjuntos de tamanho = tamanhoant
            if(*num_conjuntos==0){
              wprintf(L"PASSO\n");
            } else{
              imprimir_conjuntos(conjuntos_encontrados, *num_conjuntos,ultimaJogada,tamanhoant,mao);
            }
          }
        }
    }else if (numReis == 3) {
        int encontradoDupSeq = 0;
        criaduplasequenciasK(mao, tamanhoMao, 10, &encontradoDupSeq, indices);

        if (!encontradoDupSeq) {
            wprintf(L"PASSO\n");
        }
    } else if (numReis >= 4) {
     wprintf(L"PASSO\n");
    }
}


//cria quando a jogada anterior nao sao K
void criasemK (wchar_t mao[], int tamanhoMao,wchar_t ultimaJogada[], int tamanhoJogadaAnterior){
    wchar_t conjuntos_encontrados[MAX_CONJUNTOS][14];
    int num_conjuntos = 0;
    int indices[14];
    int encontradoDupSeq=0;
    int encontradoSeq=0;
    if (tipocombinacoes(ultimaJogada) == 1) {
        criaconjuntos(mao, tamanhoMao, ultimaJogada, conjuntos_encontrados, &num_conjuntos, tamanhoJogadaAnterior);
        if (num_conjuntos == 0) {
            wprintf(L"PASSO\n");
        } else {
            imprimir_conjuntos(conjuntos_encontrados, num_conjuntos,ultimaJogada,tamanhoJogadaAnterior,mao);
        }
    } 
    else if (tipocombinacoes(ultimaJogada) == 2){
          criasequencias(mao, tamanhoMao,tamanhoJogadaAnterior,ultimaJogada[tamanhoJogadaAnterior-1],&encontradoSeq,indices);
          if (!encontradoSeq) {
            wprintf(L"PASSO\n");
        }
    }
    else if (tipocombinacoes(ultimaJogada) == 3){
          criaduplasequencias(mao, tamanhoMao,tamanhoJogadaAnterior,ultimaJogada[tamanhoJogadaAnterior-1],&encontradoDupSeq,indices);
          if (!encontradoDupSeq) {
            wprintf(L"PASSO\n");
        }
    } 
}

// cria se houver jogada anterior
void cria(wchar_t mao[],wchar_t ultimaJogada[], int tamanhoJogadaAnterior){
    wchar_t conjuntos_encontrados[MAX_CONJUNTOS][14];
    wchar_t conjuntos4[MAX_CONJUNTOS4][4];
    int num_conjuntos = 0;
    int num_conjuntos4 = 0;
    int indices[14];
    int encontradoDupSeq=0;
    int encontradoSeq=0;
    int numReis = contarCaracter(ultimaJogada, 0xE); //conta quantos reis existem na ultima jogada
    int tamanhoMao= wcslen(mao);
    if (numReis != 0) {
        if(tipocombinacoes(ultimaJogada)==1){ //Caso K
            casoKconjuntos(ultimaJogada, mao,tamanhoMao, numReis, conjuntos_encontrados, &num_conjuntos, tamanhoJogadaAnterior,conjuntos4, &num_conjuntos4, indices);
        }
        else if(tipocombinacoes(ultimaJogada)==2){ //Sequencia
            criasequencias(mao, tamanhoMao,tamanhoJogadaAnterior,ultimaJogada[tamanhoJogadaAnterior-1],&encontradoSeq,indices);
            if (!encontradoSeq) {
            wprintf(L"PASSO\n");
        }
        }
        else if(tipocombinacoes(ultimaJogada)==3){ //Dupla sequencia
            criaduplasequencias(mao, tamanhoMao,tamanhoJogadaAnterior,ultimaJogada[tamanhoJogadaAnterior-1],&encontradoDupSeq,indices);
          if (!encontradoDupSeq) {
            wprintf(L"PASSO\n");
        }
        }
    }
    if (numReis==0){
    criasemK(mao,tamanhoMao,ultimaJogada,tamanhoJogadaAnterior);
    }
}
//parte de sermos os primeiros a jogar
//Contar os passos
int passos(wchar_t jogadaanterior[], wchar_t jogadasant[][20], int numjogant) {
    int passos = 0;
    int r = 0; // Inicializando r com 0

    for (int i = numjogant - 1; i >= 0 && i > numjogant - 4 && passos < 3; i--) {
        if (wcscmp(jogadasant[i], L"PASSO") == 0 && r != 1) {
            passos++;
        } else {
            if (r != 1) {
                wcscpy(jogadaanterior, jogadasant[i]);
                r = 1;
            }
        }
    }
    return passos;
}


void criaconjuntosemjogant(wchar_t mao[], wchar_t conjunto[]) {
  conjunto[0] = mao[0];
    int posicao = 1;
    for (int i = 1; i < 4; i++) {
       if (extrairvalor(mao[i]) == extrairvalor(conjunto[0]) && (extrairnaipe(mao[i]) != extrairnaipe(conjunto[0]))) {
            conjunto[posicao] = mao[i];
            posicao++;
       }
    }
}

void imprimirconjunto(wchar_t conjunto[],wchar_t mao[]) {
    for (int i = 0; i < 4; i++) {
        wprintf(L"%lc", conjunto[i]);
         if (i != 3) {
                wprintf(L" "); 
            }
    }
    wprintf(L"\n");
  eliminaCarta(mao,conjunto);

}
//Sequencias
void imprimesequenciasemjogant(wchar_t mao[], int sequencia[], int tamanhoSequencia) {
    for (int i = 0; i < tamanhoSequencia; i++) {
        wprintf(L"%lc", sequencia[i]);
        if (i != tamanhoSequencia - 1) {
            wprintf(L" ");
        }
    }
    wprintf(L"\n");
    eliminaCarta(mao,sequencia);
}


int formamSequenciasemjogant(wchar_t mao[], int tamanho, wchar_t sequencia[]) {
    if (tamanho < 3) {
        return 0;
    }

    sequencia[0] = mao[0];
    int tamanhoSequencia = 1;
    int r = 0; 

    for (int i = 0; i < tamanho - 1; i++) {
        if (consecutiva(mao[i], mao[i + 1]) && r ==0) {
            sequencia[tamanhoSequencia] = mao[i + 1];
            tamanhoSequencia++;
        } else if (extrairvalor(mao[i])==extrairvalor(mao[i+1])){
          r=0;
        }else{
return 0;
        }
    }
    if (tamanhoSequencia >= 3) {
     // wprintf(L"é sequencia\n");
        imprimesequenciasemjogant(mao, sequencia, tamanhoSequencia);
        return 1;
    }
    return 0;
}
void imprimeduplasequenciasemjogant(wchar_t mao[], int indices[], int tamanhoDupSequencia, int *imprimiu) {
    wchar_t cartasRemover[tamanhoDupSequencia + 1];
    for (int i = 0; i < tamanhoDupSequencia; i++) {
        cartasRemover[i] = mao[indices[i]];
    }
    cartasRemover[tamanhoDupSequencia] = L'\0';
    
    if (cartasRemover[0] == mao[0]) {
        for (int i = 0; i < tamanhoDupSequencia; i += 2) {
            wprintf(L"%lc %lc", mao[indices[i]], mao[indices[i + 1]]);
            if (i != tamanhoDupSequencia - 2) {
                wprintf(L" ");
            }
        }
        wprintf(L"\n");
        *imprimiu = 1;
        eliminaCarta(mao, cartasRemover);
    }
}

void criaduplasequenciassemjogant(wchar_t mao[], int tamanho, int tamanhoDupSequencia, int *encontradoDupSeq, int indices[14]) {
    int i, j;
    int imprimiu = 0;

    // Inicializa os índices
    for (i = 0; i < tamanhoDupSequencia; i++) {
        indices[i] = i;
    }
    
    // Loop para gerar e imprimir todas as duplas sequências possíveis
    int r = 0;
    while (!r && !(*encontradoDupSeq)) {
        // Verifica se a dupla sequência é válida
        int dupsequenciaValida = 1;
        for (i = 0; i < tamanhoDupSequencia - 3; i += 2) {
            if (!consecutiva(mao[indices[i]], mao[indices[i + 2]]) ||
                extrairvalor(mao[indices[i]]) != extrairvalor(mao[indices[i + 1]]) ||
                extrairvalor(mao[indices[i + 2]]) != extrairvalor(mao[indices[i + 3]])) {
                dupsequenciaValida = 0;
            }
        }

        // Se a dupla sequência for válida, imprime
        if (dupsequenciaValida) {
            imprimeduplasequenciasemjogant(mao, indices, tamanhoDupSequencia, &imprimiu);
            if (!imprimiu) {
                *encontradoDupSeq = 0;
                return;
            }
            *encontradoDupSeq = 1;
        }

        // Encontra o próximo índice a ser incrementado
        i = tamanhoDupSequencia - 1;
        while (i >= 0 && indices[i] >= tamanho - (tamanhoDupSequencia - i)) {
            i--;
        }
        if (i < 0) {
            r = 1;
        } else {
            indices[i]++;
            // Atualiza os índices seguintes
            for (j = i + 1; j < tamanhoDupSequencia; j++) {
                indices[j] = indices[j - 1] + 1;
            }
        }
    }
}

void primeirajogada(wchar_t mao[]) {
    int tamanhoanterior = wcslen(mao);
    wchar_t conjunto[5] = L""; 
    wchar_t sequencia[14] = L"";
    int indices[14];
    int encontradoDupSeq=0;
    for(int tamanho=14; tamanho >= 6 && !encontradoDupSeq; tamanho-=2){
                criaduplasequenciassemjogant(mao, tamanhoanterior, tamanho, &encontradoDupSeq, indices);

    }
     if (!encontradoDupSeq) {
     if (formamSequenciasemjogant(mao, tamanhoanterior, sequencia) == 0) {
        criaconjuntosemjogant(mao, conjunto);
        imprimirconjunto(conjunto,mao);
    }
     }
}


int main() {
    setlocale(LC_ALL, "C.UTF-8");
    int numjogant;
    wscanf(L"%d", &numjogant);
    wchar_t mao[20]; 
    wscanf(L"%ls", mao); 
    wchar_t jogadasant[numjogant][20]; 
    for (int i = 0; i < numjogant; i++) {
        wscanf(L"%ls", jogadasant[i]); 
    }
    wchar_t ultimaJogadaAnterior[15];
    if (numjogant > 0) {
        wcscpy(ultimaJogadaAnterior, jogadasant[numjogant - 1]);
    }
    organizar(mao, wcslen(mao)); 
    organizar(ultimaJogadaAnterior,wcslen(ultimaJogadaAnterior));
  //  wprintf(L"ultima jogada antes do passo:%ls\n", ultimaJogadaAnterior);
    int passosRealizados = passos(ultimaJogadaAnterior, jogadasant, numjogant);
    if (passosRealizados >= 3 || numjogant == 0) {
        primeirajogada(mao); 
    } else {
            //wprintf(L"Ultima jogada: %ls\n", ultimaJogadaAnterior);
if (wcslen(mao)<wcslen(ultimaJogadaAnterior)){
    wprintf(L"PASSO");
}
        else{
            cria(mao, ultimaJogadaAnterior, wcslen(ultimaJogadaAnterior)); 
    }}
    return 0;
}
