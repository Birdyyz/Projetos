import Musica.*;
import Playlist.*;
import Utilizador.*;

import java.io.*;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class Model implements Serializable {
    public List<Playlist> playlists; // esta é a lista das playlists publicas, as que todos os utilizadores têm acesso
    public List<Album> albuns;
    public List<Musica> musicas;
    public List<Utilizador> utilizadores;

    @Serial
    private static final long serialVersionUID = 1L;

    public Model() {
        this.playlists = new ArrayList<>();
        this.albuns = new ArrayList<>();
        this.musicas = new ArrayList<>();
        this.utilizadores = new ArrayList<>();
    }

    public Model(Model outro) {
        this.playlists = outro.getPlaylists();
        this.albuns = outro.getAlbuns();
        this.musicas = outro.getMusicas();
        this.utilizadores = outro.getUtilizadores();
    }

    public List<Playlist> getPlaylists() {
        return this.playlists;
    }
    public List<Album> getAlbuns() {
        return this.albuns;
    }
    public List<Musica> getMusicas() {
        return this.musicas;
    }
    public List<Utilizador> getUtilizadores() {
        return this.utilizadores;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Playlists: ").append(this.playlists);
        sb.append("\nMúsicas: ").append(this.musicas);
        sb.append("\nÁlbuns: ").append(this.albuns);
        sb.append("\nUtilizadores: ").append(this.utilizadores);

        return sb.toString();
    }

    public Model clone() {
        return new Model(this);
    }

    //--------------------Utilizador--------------------

    // altera plano
    public void atualizarPlanoSubscricao(Utilizador u, PlanoSubscricao p) {
        u.mudarPlano(u, p);
    }

    // adiciona utilizador se o email não existir
    public void registarUtilizador(Utilizador utilizador) throws UtilizadorJaExisteException {
        if(utilizadores.stream().anyMatch(u -> u.getEmail().equals(utilizador.getEmail()))){
            throw new UtilizadorJaExisteException("Este utilizador já existe.\n");
        }
        utilizadores.add(utilizador);
    }

    // remove utilizador existente com base no email
    public void removerUtilizador(Utilizador utilizador) throws UtilizadorNaoExisteException {
        if(utilizadores.stream().anyMatch(u -> u.getEmail().equals(utilizador.getEmail()))){
            utilizadores.remove(utilizador);
        }
        else{
            throw new UtilizadorNaoExisteException("Este utilizador não existe.\n");
        }
    }

    // imprime todos os utilizadores existentes
    public String listarUtilizadores() {
        StringBuilder sb = new StringBuilder();
        for(Utilizador u : utilizadores){
            sb.append(u.toString()).append("\n");
        }
        return sb.toString();
    }

    // imprime os dados de um utilizador
    public String listarDadosUtilizador(Utilizador u) {
        return u.toString();
    }

    //--------------------Musica--------------------

    // adiciona música à lista global e ao respetivo álbum (cria álbum se não existir)
    public void adicionarMusica(Musica m) {
        if (m.getNome() == null) {
            throw new IllegalArgumentException("Argumento inválido.\n");
        }

        musicas.add(m);

        Album album = m.getAlbum();
        if (album == null || album.getNome() == null) return;

        Album existeAlbum = null;
        for (Album a : albuns) {
            if (a != null && album.getNome().equals(a.getNome())) {
                existeAlbum = a;
                break;
            }
        }

        if (existeAlbum != null) {
            existeAlbum.adicionarMusica(m);
        } else {
            adicionarAlbum(album);
            album.adicionarMusica(m);
        }
    }

    // procura música por nome e intérprete
    public Musica procurarMusica(List<Musica> musicas, String nome, String interprete) {
        for(Musica m : musicas) {
            if(m.getNome().equalsIgnoreCase(nome) && m.getInterprete().equalsIgnoreCase(interprete)) {
                return m;
            }
        }
        return null;
    }

    // imprime as músicas
    public String listarMusicas(List<Musica> musicas) {
        StringBuilder sb = new StringBuilder();
        for (Musica m : musicas) {
            if(m != null){
                sb.append(m.getNome()).append(" - ").append(m.getInterprete())
                        .append(" - ").append(m.getDuracao()).append("\n");
            }
            else{
                System.out.println("Desconhecido.");
            }
        }
        return sb.toString();
    }

    // reproduz música individual e atualiza os pontos
    public void reproduzirMusica(Utilizador u, Musica m) {
        if(u.getBiblioteca() != null && m != null) {
            m.reproduzir();
            u.getBiblioteca().adicionarMusica(m);
            u.atualizarPontos(u, m); // o atualizarPontos tem de vir sempre antes de registarReproducao
            u.registarReproducao(m);
        }
    }

    //--------------------Album--------------------

    // adiciona álbum novo à lista (com verificação de duplicado)
    public void adicionarAlbum(Album a) throws ConteudoJaExisteException {
        if(a.getNome() == null) {
            throw new IllegalArgumentException("Argumento inválido.\n");
        }
        albuns.add(a);
    }

    // procura album por nome e intérprete
    public Album procurarAlbum(List<Album> albuns, String nome, String interprete) {
        for (Album a : albuns) {
            if (a.getNome().equalsIgnoreCase(nome) && a.getInterprete().equalsIgnoreCase(interprete)) {
                return a;
            }
        }
        return null;
    }

    // imprime os albuns
    public String listarAlbuns(List<Album> albuns) {
        StringBuilder sb = new StringBuilder();
        for (Album a : albuns) {
            sb.append(a.getNome()).append(" - ").append(a.getInterprete())
                    .append(" - ").append(a.getMusicas() != null ? a.getMusicas().size() : 0).append("\n");
        }
        return sb.toString();
    }


    // reproduz álbum e atualiza os pontos
    public void reproduzirAlbum(Utilizador u, Album a) {
        if(u.getBiblioteca() != null && a != null) {
            a.reproduzir();
            for(Musica m : a.getMusicas()) {
                u.getBiblioteca().adicionarMusica(m);
                u.atualizarPontos(u, m); // o atualizarPontos tem de vir sempre antes de registarReproducao
                u.registarReproducao(m);
            }
        }
    }

    //--------------------Playlist-------------------

    // adiciona playlist à lista global (com verificação de duplicado)
    public void adicionarPlaylist(Playlist playlist) throws ConteudoJaExisteException {
        if(playlist.getNome() == null) {
            throw new IllegalArgumentException("Argumento inválido.\n");
        }
        boolean playlistExiste = playlists.stream().anyMatch(p -> p.getNome().equals(playlist.getNome()));
        if(playlistExiste) {
            System.out.println("Playlist com esse nome já existe.\n");
            throw new ConteudoJaExisteException();
        }
        playlists.add(playlist);
    }

    // procura playlist pública por nome
    public Playlist procurarPlaylist(List<Playlist> playlists, String nome) {
        for(Playlist p : playlists) {
            if(p.getNome().equalsIgnoreCase(nome)) {
                return p;
            }
        }
        return null;
    }

    // imprime os playlists
    public String listarPlaylists(List<Playlist> playlists) {
        StringBuilder sb = new StringBuilder();
        for(Playlist p : playlists) {
            sb.append(p.getNome()).append("\n");
        }
        return sb.toString();
    }

    public boolean verificaGeneroMusical(String genero){
        return getMusicas().stream()
                .anyMatch(m -> m.getGenero().equalsIgnoreCase(genero));
    }

    public int verificatamanho(Playlist p) {
        return p.getMusicas().size();
    }

    public boolean verificaVazia(Playlist p) {
        return p == null || p.getMusicas().isEmpty();
    }

    // reproduz playlist e atualiza os pontos
    public void reproduzirPlaylist(Utilizador u, Playlist p, boolean manualmente) {

        if(u == null || p == null) return;
        else if(p instanceof PlaylistAleatoria) {
            ((PlaylistAleatoria) p).reproduzirAleatoria(getMusicas());
        }
        else if (p instanceof PlaylistFavoritoscMusicaExplicita) {
            ((PlaylistFavoritoscMusicaExplicita) p).reproduzfavoritoscMusicaExplicita(((PlaylistFavoritoscMusicaExplicita) p).getNumReproducoes(),manualmente);
        }
        else if(p instanceof PlaylistFavoritossemrestricao){
            ((PlaylistFavoritossemrestricao)p).reproduzfavoritossemrestricao(((PlaylistFavoritossemrestricao)p).getNumReproducoes(),manualmente);
        }
        else if(p instanceof PlaylistFavoritos) {
            ((PlaylistFavoritos) p).reproduzirfavoritos(((PlaylistFavoritos) p).getNumReproducoes(),manualmente);
        }
        else if (p instanceof PlaylistGeneroMusical) {
            ((PlaylistGeneroMusical) p).reproduzirmusicasGeneroMusical(p.getMusicas(),manualmente);
        }
        else if(p instanceof PlaylistPremium){
            ((PlaylistPremium) p).reproduzirPlaylistPremium();
        }
        else {
            p.reproduzirPlaylistNormal();
        }


        for(Musica m : p.getMusicas()) {
            u.getBiblioteca().adicionarMusica(m);
            u.atualizarPontos(u, m); // o atualizarPontos tem de vir sempre antes de registarReproducao
            u.registarReproducao(m);
        }
    }

    public int CalculaDuracao(Playlist p){
        int duracao = 0;
        for(Musica m : p.getMusicas()){
            duracao += m.getDuracao();
        }
        return duracao;
    }

    public void reproduzirmusicaatualPremium(Utilizador u, Playlist p, int posicaoatual) {
        List<Musica> playlist = p.getMusicas();
        Musica atual = playlist.get(posicaoatual);
        atual.reproduzir();
        u.atualizarPontos(u, atual);
        u.registarReproducao(atual);
    }


    public String listarPlaylistsPrivadas(Utilizador u) {
        return u.getBiblioteca().getPlaylists().stream()
                .filter(p -> p instanceof PlaylistPremium && !((PlaylistPremium) p).getPublica())
                .map(Playlist::toString)
                .collect(Collectors.joining("\n"));
    }

    public boolean tornarPublica(Utilizador u, Playlist p) { // não funciona por causa do criaPlaylist()
        if(u.getBiblioteca() != null && p instanceof PlaylistPremium) {
            ((PlaylistPremium) p).setPublica(true);
            playlists.add(p);
            return true;
        }
        return false;
    }

    public void PlaylistPremiumOrdemAleatoria(Playlist p){
        List<Musica> playlist = p.getMusicas();
        Collections.shuffle(playlist);
        ((PlaylistPremium) p).reproduzirPlaylistPremium();
    }

    public Playlist TornaAleatorio(Playlist p){
        Playlist copia = new Playlist();
        List<Musica> copiaMusicas = new ArrayList<>(p.getMusicas());
        Collections.shuffle(copiaMusicas);
        copia.setMusicas(copiaMusicas);
        return copia;
    }

    public PlaylistAleatoria criarPlaylistAleatoria(Utilizador u, List<Musica> todasAsMusicasDisponiveis, String nome){
        PlaylistAleatoria playlist = new PlaylistAleatoria();
        playlist.setNome(nome);
        List<Musica> musicasAleatorias = playlist.criaPlaylistAleatoria(todasAsMusicasDisponiveis);
        playlist.setMusicas(musicasAleatorias);
        reproduzirPlaylist(u,playlist,false);
        return playlist;
    }

    public PlaylistPremium criaPlaylistPremium(Utilizador u,String nome, List<Musica> musicas, boolean aleatorio,boolean manualmente){
        PlaylistPremium playlist = new PlaylistPremium();
        playlist.setNome(nome);
        playlist.setPosicaoatual(0);
        playlist.setMusicas(getMusicas());
        playlist.setPlaylistAtual(musicas);
        playlist.setPublica(false);
        playlist.setModoaleatorio(aleatorio);
        Map<Musica, Integer> numReproducoes = new HashMap<>();
        for (Musica m : musicas) {
            numReproducoes.put(m, 0);
        }
        playlist.setNumReproducoes(numReproducoes);
        if(!manualmente) {
            reproduzirPlaylist(u, playlist, manualmente);
        }
        return playlist;
    }

    public PlaylistGeneroMusical criarPlaylistGeneroMusical(Utilizador u,String nome, String genero, int duracaoMax, boolean aleatorio, List<Musica> todasAsMusicasDisponiveis,boolean manualmente) {
        PlaylistGeneroMusical playlist = new PlaylistGeneroMusical();
        playlist.setNome(nome);
        playlist.setGeneroMusical(genero);
        playlist.setDuracaoPlaylist(duracaoMax);
        playlist.setAleatorio(aleatorio);
        playlist.setMusicas(todasAsMusicasDisponiveis);
        Map<Musica, Integer> numReproducoes = new HashMap<>();
        for (Musica m : todasAsMusicasDisponiveis) {
            numReproducoes.put(m, 0);
        }
        playlist.setNumReproducoes(numReproducoes);
        reproduzirPlaylist(u,playlist,manualmente);
        return playlist;
    }


    public PlaylistFavoritos criarPlaylistFavoritos(Utilizador u, String nome, int duracaoplaylist , boolean aleatorio, List<Musica> todasAsMusicasDisponiveis, boolean manualmente) {
        PlaylistFavoritos playlist = new PlaylistFavoritos();
        playlist.setNome(nome);
        playlist.setMusicas(todasAsMusicasDisponiveis);
        playlist.setAleatorio(aleatorio);
        playlist.setDuracaoplaylist(duracaoplaylist);
        playlist.setMusicasReproduzidas(new ArrayList<>());
        Map<Musica, Integer> numReproducoes = new HashMap<>();
        for (Musica m : todasAsMusicasDisponiveis) {
            numReproducoes.put(m, 0);
        }
        playlist.setNumReproducoes(numReproducoes);
        reproduzirPlaylist(u,playlist,manualmente);
        return playlist;
    }

    public PlaylistFavoritoscMusicaExplicita criarPlaylistFavMusicaExplicita(Utilizador u, String nome, boolean aleatorio, List<Musica> todasAsMusicasDisponiveis, boolean manualmente) {
        PlaylistFavoritoscMusicaExplicita playlist = new PlaylistFavoritoscMusicaExplicita();
        playlist.setNome(nome);
        playlist.setAleatorio(aleatorio);
        playlist.setMusicas(todasAsMusicasDisponiveis);
        Map<Musica, Integer> numReproducoes = new HashMap<>();
        for (Musica m : todasAsMusicasDisponiveis) {
            numReproducoes.put(m, 0);
        }
        playlist.setNumReproducoes(numReproducoes);
        reproduzirPlaylist(u,playlist,manualmente);
        return playlist;
    }

    public PlaylistFavoritossemrestricao criarPlaylistFavoritossemrestricao(Utilizador u, String nome, boolean aleatorio, List<Musica> todasAsMusicasDisponiveis, boolean manualmente) {
        PlaylistFavoritossemrestricao playlist = new PlaylistFavoritossemrestricao();
        playlist.setNome(nome);
        playlist.setAleatorio(aleatorio);
        playlist.setMusicas(todasAsMusicasDisponiveis);
        Map<Musica, Integer> numReproducoes = new HashMap<>();
        for (Musica m : todasAsMusicasDisponiveis) {
            numReproducoes.put(m, 0);
        }
        playlist.setNumReproducoes(numReproducoes);
        reproduzirPlaylist(u,playlist,manualmente);
        return playlist;
    }

    //--------------------Estatística--------------------

    public Musica musicaMaisOuvida() {
        return musicas.stream().max(Comparator.comparingInt(Musica::getNumeroRep)).orElse(null);
    }

    public String interpreteMaisOuvido() {
        Map<String,Integer> contaInterprete = new HashMap<>();
        for(Musica musica: musicas) {
            String interprete = musica.getInterprete();
            int numeroRep = musica.getNumeroRep();
            contaInterprete.put(interprete, numeroRep);
        }
        return contaInterprete.entrySet().stream().max(Map.Entry.comparingByValue()).map(Map.Entry::getKey).orElse("Sem informação");
    }

    public String tipoMaisOuvido() {
        Map<String,Integer> contadorPorTipo = new HashMap<>();
        String tipo = "Desconhecido";
        for(Musica musica : musicas){
            if(musica instanceof MusicaMultimedia) {
                tipo = "Multimédia.\n";
            }
            else if(musica instanceof MusicaExplicita) {
                tipo = "Explícita.\n";
            }

            int numeroRep = musica.getNumeroRep();
            contadorPorTipo.put(tipo,numeroRep);
        }
        return contadorPorTipo.entrySet().stream().max(Map.Entry.comparingByValue()).map(Map.Entry::getKey).orElse("Sem informação");
    }

    public Utilizador utilizadorComMaisPontos() {
        return utilizadores.stream().max(Comparator.comparingInt(Utilizador::getPontos)).orElse(null);
    }

    public Utilizador utilizadorComMaisPlaylists() {
        return utilizadores.stream().filter(u->u.getBiblioteca() != null).max(Comparator.comparingInt(u -> u.getBiblioteca().getPlaylists().size())).orElse(null);
    }

    public Utilizador utilizadorMaisAtivo(){
        return utilizadores.stream().max(Comparator.comparingInt(Utilizador::numeroMusicasReproduzidas)).orElse(null);
    }

    public Utilizador utilizadorMaisAtivoNumPeriodo(LocalDate inicio, LocalDate fim){
        return utilizadores.stream().max(Comparator.comparingLong(u -> u.musicasReproduzidasNumPeriodo(inicio, fim))).orElse(null);
    }

    public int quantasPlaylistsPublicas() {
        int contadorPlaylist = 0;

        for(Playlist p : playlists){
            if(p instanceof PlaylistPremium && ((PlaylistPremium) p).getPublica()){
                contadorPlaylist++;
            }
        }
        return contadorPlaylist;
    }

    //--------------------Estado--------------------

    public void guardaEstado(String nomeFicheiro) throws FileNotFoundException, IOException {
        FileOutputStream fos = new FileOutputStream(nomeFicheiro);
        ObjectOutputStream oos = new ObjectOutputStream(fos);

        oos.writeObject(this);

        oos.flush();
        oos.close();
    }

    public static Model carregaEstado(String nomeFicheiro) throws FileNotFoundException, IOException, ClassNotFoundException {
        FileInputStream fis = new FileInputStream(nomeFicheiro);
        ObjectInputStream ois = new ObjectInputStream(fis);

        Model m = (Model) ois.readObject();

        ois.close();

        return m;
    }

}