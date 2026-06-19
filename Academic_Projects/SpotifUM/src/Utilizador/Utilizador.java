package Utilizador;
import Musica.Musica;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.*;

public class Utilizador implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;
    private String email;
    private String morada;
    private PlanoSubscricao plano;
    private int pontos;
    private Biblioteca biblioteca;
    private Map<Musica, List<LocalDate>> historicoRep = new HashMap<>();

    // construtor padrão
    public Utilizador() {
        this.nome = "";
        this.email = "";
        this.morada = "";
        this.plano = new PlanoFree(); // começa com o Free, mas pode trocar depois
        this.pontos = 0;
        this.biblioteca = new Biblioteca();
    }

    // construtor simples para novo utilizador
    public Utilizador(String nome, String email) {
        this.nome = nome;
        this.email = email;
        this.morada = "";
        this.plano = new PlanoFree();
        this.pontos = 0;
        this.biblioteca = new Biblioteca();
    }

    // construtor parametrizado
    public Utilizador(String nome, String email, String morada, PlanoSubscricao p, int pontos, Biblioteca b) {
        this.nome = nome;
        this.email = email;
        this.morada = morada;
        this.plano = p;
        this.pontos = pontos;
        this.biblioteca = b;
    }

    // construtor cópia
    public Utilizador(Utilizador u) {
        this.nome = u.getNome();
        this.email = u.getEmail();
        this.morada = u.getMorada();
        this.plano = u.getPlano();
        this.pontos = u.getPontos();
        this.biblioteca = u.getBiblioteca();
        this.historicoRep = u.getHistoricoRep();
    }

    // getters
    public String getNome() {
        return this.nome;
    }
    public String getEmail() {
        return this.email;
    }
    public String getMorada() {
        return this.morada;
    }
    public PlanoSubscricao getPlano() {
        return this.plano;
    }
    public int getPontos() {
        return this.pontos;
    }
    public Biblioteca getBiblioteca() {
        return this.biblioteca;
    }
    public Map<Musica, List<LocalDate>> getHistoricoRep() {
        return this.historicoRep;
    }

    // setters
    public void setNome(String nome) {
        this.nome = nome;
    }
    public void setPlano(PlanoSubscricao plano) {
        this.plano = plano;
    }
    public void setPontos(int pontos) {
        this.pontos = pontos;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Utilizador: ").append(nome)
                .append("       Email: ").append(email)
                .append("       Morada: ").append(morada)
                .append("       Pontos: ").append(pontos);
        sb.append("     Plano de Subscrição: ").append(plano.getClass().getSimpleName());
        sb.append("\n");

        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        Utilizador u = (Utilizador) o;
        return this.nome.equals(u.getNome()) && this.email.equals(u.getEmail()) &&
                this.morada.equals(u.getMorada()) && this.plano.equals(u.getPlano()) &&
                this.pontos == u.getPontos() && this.biblioteca.equals(u.getBiblioteca()) &&
                this.historicoRep.equals(u.getHistoricoRep());
    }

    public Utilizador clone() {
        return new Utilizador(this);
    }

    public void registarReproducao(Musica m){
        LocalDate data = LocalDate.now();

        // Se não existir lista para o dia, cria
        historicoRep.putIfAbsent(m, new ArrayList<>());
        historicoRep.get(m).add(data);
    }

    public int numeroMusicasReproduzidas(){
        return historicoRep.values().stream().mapToInt(List::size).sum();
    }

    public long musicasReproduzidasNumPeriodo(LocalDate inicio, LocalDate fim){
        return historicoRep.values().stream().flatMap(List::stream).filter(d-> !d.isBefore(inicio) && !d.isAfter(fim)).count();
    }

    // mudar de plano
    public void mudarPlano(Utilizador u, PlanoSubscricao p) {
        u.setPlano(p);
        if(p instanceof PlanoPremiumTop) {
            int pontosAdesao = ((PlanoPremiumTop) p).pontosAdesao(u);
            u.setPontos(pontosAdesao);
        }
    }

    // atualizar os pontos do utilizador baseado no mapa de histórico de reproduções
    public void atualizarPontos(Utilizador u, Musica m) {
        int pontos = u.getPlano().atualizaPontos(u, m);
        u.setPontos(pontos);
    }

}