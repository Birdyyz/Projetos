import Musica.*;
import Playlist.*;
import Utilizador.*;

import java.time.LocalDate;
import java.util.*;
import java.util.List;

public class View {
    Scanner s = new Scanner(System.in);

    private List<String> opcoes;
    private int opcao;
    private Utilizador user;
    private Controller controller;
    private int contadoraleatoria;
    private int contadorexplicita;
    private int contadorsemrestricao;
    private int contadorlistafavoritos;

    //ver dps ta igual ao do stor
    public View() {
        this.opcao = 0;
        this.opcoes = new ArrayList<>();
        this.user = null;
        this.contadoraleatoria = 0;
        this.contadorexplicita = 0;
        this.contadorsemrestricao = 0;
        this.contadorlistafavoritos = 0;
    }

    public int getContadoraleatoria() {
        return contadoraleatoria;
    }
    public int getContadorexplicita() {
        return contadorexplicita;
    }
    public int getContadorsemrestricao() {
        return contadorsemrestricao;
    }
    public int getContadorlistafavoritos(){
        return contadorlistafavoritos;
    }

    public void setController(Controller controller) {
        this.controller = controller;
    }
    public void setContadoraleatoria(int contadoraleatoria) {
        this.contadoraleatoria = contadoraleatoria;
    }
    public void setContadorsemrestricao(int contadorsemrestricao) {
        this.contadorsemrestricao = contadorsemrestricao;
    }
    public void setContadorlistafavoritos(int contadorlistafavoritos) {
        this.contadorlistafavoritos = contadorlistafavoritos;
    }



    public int lerOpcao() {
        int op;
        Scanner s = new Scanner(System.in);
        System.out.print("Opção: \n");
        try {
            String line = s.nextLine();
            op = Integer.parseInt(line);
        } catch (NumberFormatException e) {
            op = -1;
        }
        if (op<0) {
            System.out.println("Opção Inválida!\n");
            op = -1;
        }
        return op;
    }




