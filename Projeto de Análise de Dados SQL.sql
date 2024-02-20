# --- ANÁLISES DE DADOS COM SQL --- #

-- Agrupamentos
-- Filtragem em agrupamentos
-- Subqueries
-- Criação de Views

-- Lembrando das tabelas do banco de dados...

SELECT * FROM alugueis;
SELECT * FROM atores;
SELECT * FROM atuacoes;
SELECT * FROM clientes;
SELECT * FROM filmes;

# =======        PARTE 1:        =======#
# =======  CRIANDO AGRUPAMENTOS  =======#

-- CASE 1.Fazer uma análise para descobrir o preço médio de aluguel dos filmes.

SELECT AVG(preco_aluguel) FROM filmes;

-- CASE 2. Agora que sabemos o preço médio para se alugar filmes, podemos ir além na análise e descobrir qual é o preço médio 
-- para cada gênero de filme.

/*
genero                   | preco_medio
______________________________________
Comédia                  | X
Drama                    | Y
Ficção e Fantasia        | Z
Mistério e Suspense      | A
Arte                     | B
Animação                 | C
Ação e Aventura          | D
*/

SELECT
	genero,
    ROUND(AVG(preco_aluguel), 2) AS preco_medio,
    COUNT(*) AS qtd_filmes
FROM filmes
GROUP BY genero;


# =======              PARTE 2:               =======#
# =======       FILTROS EM AGRUPAMENTOS       =======#

-- Alterar a consulta DO CASE 2 e considerar o seguinte cenário:

-- CASE 3: Fazer a mesma análise, mas considerando apenas os filmes com ANO_LANCAMENTO igual a 2011.

SELECT
	genero,
    ROUND(AVG(preco_aluguel), 2) AS preco_medio,
    COUNT(*) AS qtd_filmes
FROM filmes
WHERE ano_lancamento = 2011
GROUP BY genero;




# =======                         PARTE 3:                           =======#
# =======  SUBQUERIES: UTILIZANDO UM SELECT DENTRO DE OUTRO SELECT   =======#

-- CASE 4. Fazer uma análise de desempenho dos alugueis. 
-- Para isso, uma análise comum é identificar quais aluguéis tiveram nota acima da média. 

SELECT AVG(nota) FROM alugueis;  -- 7.94

SELECT 
	*
FROM alugueis
WHERE nota >= (SELECT AVG(nota) FROM alugueis);



# =======           PARTE 4:             =======#
# =======  Criando Views - CREATE VIEW   =======#


-- CREATE/DROP VIEW: Guardando o resultado de uma consulta no nosso banco de dados


-- CASE 5. Crie uma view para guardar o resultado do SELECT abaixo.

CREATE VIEW resultado AS
SELECT
	genero,
	ROUND(AVG(preco_aluguel), 2) AS media_preco,
    COUNT(*) AS qtd_filmes
FROM filmes
GROUP BY genero;

SELECT * FROM resultado;

#=======                PARTE 5:                      =======#

#======= ANÁLISES PARA DECISÕES DE CURTO E LONGO PRAZO =======#


-- CASE 6. Análise de determinação da receita com o número total de locações.
-- Para isso, podemos calcular a receita total da empresa considerando o preço de aluguel de cada filme multiplicado pelo número de locações.
-- Essa análise embasa decisões de longo prazo, ajudando a entender o desempenho financeiro da empresa ao longo do tempo.

SELECT SUM(preco_aluguel) AS receita_total FROM filmes;



-- CASE 7. Análise da satisfação dos clientes.
-- Podemos calcular a média das notas atribuídas pelos clientes aos filmes alugados como um indicador da satisfação geral dos clientes.
-- Essa análise é importante para avaliar a qualidade do catálogo de filmes e pode embasar decisões tanto de curto quanto de longo prazo, como a seleção de novos filmes para o catálogo.


SELECT AVG(nota) AS media_notas FROM alugueis;


-- CASE 8. Mensuração do engajamento dos clientes.
-- Podemos contar o número de clientes ativos ao longo de um período específico como uma medida de engajamento dos clientes com a plataforma de streaming.
-- Essa análise é crucial para entender a base de clientes fiéis e identificar tendências de engajamento ao longo do tempo, embasando decisões estratégicas de longo prazo.


SELECT COUNT(*) AS clientes_ativos FROM clientes WHERE data_criacao_conta <= CURRENT_TIMESTAMP();

SELECT 
    clientes.id_cliente,
    nome_cliente,
    COUNT(alugueis.id_aluguel) AS quantidade_alugueis
FROM 
    clientes
LEFT JOIN 
    alugueis ON clientes.id_cliente = alugueis.id_cliente
WHERE 
    data_criacao_conta <= CURRENT_DATE()
GROUP BY 
    clientes.id_cliente, nome_cliente;


-- CASE 9. Preferências de gêneros de filmes por região e sexo dos clientes
SELECT 
    c.regiao,
    c.sexo,
    f.genero,
    COUNT(*) AS quantidade_alugueis
FROM 
    clientes c
JOIN 
    alugueis a ON c.id_cliente = a.id_cliente
JOIN 
    filmes f ON a.id_filme = f.id_filme
GROUP BY 
    c.regiao, c.sexo, f.genero;


-- CASE 9. Popularidade dos filmes por gênero
SELECT 
    genero,
    COUNT(*) AS quantidade_alugueis
FROM 
    filmes
JOIN 
    alugueis ON filmes.id_filme = alugueis.id_filme
GROUP BY 
    genero;

-- CASE 10. Popularidade dos filmes por ano de lançamento
SELECT 
    ano_lancamento,
    COUNT(*) AS quantidade_alugueis
FROM 
    filmes
JOIN 
    alugueis ON filmes.id_filme = alugueis.id_filme
GROUP BY 
    ano_lancamento;
