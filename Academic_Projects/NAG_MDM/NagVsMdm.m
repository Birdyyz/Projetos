clear, clc, close all;

m = 0.01;
L = 1;

d = 100;

epsilon = 1e-6;

kmax = 1000;

nruns = 10;

eta = 1/L;
beta = (sqrt(L)-sqrt(m))/(sqrt(L)+sqrt(m));

A1 = randn(d,d);
[Q,~] = qr(A1);
D = rand(d,1);
D = 10.^D;
D = (D - min(D)) / (max(D) - min(D));
D = m + (L-m)*D;
A1 = Q' * diag(D) * Q;

A2 = randn(d,d);
[Q,~] = qr(A2);
D = rand(d,1);
D = 10.^D;
D = (D - min(D)) / (max(D) - min(D));
D = m + (L-m)*D;
A2 = Q' * diag(D) * Q;

A_set = {A1, A2};

for p = 1:2

    A = A_set{p};

    Resultados_MDM = cell(nruns,3);
    Resultados_NAG = cell(nruns,3);

    hist_MDM_run1 = [];
    hist_NAG_run1 = [];

    for r = 1:nruns

        w0 = rand(d,1);

        % MDM

        w = w0;
        hist_F = zeros(kmax,1);

        for k_MDM = 1:kmax

            Fw = 0.5*w'*A*w;
            hist_F(k_MDM) = Fw;

            if Fw <= epsilon
                break
            end

            grad = A * w;          % calcula o gradiente (A*w)
            w = w - eta * grad;    % atualiza o ponto

        end

        grad_final = A*w;

        Resultados_MDM{r,1} = k_MDM;
        Resultados_MDM{r,2} = norm(grad_final,inf);
        Resultados_MDM{r,3} = 0.5*w'*A*w;

        if r == 1
            hist_MDM_run1 = hist_F(1:k_MDM);
        end

        % NAG (corrigido)

        v = w0;             % ponto de momento (onde se calcula o gradiente)
        w = w0;             % iterado principal
        hist_F = zeros(kmax,1);

        for k_NAG = 1:kmax

            Fw = 0.5*w'*A*w;
            hist_F(k_NAG) = Fw;

            if Fw <= epsilon
                break
            end

            grad = A*v;                           % gradiente no ponto de momento
            w_new = v - eta*grad;                 % passo de gradiente -> novo w
            v_new = w_new + beta*(w_new - w);     % extrapolação -> novo ponto de momento
            w = w_new;
            v = v_new;

        end

        grad_final = A*w;

        Resultados_NAG{r,1} = k_NAG;
        Resultados_NAG{r,2} = norm(grad_final,inf);
        Resultados_NAG{r,3} = 0.5*w'*A*w;

        if r == 1
            hist_NAG_run1 = hist_F(1:k_NAG);
        end

    end

    % TABELAS FINAIS

    T_MDM = cell2table(Resultados_MDM,'VariableNames',{'k','norm_grad_inf','F_wk'});
    T_NAG = cell2table(Resultados_NAG,'VariableNames',{'k','norm_grad_inf','F_wk'});

    % MEDIAS

    k_mean_MDM    = mean(cell2mat(Resultados_MDM(:,1)));
    grad_mean_MDM = mean(cell2mat(Resultados_MDM(:,2)));
    F_mean_MDM    = mean(cell2mat(Resultados_MDM(:,3)));

    k_mean_NAG    = mean(cell2mat(Resultados_NAG(:,1)));
    grad_mean_NAG = mean(cell2mat(Resultados_NAG(:,2)));
    F_mean_NAG    = mean(cell2mat(Resultados_NAG(:,3)));

    % OUTPUT

    fprintf('\n PROBLEMA %d - MDM \n',p)
    disp(T_MDM)
    fprintf('Medias MDM: k=%.1f | norm_grad=%.2e | F_wk=%.2e\n', k_mean_MDM, grad_mean_MDM, F_mean_MDM)

    fprintf('\n PROBLEMA %d - NAG\n',p)
    disp(T_NAG)
    fprintf('Medias NAG: k=%.1f | norm_grad=%.2e | F_wk=%.2e\n', k_mean_NAG, grad_mean_NAG, F_mean_NAG)

    % GRAFICO (Problema 1)
    if p == 1
        figure;
        
        plot(1:length(hist_MDM_run1), log10(hist_MDM_run1), 'b', 'LineWidth', 1.5, 'DisplayName', 'MDM');
        hold on;
        plot(1:length(hist_NAG_run1), log10(hist_NAG_run1), 'r', 'LineWidth', 1.5, 'DisplayName', 'NAG');
        xlabel('Iterações k');
        ylabel('log_{10}(F(w^k) - F(w^*))');
        title(sprintf('Convergência num run típico - Problema %d', p));
        legend;
        grid on;
    end
end