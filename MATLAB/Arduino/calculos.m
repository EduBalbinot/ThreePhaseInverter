function [xai, xbi, xci, Xto, Aon, Bon, Con] = calculos(t, triang, tolerance, ya, yb, yc,xa, xb, xc)
vetoresy = {ya(2:end), yb(2:end), yc(2:end)}; % armazena os vetores em uma célula de células
vetoresx = {xa(2:end), xb(2:end), xc(2:end)};

%Conferir se a chave começa ligada(1) ou desligada(-1)
Aon=-1; Bon=-1; Con =-1;
if ya(2)> -tolerance; Aon = 1;end
if yb(2)> -tolerance; Bon = 1;end
if yc(2)> -tolerance; Con = 1;end
    
% Excluir acionamentos fora da tolerancia
for i = 1:numel(vetoresy)
    indices = find(vetoresy{i} >  tolerance | vetoresy{i} <  - tolerance);  % encontra os índices para cada vetor onde y[i]=+-1
    mask = ~ismember(1:numel(vetoresy{i}), indices);                        % cria uma máscara lógica que exclui os índices encontrados
    vetoresy{i} = vetoresy{i}(mask);                                        % aplica a máscara lógica para remover os elementos em y
    vetoresx{i} = vetoresx{i}(mask);                                        % aplica a máscara lógica para remover os elementos em x
end

[xai, xbi, xci] = deal(vetoresx{:});       % retorna os vetores em x
[yai, ybi, yci] = deal(vetoresy{:});       % retorna os vetores em y

% Adicionar uma coluna indicando qual senoidal é a intersecção 
xai(:,2) = ones(numel(xai(:,1)),1);
xbi(:,2) = 2*ones(numel(xbi(:,1)),1);
xci(:,2) = 3*ones(numel(xci(:,1)),1);

% Juntar os dados
Xt = cat(1, xai, xbi, xci);

% Ordenar
Xts = sortrows(Xt, 1);          % Ordena os dados
Xtd = diff(Xts(:,1));           % Calcula as diferenças
F = t(end)-Xts(end,1);          % Calcula a diferença entre o último acionamento e o t final
Xto(:,1) = [Xts(1)+F; Xtd];     % Integra o primeiro numero somado com o t final
Xto(:,2) = Xts(:,2);            
return
end