import Musica.*;
import Playlist.*;
import Utilizador.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Controller {

    private Model model;

    public Controller(Model model) {
        this.model = model;
    }

    public Model getModel() {
        return model;
    }
    public List<Playlist> getPlaylists() {
        return model.getPlaylists();
    }
    public List<Album> getAlbuns() {
        return model.getAlbuns();
    }
    public List<Musica> getMusicas() {
        return model.getMusicas();
    }
    public List<Utilizador> getUtilizadores() {
        return model.getUtilizadores();
    }

    public Controller clone() {
        return new Controller(model.clone());
    }

    //--------------------Utilizador--------------------

    public void atualizaPlano(Utilizador utilizador, PlanoSubscricao plano) {
        try {
            model.atualizarPlanoSubscricao(utilizador, plano);
        } catch (Exception e) {
            System.err.println("Erro ao atualizar plano: " + e.getMessage());
        }
    }

    public boolean registarUtilizador(Utilizador u) {
        try {
            model.registarUtilizador(u);
            return true;
        }
        catch (UtilizadorJaExisteException e) {
            return false;
        }
    }

    public boolean removerUtilizador(Utilizador u) {
        try {
            model.removerUtilizador(u);
            return true;
        }
        catch (UtilizadorNaoExisteException e) {
            return false;
        }
    }

    public String listarUtilizadores() {
        return model.listarUtilizadores();
    }

    public String listarDadosUtilizador(Utilizador u) {
        return model.listarDadosUtilizador(u);
    }

    //--------------------Musica--------------------

    public Musica procurarMusica(List<Musica> musicas, String nome, String interprete) {
        return model.procurarMusica(musicas, nome, interprete);
    }

    public Musica procurarMusicaBiblioteca(Utilizador u, String nome, String interprete){
        return model.procurarMusica(u.getBiblioteca().getMusicas(), nome, interprete);
    }

    public String listarMusicas() {
        return model.listarMusicas(getMusicas());
    }

    public String listarMusicaBiblioteca(Utilizador u){
        return model.listarMusicas(u.getBiblioteca().getMusicas());
    }

    public void reproduzirMusica(Utilizador u, Musica m) {
        model.reproduzirMusica(u, m);
    }

    public void adicionarMusicaBiblioteca(Utilizador u, Musica m) {
        try{
            u.getBiblioteca().adicionarMusica(m);
        }
        catch(Exception e) {
            System.out.println("Erro ao adicionar música " + e.getMessage());
        }
    }

    //--------------------Album--------------------

    public Album procurarAlbum(List<Album> albuns, String nome, String interprete) {
        return model.procurarAlbum(albuns, nome, interprete);
    }

    public Album procurarAlbumBiblioteca(Utilizador u, String nome, String interprete) {
        return procurarAlbum(u.getBiblioteca().getAlbuns(), nome, interprete);
    }

    public String listarAlbuns() {
        return model.listarAlbuns(getAlbuns());
    }

    public String listarAlbumBiblioteca(Utilizador u) {
        return model.listarAlbuns(u.getBiblioteca().getAlbuns());
    }

    public void reproduzirAlbum(Utilizador u, Album a) {
        model.reproduzirAlbum(u, a);
    }

    public boolean adicionarAlbumBiblioteca(Utilizador u, Album a) {
        boolean adicionou = u.getBiblioteca().adicionarAlbum(a);
        if (adicionou) {
            for (Musica m : a.getMusicas()) {
                u.getBiblioteca().adicionarMusica(m);
            }
        }
        return adicionou;
    }


    public void removerAlbumBiblioteca(Utilizador u, String nomeAlbum) {
        if(u != null && u.getBiblioteca() != null) {
            u.getBiblioteca().getAlbuns().removeIf(a -> a.getNome().equalsIgnoreCase(nomeAlbum));
        }
    }

    //--------------------Playlist--------------------

    public Playlist procurarPlaylist(List<Playlist> playlists, String nome) {
        return model.procurarPlaylist(playlists, nome);
    }

    public Playlist procurarPlaylistBiblioteca(Utilizador u, String nome) {
        return procurarPlaylist(u.getBiblioteca().getPlaylists(), nome);
    }

    public String listarPlaylists() {
        return model.listarPlaylists(getPlaylists());
    }

    public String listarPlaylistBiblioteca(Utilizador u) {
        return model.listarPlaylists(u.getBiblioteca().getPlaylists());
    }

    public void reproduzirPlaylist(Utilizador u, Playlist p, boolean manualmente) {
        model.reproduzirPlaylist(u, p,manualmente);
    }

    public boolean adicionarPlaylistBiblioteca(Utilizador u, Playlist p) {
        try {
            boolean adicionada = u.getBiblioteca().adicionarPlaylist(p);
            if (adicionada) {
                for (Musica m : p.getMusicas()) {
                    u.getBiblioteca().adicionarMusica(m);
                }
            }
            return adicionada;
        }
        catch (Exception e) {
            System.out.println("Erro ao adicionar playlist" + e.getMessage());
            return false;
        }
    }

    public void removerPlaylistBiblioteca(Utilizador u, String nomePlaylist) {
        if(u != null && u.getBiblioteca() != null) {
            u.getBiblioteca().getPlaylists().removeIf(p -> p.getNome().equalsIgnoreCase(nomePlaylist));
        }
    }

    public void ImprimirPremiumAleatoria(Playlist p){
        model.PlaylistPremiumOrdemAleatoria(p);
    }

    public Playlist TornarAleatoria(Playlist p){
        return model.TornaAleatorio(p);
    }

    public boolean nomePlaylistValido(String nome, Utilizador u, List<Playlist> playlistsPublicas) {
        for (Playlist p : playlistsPublicas) { // verifica nas playlists públicas
            if (p.getNome().equalsIgnoreCase(nome)) {
                return false;
            }
        }
        for (Playlist p : u.getBiblioteca().getPlaylists()) { // verifica nas playlists do utilizador
            if (p.getNome().equalsIgnoreCase(nome)) {
                return false;
            }
        }
        return true; // nome está disponível
    }

    public int tamanhoPlaylist(Playlist p) {
        return model.verificatamanho(p);
    }

    public void reproduzirPlaylistManualmente(Utilizador u, Playlist p, int posicaoatual) {
        model.reproduzirmusicaatualPremium(u,p,posicaoatual);
    }

    public boolean PlaylistVazia(Playlist p){
        return model.verificaVazia(p);
    }

    public boolean GeneroExiste(String genero){
        return model.verificaGeneroMusical(genero);
    }

    public String listarPlaylistsPrivadas(Utilizador u){
        return model.listarPlaylistsPrivadas(u);
    }

    public boolean tornarPublica(Utilizador u, Playlist p){
        return model.tornarPublica(u,p);
    }

    public int calcularduracao(Playlist p){
        return model.CalculaDuracao(p);
    }
    public PlaylistPremium criaPlayPremium(Utilizador u,String nome, List<Musica> musicas,boolean aleatorio, boolean manualmente){
        return model.criaPlaylistPremium(u,nome,musicas,aleatorio,manualmente);
    }

    public PlaylistGeneroMusical criaplaylistgeneromusical(Utilizador u,String nome, String genero, int duracaoMax,boolean aleatorio, List<Musica> todasAsMusicasDisponiveis, boolean manualmente){
        return model.criarPlaylistGeneroMusical(u,nome,genero,duracaoMax,aleatorio,todasAsMusicasDisponiveis,manualmente);
    }

    public PlaylistFavoritos criaplaylistfav(Utilizador u, String nome, int duracaoplaylist, boolean aleatorio, List<Musica> todasAsMusicasDisponiveis, boolean manualmente){
        return model.criarPlaylistFavoritos(u,nome,duracaoplaylist,aleatorio,todasAsMusicasDisponiveis,manualmente);
    }

    public PlaylistAleatoria criaplaylistaleatoria(Utilizador u,String nome){
        return model.criarPlaylistAleatoria(u, model.getMusicas(),nome);
    }

    public PlaylistFavoritoscMusicaExplicita criaplaylistmusicaexplicita(Utilizador u,String nome,boolean aleatorio, List<Musica> musicas, boolean manualmente){
        return model.criarPlaylistFavMusicaExplicita(u,nome,aleatorio,musicas,manualmente);
    }

    public PlaylistFavoritossemrestricao criaPlaylistfavsemrestricoes(Utilizador u,String nome,boolean aleatorio, List<Musica> musicas, boolean manualmente){
        return model.criarPlaylistFavoritossemrestricao(u,nome,aleatorio,musicas,manualmente);
    }

    //--------------------Estatística--------------------

    public Musica musicaMaisOuvida() {
        return model.musicaMaisOuvida();
    }

    public String interpreteMaisOuvido() {
        return model.interpreteMaisOuvido();
    }

    public String tipoMaisOuvido() {
        return model.tipoMaisOuvido();
    }

    public Utilizador utilizadorComMaisPontos() {
        return model.utilizadorComMaisPontos();
    }

    public Utilizador utilizadorComMaisPlaylists() {
        return model.utilizadorComMaisPlaylists();
    }

    public Utilizador utilizadorMaisAtivo(){
        return model.utilizadorMaisAtivo();
    }

    public Utilizador utilizadorMaisAtivoNumPeriodo(LocalDate i, LocalDate f){
        return model.utilizadorMaisAtivoNumPeriodo(i,f);
    }

    public int quantasPlaylistsPublicas() {
        return model.quantasPlaylistsPublicas();
    }

    //--------------------Estado--------------------

    public void guardaEstado() {
        try{
            model.guardaEstado("estado.dat");
        }
        catch(IOException e) {
            System.out.println("Falha a guardar");
        }
    }

    public void carregaEstado() throws ClassNotFoundException {
        try{
            Model.carregaEstado("estado.dat");
        }
        catch (IOException e) {
            System.out.println("Falha a carregar");
        }
    }

}