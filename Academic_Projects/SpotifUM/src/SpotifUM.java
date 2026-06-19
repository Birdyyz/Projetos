import Utilizador.*;

import java.io.File;
import java.io.IOException;

public class SpotifUM {

    public static void main(String[] args) {
        Model model;

        File f = new File("estado.dat");
        if (f.exists()) {
            // Se já existir, carrega o estado anterior
            try {
                model = Model.carregaEstado("estado.dat");
                System.out.println("Estado carregado com sucesso.");
            } catch (IOException | ClassNotFoundException e) {
                System.err.println("\nErro ao carregar estado: " + e.getMessage());
                return;
            }
        } else {
            // Senão, cria novo model e carrega os dados de teste
            model = new Model();
            try {
                model.guardaEstado("estado.dat");
                System.out.println("Estado inicial guardado.");
            } catch (IOException e) {
                System.err.println("Erro ao guardar estado inicial: " + e.getMessage());
            }
        }

        Controller controller = new Controller(model);
        View view = new View();
        view.setController(controller);
        view.Mostrarinicio();

        try {
            model.guardaEstado("estado.dat");
            System.out.println("Estado final guardado.");
        } catch (IOException e) {
            System.err.println("Erro ao guardar estado inicial: " + e.getMessage());
        }
    }


}