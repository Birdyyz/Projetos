import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator implements ActionListener {
    JFrame frame;
    JTextField textF;
    JButton[] numbers = new JButton[10];
    JButton[] actions = new JButton[9];
    JButton plus = new JButton("+");
    JButton minus = new JButton("-");
    JButton multiply = new JButton("*");
    JButton divide = new JButton("/");
    JButton equal = new JButton("=");
    JButton decimal = new JButton(".");
    JButton clearAll = new JButton("C");
    JButton clearOne = new JButton("D");
    JButton negative = new JButton("(-)");

    JPanel panel;

    Font myFont = new Font("Times New Roman", Font.PLAIN, 25);
    double num1 = 0, num2 = 0, result = 0;
    char operator;

    Calculator (){
        frame = new JFrame("Calculator");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(350, 500);
        frame.setLayout(null);

        textF = new JTextField();
        textF.setBounds(15, 10, 300, 50);
        textF.setFont(myFont);
        textF.setEditable(false);

        actions[0] = plus;
        actions[1] = minus;
        actions[2] = multiply;
        actions[3] = divide;
        actions[4] = equal;
        actions[5] = decimal;
        actions[6] = clearAll;
        actions[7] = clearOne;
        actions[8] = negative;

        for(int i=0; i<9; i++){
            actions[i].addActionListener(this);
            actions[i].setFont(myFont);
            actions[i].setFocusable(false);
        }

        for(int i=0; i<10; i++){
            numbers[i] = new JButton(String.valueOf(i));
            numbers[i].setFont(myFont);
            numbers[i].setFocusable(false);
            numbers[i].addActionListener(this);
        }

        panel = new JPanel();
        panel.setBounds(15, 80, 300, 370);
        panel.setLayout(new GridLayout(5,4,10,10));
        panel.add(numbers[9]);
        panel.add(numbers[8]);
        panel.add(numbers[7]);
        panel.add(divide);
        panel.add(numbers[6]);
        panel.add(numbers[5]);
        panel.add(numbers[4]);
        panel.add(multiply);
        panel.add(numbers[3]);
        panel.add(numbers[2]);
        panel.add(numbers[1]);
        panel.add(minus);
        panel.add(clearAll);
        panel.add(numbers[0]);
        panel.add(clearOne);
        panel.add(plus);
        panel.add(negative);
        panel.add(equal);
        panel.add(decimal);

        frame.add(panel);
        frame.add(textF);
        frame.setVisible(true);
    }
    public static void main(String[] args) {
        Calculator c = new Calculator();
    }
    @Override
    public void actionPerformed(ActionEvent e) {
        for(int i=0; i<10; i++) {
            if (e.getSource() == numbers[i]) {
                textF.setText(textF.getText().concat(String.valueOf(i)));
            }
        }

        if(e.getSource() == decimal){
            textF.setText(textF.getText().concat("."));
        }

        if(e.getSource() == plus){
                num1 = Double.parseDouble(textF.getText());
                operator = '+';
                textF.setText("");
            }
            if(e.getSource() == minus){
                num1 = Double.parseDouble(textF.getText());
                operator = '-';
                textF.setText("");
            }
            if(e.getSource() == multiply){
                num1 = Double.parseDouble(textF.getText());
                operator = '*';
                textF.setText("");
            }
            if(e.getSource() == divide){
                num1 = Double.parseDouble(textF.getText());
                operator = '/';
                textF.setText("");
            }

            if(e.getSource() == equal){
                num2 = Double.parseDouble(textF.getText());
                switch (operator){
                    case '+':
                        result = num1 + num2;
                        break;
                    case '-':
                        result = num1 - num2;
                        break;
                    case '*':
                        result = num1 * num2;
                        break;
                    case '/':
                        result = num1 / num2;
                        break;
            }
            textF.setText(String.valueOf(result));
            num1 = result;
        }
            if(e.getSource() == clearAll){
                textF.setText("");
            }
            if(e.getSource() == clearOne){
                String s = textF.getText();
                if (!s.isEmpty()) {
                    textF.setText(s.substring(0, s.length() - 1));
                }
            }
        if(e.getSource() == negative){
                Double temp = Double.parseDouble(textF.getText());
                temp *= -1;
                textF.setText(String.valueOf(temp));
            }
    }
}