    public void Mostrarinicio(){
        do {
            System.out.println("Bem-vindo ao SpotifUM!\n");
            MostrarMenuLoginOuRegisto();
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 1 -> {
                    iniciarSessaoInput();
                }
                case 0 -> {
                    System.out.println("A sair do SPOTIFUM...\n");
                    controller.guardaEstado();
                    System.out.println("Estado guardado com sucesso!\n");
                }
                case 2 ->{
                    registarContaInput();
                }
                default -> System.out.println("Opção inválida.\n");
            }
        }
        while (this.opcao != 0);
    }

    // menu concluido
    public void MostrarMenuLoginOuRegisto() {
        this.opcoes = Arrays.asList("Sair", "Iniciar sessão", "Registar conta");
        System.out.println("""
         ========= Menu Inicial  =========
        (0) Sair
        (1) Iniciar sessão
        (2) Registar conta
        """);
    }

    public void registarContaInput(){
        Scanner s = new Scanner(System.in);
        System.out.println("Insira o seu nome:");
        String nome = s.nextLine();
        while(nome.isEmpty()){
            System.out.println("Insira o seu nome:");
            nome = s.nextLine();
        }
        System.out.print("Insira o seu email:\n");
        String email = s.nextLine();
        while(email.isEmpty()){
            System.out.print("Insira o seu email:\n");
            email = s.nextLine();
        }
        System.out.println("Insira a sua morada:");
        String morada = s.nextLine();
        while(morada.isEmpty()){
            System.out.println("Insira a sua morada:");
            morada = s.nextLine();
        }

        Utilizador novo = new Utilizador(nome, email, morada, new PlanoFree(), 0, new Biblioteca());

        if(controller.registarUtilizador(novo)){
            System.out.println("Conta criada com sucesso!\n");
            this.user = novo;
            MostrarMenuUtilizador();
        }
        else{
            System.out.println("!!Conta com este email já existe!!\n");
        }

    }

    public void iniciarSessaoInput() {
        Scanner s = new Scanner(System.in);
        System.out.println("Insira o seu nome:");
        String nome = s.nextLine();
        while(nome.isEmpty()){
            System.out.println("Insira o seu nome:");
            nome = s.nextLine();
        }
        System.out.print("Insira o seu email:\n");
        String email = s.nextLine();
        while(email.isEmpty()){
            System.out.print("Insira o seu email:\n");
            email = s.nextLine();
        }
        // Procurar utilizador com esse email
        Utilizador encontrado = null;
        for (Utilizador u : controller.getUtilizadores()) {
            if (u.getEmail().equalsIgnoreCase(email) && u.getNome().equalsIgnoreCase(nome)) {
                encontrado = u;
                break;
            }
        }

        if (encontrado != null) {
            System.out.println("Login bem-sucedido.\nBem-vindo de volta, " + encontrado.getNome() + "! \n" );
            this.user = encontrado;
            MostrarMenuUtilizador();
        } else {
            // Novo registo
            System.out.print("Utilizador não encontrado.\nInsira a sua morada para criar conta:\n");
            String morada = s.nextLine();

            Utilizador novo = new Utilizador(nome, email, morada, new PlanoFree(), 0, new Biblioteca());

            if (controller.registarUtilizador(novo)) {
                System.out.println("Conta criada com sucesso!\n");
                this.user = novo;
                MostrarMenuUtilizador();
            } else {
                System.out.println("Erro ao criar conta. Email já existente.\n");
            }
        }
    }



    public void MostrarMenuUtilizador() {
        do {
            if (user.getPlano() instanceof PlanoFree) {
                MenuFree();
            } else {
                MenuPremium();
            }
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> {
                    System.out.println("A terminar sessão...\n");
                    return;
                }
                case 1 -> MostrarDadosUtilizador(); // mostrar dados do utilizador
                case 2 -> MostrarEstatisticas();
                case 3 -> MostrarMenuPlanoDeSubscricao(); //  alterar plano
                case 4 -> CriaPlaylistAleatoria();
                case 5 -> {
                    if (!(user.getPlano() instanceof PlanoFree)) {
                        MostrarMenuBiblioteca();         // só se for premium
                    } else {
                        System.out.println("Evolua para o plano Premium para ter acesso a esta funcionalidade\n");
                    }
                }
                default -> System.out.println("Opção inválida\n");
            }
        } while (this.opcao != 0);
    }

    public void CriaPlaylistAleatoria(){
        Playlist p = controller.criaplaylistaleatoria(user, "Playlist Aleatória " + this.getContadoraleatoria());
        if(p == null){
            System.out.println("Erro ao criar playlist.\n");
        }
        else{
            System.out.println("Playlist Aleatória " + this.getContadoraleatoria() + " criada com sucesso!\n");
            controller.adicionarPlaylistBiblioteca(user , p);
            setContadoraleatoria(this.getContadoraleatoria() + 1);
            MostrarMenuUtilizador();
        }
    }

    // quando cria conta tem acesso ao menu free
    public void MenuFree(){
        System.out.println("""
        ========= MENU FREE =========
        (0) Sair
        (1) Dados do Utilizador
        (2) Estatísticas
        (3) Plano de Subscrição
        (4) Criar Playlist Aleatória
        =============================
        """);
    }

    // o base e premium têm o menu igual mas altera dentro das opcoes
    public void MenuPremium(){
        System.out.println("""
                ========= MENU PREMIUM =========
                (0) Sair
                (1) Dados do Utilizador
                (2) Estatísticas
                (3) Plano de Subscrição
                (4) Criar Playlist Aleatória
                (5) Biblioteca
                ================================
                """);
    }



    public void MostrarDadosUtilizador(){
        System.out.println("Dados do Utilizador:\n");
        System.out.println(controller.listarDadosUtilizador(user));
        MostrarMenuUtilizador();
    }

    public void MostrarMenuPlanoDeSubscricao(){
        do {
            MenuPlanoDeSubscricao();
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> {
                    controller.atualizaPlano(user, new PlanoFree());
                    break;
                }
                case 1 -> {
                    controller.atualizaPlano(user, new PlanoPremiumBase());
                    break;
                }
                case 2 -> {
                    controller.atualizaPlano(user, new PlanoPremiumTop());
                    break;
                }
                default -> {
                    System.out.println("Opção inválida\n");
                    continue;
                }
            }
            break;
        } while (true);
        MostrarMenuUtilizador();
    }

    public void MenuPlanoDeSubscricao(){
        System.out.println("""
                ========= Alterar Plano de Subscrição=========
                (0) Free
                (1) Premium Base
                (2) Premium Top
                ==============================================
                """);
    }

    public void MenuBiblioteca(){
        System.out.println("""
                ========= BIBLIOTECA =========
                (0) Voltar
                (1) Albuns
                (2) Playlists
                (3) Músicas
                ==============================
                """);
    }

    public void MostrarMenuBiblioteca(){
        MenuBiblioteca();
        do {
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> MostrarMenuUtilizador();
                case 1 -> MostrarMenuAlbuns();
                case 2 -> MostrarMenuPlaylist();
                case 3 -> MenuMusicas();
                default -> System.out.println("Opção inválida");
            }
        } while (this.opcao != 0);
    }

    // lê uma string no formato 'nome - interprete' e retorna um array com [nome, interprete]
    public String[] lerNomeEInterprete() {
        while(true) {
            String entrada = s.nextLine();
            String[] partes = entrada.split(" - ");
            if (partes.length == 2) {
                return new String[]{partes[0].trim(), partes[1].trim()};
            }
            else {
                System.out.println("Formato inválido. Use 'nome - interprete'.");
            }
        }
    }

    public void MenuAlbuns(){
        String imprimir = controller.listarAlbumBiblioteca(user);
        if(imprimir.isEmpty()){
            imprimir = "Ainda não tem nenhum álbum na biblioteca";
        }
        System.out.println("""
                ========= ALBUNS =========
                (0) Voltar
                (1) Reproduzir
                (2) Adicionar álbum
                (3) Remover álbum
                ==========================
                Albuns: (nome - interprete - número de músicas)\n""" + imprimir
        );
    }

    public void MostrarMenuAlbuns(){
        do {
            MenuAlbuns();
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> MostrarMenuBiblioteca(); // Voltar
                case 1 -> { // Reproduzir
                    System.out.println("Álbuns disponíveis:");
                    String imprimir = controller.listarAlbumBiblioteca(user);
                    if(imprimir.isEmpty()){
                        imprimir = "Ainda não tem nenhum álbum na biblioteca";
                        System.out.println(imprimir);
                        MostrarMenuAlbuns();
                        return;
                    }
                    System.out.println(imprimir);
                    System.out.println("Insira o nome - interprete do álbum que deseja reproduzir:");
                    String[] nomeInterprete = lerNomeEInterprete();
                    String nomeAlbum = nomeInterprete[0];
                    String interprete = nomeInterprete[1];
                    Album temp = controller.procurarAlbumBiblioteca(user, nomeAlbum, interprete);
                    if(temp != null){
                        controller.reproduzirAlbum(user, temp);
                    }
                    else{
                        System.out.println("O álbum não existe. Tente novamente.");
                    }
                }
                case 2 -> { // Adicionar álbum
                    System.out.println("Álbuns disponíveis:");
                    System.out.println(controller.listarAlbuns()); // lista todos os albuns do sistema
                    System.out.println("Insira o nome - interprete do álbum que deseja adicionar:");
                    String[] nomeInterprete = lerNomeEInterprete();
                    String nomeAlbum = nomeInterprete[0];
                    String interprete = nomeInterprete[1];
                    Album temp = controller.procurarAlbum(controller.getAlbuns(), nomeAlbum, interprete);
                    if (temp!=null){
                        boolean sucesso = controller.adicionarAlbumBiblioteca(user, temp);
                        if (sucesso) {
                            System.out.println("Álbum adicionado com sucesso!");
                        } else {
                            System.out.println("O álbum já está na sua biblioteca.");
                        }

                    }
                    else{
                        System.out.println("O álbum não existe. Tente novamente.");
                    }
                }
                case 3 -> {
                    System.out.println("Álbuns existentes na sua biblioteca:");
                    String imprimir = controller.listarAlbumBiblioteca(user);
                    if(imprimir.isEmpty()){
                        System.out.println("Adicione álbuns à biblioteca para poder remover.");
                        MostrarMenuAlbuns();
                        return;
                    }else {
                        System.out.println(imprimir);
                        System.out.println("Insira o nome - interprete do álbum que deseja remover:");
                        String[] nomeInterprete = lerNomeEInterprete();
                        String nomeAlbum = nomeInterprete[0];
                        String interprete = nomeInterprete[1];
                        Album temp = controller.procurarAlbumBiblioteca(user, nomeAlbum, interprete);
                        if (temp != null) {
                            controller.removerAlbumBiblioteca(user, temp.getNome());
                            System.out.println("Álbum removido com sucesso!");
                        } else {
                            System.out.println("O álbum não existe. Tente novamente.");
                        }
                    }
                }
                default -> System.out.println("Opção inválida");
            }
        } while (this.opcao != 0);
    }

    public void MenuPlaylists(){
        String imprimir = controller.listarPlaylistBiblioteca(user);
        if (imprimir.isEmpty()) {
            imprimir = "Ainda não tem nenhuma playlist na biblioteca";
        }
        System.out.println("""
                ========== PLAYLISTS ==========
                (0) Voltar
                (1) Reproduzir
                (2) Criar playlist
                (3) Tornar playlist pública
                (4) Adicionar playlist pública
                (5) Remover playlist
                ===============================
                Playlists:\n """ + imprimir); // assim se o utilizador n tiver playlists aparece a dizer q ele n tem
    }

    public void MostrarMenuPlaylist(){
        do{
            MenuPlaylists();
            this.opcao = lerOpcao();
            switch(this.opcao){
                case 0 -> MostrarMenuBiblioteca(); // Voltar
                case 1 -> { // Reproduzir
                    System.out.println("Playlists disponíveis:");
                    String imprimir = controller.listarPlaylistBiblioteca(user);
                    if (imprimir.isEmpty()) {
                        System.out.println("Ainda não tem nenhuma playlist na biblioteca");
                        MostrarMenuPlaylist();
                        return;
                    }
                    System.out.println(imprimir);
                    System.out.println("Insira o nome da playlist que deseja reproduzir:");
                    Scanner s = new Scanner(System.in);
                    String nome = s.nextLine();
                    Playlist temp = controller.procurarPlaylistBiblioteca(user, nome);
                    if(temp!=null) {
                        if (temp instanceof PlaylistPremium) {
                            System.out.println("""
                            Gostaria de colocar a playlist em ordem aleatória?
                            (0) Não
                            (1) Sim""");
                            int escolha0 = s.nextInt();
                            s.nextLine();
                            boolean aleatorio = (escolha0 == 1);

                            System.out.println("""
                            (0) Deseja reproduzir a playlist na ordem normal
                            (1) Navegar com avanços e recuos""");
                            int escolha = s.nextInt();
                            s.nextLine();
                            boolean manualmente = (escolha == 1);

                            if (aleatorio && !manualmente) {
                                controller.ImprimirPremiumAleatoria(temp);
                            } else if (manualmente && !aleatorio) {
                                ReproduzirMusicaManualmente(temp);
                            } else if (manualmente && aleatorio) {
                                Playlist musica = controller.TornarAleatoria(temp);
                                ReproduzirMusicaManualmente(musica);
                            } else if (!aleatorio && !manualmente) {
                                controller.reproduzirPlaylist(user, temp, false);
                            }

                        } else if (temp instanceof PlaylistGeneroMusical) {
                            System.out.println("""
                            (0) Deseja reproduzir a playlist na ordem normal
                            (1) Navegar com avanços e recuos""");
                            int escolha = s.nextInt();
                            s.nextLine();
                            boolean manualmente = (escolha == 1);

                            if (manualmente) {
                                ReproduzirMusicaManualmente(temp);
                            } else {
                                controller.reproduzirPlaylist(user, temp, false);
                            }

                        } else {
                            controller.reproduzirPlaylist(user, temp, false);
                        }


                    }
                    else{
                        System.out.println("A playlist não está na sua biblioteca. Tente novamente.");
                    }
                }
                case 2 -> MostrarMenuCriarPlaylistPremium(); // Criar playlist
                case 3 -> TornarPlaylistPublica(); // Tornar playlist publica
                case 4 -> {  // Adicionar playlist publica
                    System.out.println("Playlists disponíveis:");
                    System.out.println(controller.listarPlaylists()); // lista todas as playlists do sistema
                    System.out.println("Insira o nome da playlist pública que deseja adicionar à sua biblioteca:");
                    Scanner s = new Scanner(System.in);
                    String nome = s.nextLine();
                    Playlist temp = controller.procurarPlaylist(controller.getPlaylists(), nome);
                    if (temp!=null) {
                        boolean sucesso = controller.adicionarPlaylistBiblioteca(user, temp);
                        if (sucesso) {
                            System.out.println("Playlist adicionada com sucesso!");
                        } else {
                            System.out.println("A playlist já existe na sua biblioteca.");
                        }
                    }
                    else{
                        System.out.println("A playlist não existe. Tente novamente.");
                    }
                }
                case 5 -> { // Remover playlist
                    System.out.println("Playlists existentes na sua biblioteca:");
                    String imprimir = controller.listarPlaylistBiblioteca(user);
                    if (imprimir.isEmpty()) {
                        System.out.println("Adicione playlists à sua biblioteca para poder remover.");
                        MostrarMenuPlaylist();
                        return;
                    }else {
                        System.out.println(imprimir);
                        System.out.println("Insira o nome da Playlist que deseja remover:");
                        Scanner s = new Scanner(System.in);
                        String nome = s.nextLine();
                        Playlist temp = controller.procurarPlaylistBiblioteca(user, nome);
                        if (temp != null) {
                            controller.removerPlaylistBiblioteca(user, nome);
                            System.out.println("Playlist removido com sucesso!");
                        } else {
                            System.out.println("A playlist não existe. Tente novamente.");
                        }
                    }
                }
                default -> System.out.println("Opção inválida");
            }
        } while(this.opcao != 0);
    }

    public void MenuCriarPlaylistsPremium(){
        System.out.println("""
                ========= CRIAR PLAYLISTS =========
                (0) Voltar
                (1) Playlist normal
                (2) Playlist Lista de Favoritos
                (3) Playlist Género musical
                =================================
                """);
    }

    public void MostrarMenuCriarPlaylistPremium(){
        do{
            MenuCriarPlaylistsPremium();
            this.opcao = lerOpcao();
            switch(this.opcao){
                case 0 -> {
                    MostrarMenuPlaylist();
                    return;
                }
                case 1 -> CriarPlaylistPremium();
                case 2 -> {
                    if(user.getPlano() instanceof PlanoPremiumTop){
                        MostrarMenuFavoritos();
                    }
                    else{
                        System.out.println("Evolua para o plano Premium Top para ter acesso a esta funcionalidade.");
                    }
                }
                case 3 -> CriarPlaylistGeneroMusical();
                default -> System.out.println("Opção inválida");
            }
        }while(this.opcao!=0);
    }
    public void MenuFavoritos(){
        System.out.println("""
                ============= CRIAR PLAYLISTS FAVORITOS =============
                (0) Voltar
                (1) Playlist Lista De Favoritos
                (2) Playlist Lista De Favoritos Com Música Explícita
                (3) Playlist Lista De Favoritos Sem Restrição
                =====================================================
                """);
    }
    public void MostrarMenuFavoritos(){
        do {
            MenuFavoritos();
            this.opcao = lerOpcao();
            switch(this.opcao){
                case 0 -> {
                    MostrarMenuCriarPlaylistPremium();
                    return;
                }
                case 1 -> CriarPlaylistListaFavoritos();
                case 2 -> CriarPlaylistFavExplicita();
                case 3 -> CriarPlaylistFavoritosSemRestricoes();
                default -> System.out.println("Opção inválida");
            }
        } while(this.opcao != 0);
    }
    // esta corrigida
    public void CriarPlaylistFavExplicita(){
        boolean manualmente = false;
        System.out.println("""
            (0) Deseja reproduzir a playlist na ordem normal
            (1) Navegar com avanços e recuos""");
        int escolha2 = s.nextInt();
        manualmente = (escolha2 == 1);
        Playlist aux = controller.criaplaylistmusicaexplicita(user, "Playlist com Música Explícita "+ getContadoraleatoria(),false, controller.getMusicas(),manualmente);
        boolean vazia = controller.PlaylistVazia(aux);
        //System.out.println("Tamanho da playlist: " + tamanho);
        if (vazia) {
            System.out.println("Erro ao criar playlist. Tente ouvir músicas ou álbuns primeiro.");
            MenuFavoritos();
        } else {
            setContadoraleatoria(getContadorexplicita() + 1);
            controller.adicionarPlaylistBiblioteca(user, aux);
            System.out.println("Playlist criada com sucesso!");
            // reproduzir com avancos e recuos
            if(manualmente) {
                ReproduzirMusicaManualmente(aux);
            }
        }
    }

    public void ReproduzirMusicaManualmente(Playlist aux) {
        int posicaoatual = 0;
        int opcao;
        controller.reproduzirPlaylistManualmente(user, aux, posicaoatual);
        Scanner s = new Scanner(System.in);
        int tamanho = controller.tamanhoPlaylist(aux);
        if(tamanho == 1) {
            System.out.println("A playlist só tem uma música");
            MostrarMenuCriarPlaylistPremium();
            return;
        }
        do {
            System.out.println("""
            (0) Recuar
            (1) Avançar
            (3) Parar de reproduzir""");

            opcao = lerOpcao();

            switch (opcao) {
                case 0 -> {
                    System.out.println("Quantas músicas quer recuar?");
                    int recuar = s.nextInt();
                    posicaoatual -= recuar;
                    s.nextLine();
                    if (posicaoatual < 0) {
                        System.out.println("Acessou um índice negativo. A reproduzir a primeira música da playlist.");
                        posicaoatual = 0;
                    }
                    controller.reproduzirPlaylistManualmente(user, aux, posicaoatual);
                }

                case 1 -> {
                    System.out.println("Quantas músicas quer avançar?");
                    int avancar = s.nextInt();
                    s.nextLine();
                    posicaoatual += avancar;

                    if (posicaoatual >= tamanho) {
                        System.out.println("Ultrapassou o tamanho da playlist. A reproduzir a última música da playlist.");
                        posicaoatual = tamanho - 1;
                    }
                    controller.reproduzirPlaylistManualmente(user, aux, posicaoatual);
                }

                case 3 -> {
                    System.out.println("Parando reprodução.");
                    MostrarMenuPlaylist();
                    return;
                }

                default -> System.out.println("Opção inválida. Tente novamente.");
            }

        } while (opcao != 3);
    }

    // esta corrigida
    public void CriarPlaylistFavoritosSemRestricoes(){
        boolean manualmente = false;
        System.out.println("""
        (0) Deseja reproduzir a playlist na ordem normal
        (1) Navegar com avanços e recuos""");
        int escolha2 = s.nextInt();
        manualmente = (escolha2 == 1);
        Playlist aux = controller.criaPlaylistfavsemrestricoes(user, "Playlist favoritos sem restrições "+
                getContadorsemrestricao() ,false, controller.getMusicas(),manualmente);
        int tamanho = controller.tamanhoPlaylist(aux);
        boolean vazia = controller.PlaylistVazia(aux);
        if (vazia) {
            System.out.println("Erro ao criar playlist. Tente ouvir músicas ou álbuns primeiro.");
        }else {
            controller.adicionarPlaylistBiblioteca(user, aux);
            setContadorsemrestricao(getContadorsemrestricao() + 1);
            System.out.println("Playlist criada com sucesso!");
            if (manualmente) {
                ReproduzirMusicaManualmente(aux);
            }
            else{
                MostrarMenuFavoritos();
            }
        }
    }

    // verifica se o nome proposto pelo utilizador é válido
    public String pedirNomePlaylistValido(Utilizador u, List<Playlist> playlistsPublicas) {
        String nome;
        do {
            System.out.print("Insira o nome da playlist: ");
            nome = s.nextLine();

            if (!controller.nomePlaylistValido(nome, u, playlistsPublicas)) {
                System.out.println("Já existe uma playlist com esse nome. Tente outro.");
            } else {
                break;
            }
        } while (true);

        return nome;
    }

    public void CriarPlaylistPremium() {
        Scanner s = new Scanner(System.in);

        String nome = pedirNomePlaylistValido(user, controller.getPlaylists());

        System.out.println("Quantas músicas quer adicionar:");
        int quantidade = s.nextInt();
        s.nextLine();
        System.out.println("Músicas disponíveis:\n");
        System.out.println(controller.listarMusicas());
        List<Musica> musicasEscolhidas = new ArrayList<>();

        for (int m = 0; m < quantidade; m++) {
            System.out.println("Insira o nome - interprete que deseja adicionar:");
            String[] nomeInterprete = lerNomeEInterprete();
            String nomeMusica = nomeInterprete[0];
            String interprete = nomeInterprete[1];
            Musica temp = controller.procurarMusica(controller.getMusicas(), nomeMusica, interprete);

            if (temp != null) {
                musicasEscolhidas.add(temp);
                System.out.println("Música adicionada!");
            } else {
                System.out.println("Música não encontrada. Tente novamente.");
                m--;
            }
        }
        System.out.println("""
            Gostaria de colocar a playlist em ordem aleatória?
            (0) Não
            (1) Sim""");
        int escolha0=s.nextInt();
        s.nextLine();
        boolean aleatorio = (escolha0==1);
        System.out.println("""
            (0) Deseja reproduzir a playlist na ordem normal
            (1) Navegar com avanços e recuos""");
        int escolha = s.nextInt();
        s.nextLine();
        boolean manualmente = (escolha == 1);
        // nao esta a imprimir quando n e manualmente
        Playlist aux = controller.criaPlayPremium(user,nome,musicasEscolhidas,aleatorio,manualmente);
        boolean vazia = controller.PlaylistVazia(aux);

        if (!vazia) {
            controller.adicionarPlaylistBiblioteca(user, aux);
            System.out.println("Playlist criada com sucesso!");
            if (manualmente) {
                ReproduzirMusicaManualmente(aux);
            }
        } else {
            System.out.println("Erro ao criar playlist.");
        }

        MostrarMenuPlaylist();
    }

    public void TornarPlaylistPublica(){
        controller.listarPlaylistsPrivadas(user);
        System.out.println("Insira o nome da playlist que quer tornar pública:");
        String nome = s.nextLine();
        Playlist p = controller.procurarPlaylistBiblioteca(user, nome);
        if(controller.tornarPublica(user,p)){
            System.out.println("A playlist foi alterada para pública");
        }
        else{
            System.out.println("Erro ao alterar a playlist.");
        }
        MostrarMenuPlaylist();
    }

    public void MenuMusicas(){
        List<Musica> musicas = controller.getMusicas();
        String imprimir = controller.listarMusicaBiblioteca(user);
        boolean vazio = false;
        if(imprimir.isEmpty()){
            imprimir = "Ainda não tem nenhuma música na biblioteca";
            vazio = true;
        }
        System.out.println("""
                =========== MÚSICAS ===========
                (0) Voltar
                (1) Reproduzir
                (2) Adicionar Músicas
                ===============================
                Músicas: (nome - intérprete - duração)\n""" + imprimir
        );
        do{
            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> MostrarMenuBiblioteca();
                case 1 -> {
                    if(vazio){
                        System.out.println("Adicione músicas à sua biblioteca para reproduzir.");
                        MenuMusicas();
                        return;
                    }else {
                        System.out.println("Insira o nome - interprete que deseja reproduzir:");
                        String[] nomeInterprete = lerNomeEInterprete();
                        String nomeMusica = nomeInterprete[0];
                        String interprete = nomeInterprete[1];
                        Musica temp = controller.procurarMusicaBiblioteca(user, nomeMusica, interprete);
                        controller.reproduzirMusica(user, temp);
                        MenuMusicas();
                        return;
                    }
                }
                case 2 -> {
                    System.out.println("Músicas disponíveis:\n");
                    System.out.println(controller.listarMusicas());
                    System.out.println("Insira o nome - interprete que deseja adicionar:");
                    String[] nomeInterprete = lerNomeEInterprete();
                    String nomeMusica = nomeInterprete[0];
                    String interprete = nomeInterprete[1];
                    Musica temp = controller.procurarMusica(musicas, nomeMusica, interprete);

                    if (temp == null) {
                        System.out.println("Música não encontrada. Tente novamente.");
                    }

                    else {
                        controller.adicionarMusicaBiblioteca(user, temp);
                    }
                    MenuMusicas();
                }
                default -> System.out.println("Opção inválida");
            }
        } while (this.opcao != 0);
    }

    public void CriarPlaylistGeneroMusical() {
        Scanner s = new Scanner(System.in);
        System.out.println("Género musical:");
        String genero = s.nextLine();
        boolean generoExiste = controller.GeneroExiste(genero);
        if (!generoExiste) {
            System.out.println("Nenhuma música encontrada com esse género. Tente outro género musical.");
            MostrarMenuFavoritos();
            return;
        }
        // passa para segundos dentro da playlist genero musical
        System.out.println("Duração da playlist (em minutos):");
        int duracao = s.nextInt();
        boolean manualmente = false;
        System.out.println("""
        (0) Deseja reproduzir a playlist na ordem normal
        (1) Navegar com avanços e recuos""");
        int escolha2 = s.nextInt();
        manualmente = (escolha2 == 1);
        Playlist aux = controller.criaplaylistgeneromusical(
                user,
                "Playlist " + genero,
                genero,
                duracao,
                false,
                controller.getMusicas(),
                manualmente
        );
        int duracaoPlaylist = controller.tamanhoPlaylist(aux);
        //System.out.println(duracaoPlaylist);
        if (duracaoPlaylist < duracao -10) {
            System.out.println("SpotifUM não tem músicas suficientes para a duração que pediu, reduza a duração da playlist");
            MostrarMenuCriarPlaylistPremium();
            return;
        }
        boolean vazia = controller.PlaylistVazia(aux);
        if(!vazia) {
            controller.adicionarPlaylistBiblioteca(user, aux);
            System.out.println("Playlist criada com sucesso!");
            if(manualmente) {
                ReproduzirMusicaManualmente(aux);
            }else{
                MostrarMenuCriarPlaylistPremium();
            }
        }
        else{
            System.out.println("Erro ao criar playlist.");
            MostrarMenuCriarPlaylistPremium();
        }
    }

    // é só para premium
    // corrigida
    public void CriarPlaylistListaFavoritos(){
        Scanner s = new Scanner(System.in);
        // passa para segundos dentro da playlist favoritos
        System.out.println("Duração da playlist(em minutos):");
        int duracao = s.nextInt();
        boolean manualmente = false;
        System.out.println("""
        (0) Deseja reproduzir a playlist na ordem normal
        (1) Navegar com avanços e recuos""");

        int escolha2 = s.nextInt();
        manualmente = (escolha2 == 1);
        Playlist aux = controller.criaplaylistfav(user,
                "Playlist favoritos " + this.getContadorlistafavoritos()
                ,duracao,
                false, controller.getMusicas(),manualmente);
        int duracaoPlaylist = controller.tamanhoPlaylist(aux);
        //System.out.println(duracaoPlaylist);
        if (duracaoPlaylist < duracao -10) {
            System.out.println("Altere a duração da playlist ou escute mais músicas para criar playlist.");
            MostrarMenuCriarPlaylistPremium();
            return;
        }
        boolean vazia = controller.PlaylistVazia(aux);
        if (vazia) {
            System.out.println("Ouça mais músicas ou reduza a duração da playlist para criar a playlist favoritos. Tente novamente.");
            MostrarMenuFavoritos();
        }
        if(manualmente && !vazia) {
            ReproduzirMusicaManualmente(aux);
        }
        else {
            controller.adicionarPlaylistBiblioteca(user, aux);
            this.setContadorlistafavoritos(this.getContadorlistafavoritos() + 1);
            System.out.println("Playlist criada com sucesso!");
            MostrarMenuFavoritos();
        }

    }



    public void MostrarEstatisticas(){
        do{
            System.out.println("""
                ========= ESTATÍSTICAS =========
                (0) Voltar
                
                Música mais ouvida: """ + controller.musicaMaisOuvida().getNome() + ", " + controller.musicaMaisOuvida().getInterprete() + """
                
                Intérprete mais ouvido: """ + controller.interpreteMaisOuvido() + """
                
                Tipo de música mais ouvido: """ + controller.tipoMaisOuvido() + """
                
                Utilizador com mais pontos: """ + controller.utilizadorComMaisPontos().getNome() + ", " + controller.utilizadorComMaisPontos().getPontos() + """
                
                Utilizador com mais playlists: """ + controller.utilizadorComMaisPlaylists() + """
                
                Número de playlists públicas: """ + controller.quantasPlaylistsPublicas() + """
                
                Utilizador mais ativo: (1) Sempre   (2) Escolher Período de Tempo
                =================================
                """);

            this.opcao = lerOpcao();
            switch (this.opcao) {
                case 0 -> MostrarMenuUtilizador();
                case 1 -> {
                    Utilizador maisAtivo = controller.utilizadorMaisAtivo();

                    if(maisAtivo != null){
                        System.out.println("O utilizador mais ativo de sempre é: " + maisAtivo.getNome());
                    }
                    else{
                        System.out.println("Nenhum utilizador com reproduções.");
                    }
                }
                case 2 -> {
                    System.out.println("!!ESCOLHA UM PERÍODO DE TEMPO!!");
                    System.out.println("Início (yyyy-MM-dd): ");
                    LocalDate i = LocalDate.parse(s.nextLine());

                    System.out.println("Fim (yyyy-MM-dd): ");
                    LocalDate f = LocalDate.parse(s.nextLine());

                    Utilizador maisAtivo = controller.utilizadorMaisAtivoNumPeriodo(i, f);

                    if (maisAtivo != null) {
                        System.out.println("Utilizador mais ativo entre " + i + " e " + f + ": " + maisAtivo.getNome());
                    } else {
                        System.out.println("Nenhum utilizador com reproduções neste período.");
                    }
                }
                default -> System.out.println("Opção inválida");
            }
        } while (this.opcao != 0);
    }

}