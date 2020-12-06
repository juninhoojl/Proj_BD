
-- pg_dump -U joseluizjunior -W -F p projeto_bd1 > ~/Documents/Backup_2

-- Consultas usando mais de duas tabelas no inner join

-- Lista todas as vacinas mostrando a instrituicao, pais, vacina, fase e principio ativo ordenando pelo nome da vacina (ja que pode ter mais de uma instituicao nela)

SELECT inst.nome AS "Instituicao", pais.nome AS "Pais", vac.nome AS "Vacina", vac.fase AS "Fase", vac.principio AS "Principio"
FROM instituicao AS inst
	INNER JOIN pais AS pais
		ON inst.pais = pais.id
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	INNER JOIN vacina AS vac
		ON rel.vacina = vac.id
	ORDER BY vac.nome ASC;

-- Conta a quantidade de vacinas numa fase x em cada continente e ordena e agrupa por continente
SELECT pais.continente AS "Continente",
	COUNT(CASE WHEN vac.fase = '1' then 1 ELSE NULL END) as "Qtd Fase 1",
	COUNT(CASE WHEN vac.fase = '2' then 1 ELSE NULL END) as "Qtd Fase 2",
	COUNT(CASE WHEN vac.fase = '3' then 1 ELSE NULL END) as "Qtd Fase 3",
	COUNT(vac.fase) as "Qtd Total"
FROM instituicao AS inst
	INNER JOIN pais AS pais
		ON inst.pais = pais.id
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	INNER JOIN vacina AS vac
		ON rel.vacina = vac.id
	GROUP BY pais.continente
	ORDER BY pais.continente ASC;


-- Consultas usando like
-- Lista o nome das instituicoes e local dela caso tenha a string de no meio do nome do governo e ordena pelo nome

SELECT inst.nome AS "Instituicao",
	inst.local AS "Local"
	FROM instituicao as inst
WHERE inst.governo LIKE '%de%'
ORDER BY inst.nome ASC;


-- Lista os lugares dos testes onde o nome do lugar tem pelo menos 11 caracteres e ordena pela quantidade

SELECT vac.nome AS "Vacina",
	teste.quantidade AS "Quantidade",
	teste.local AS "Local"
	FROM teste
	INNER JOIN vacina AS vac
		ON teste.vacina = vac.id
WHERE teste.local LIKE '___________%'
ORDER BY teste.quantidade ASC;


-- Funcao de agregacao usando having
-- Maior quantidade de distribuicao em cada se a menor da cidade for maior que 900
SELECT dist.local AS "Local",
	max(dist.quantidade) AS "Maior quantidade"
	FROM distribuicao AS dist
	GROUP BY dist.local
	HAVING min(dist.quantidade) > 900;

-- Mostra a soma de todas as distribuicoes de cada cidade se a soma for maior que 1900 
-- e ordenando da maior quantidade para a maior
SELECT dist.local AS "Local",
	SUM(dist.quantidade) AS "Total"
	FROM distribuicao AS dist
	GROUP BY dist.local
	HAVING SUM(dist.quantidade) > 1900
	ORDER BY SUM(dist.quantidade) DESC;


-- Junção externa


-- Mostra as informacoes do teste e faz a juncao a direita com a tabela vacina, logo teremos as vacinas sem teste ao final
-- por conta da ordenacao ascendente da data, já que nao existe teste sem vacina, porem existe vacina sem teste
-- entao nao faz nem sentido fazer uma juncao externa full, o resultado seria o mesmo
SELECT
	teste.datainicio AS "Data de Inicio",
	teste.datafim AS "Data de Fim",
	teste.local AS "Local",
	teste.quantidade AS "Quantidade",
	vac.nome AS "Vacina"
FROM teste
RIGHT OUTER JOIN vacina as vac ON (vac.id=teste.vacina)
ORDER BY teste.datafim ASC;


-- Ao fazer o left outer join teremos o mesmo resultado que um join normal já que nao existe teste sem vacina
SELECT
	teste.datainicio AS "Data de Inicio",
	teste.datafim AS "Data de Fim",
	teste.local AS "Local",
	teste.quantidade AS "Quantidade",
	vac.nome AS "Vacina"
FROM teste
LEFT OUTER JOIN vacina as vac ON (vac.id=teste.vacina)
ORDER BY teste.datafim ASC;

-- Divisao

-- Seleciona todas as vacinas que estão na fase 1 que não estão em teste nenhum, mostrando o nome, a fase e o princípio.
SELECT nome AS "Nome", fase AS "Fase", principio AS "Principio"
	FROM vacina WHERE fase = '1'
EXCEPT
SELECT vac.nome, vac.fase, vac.principio
	FROM teste
	INNER JOIN vacina AS vac
		ON teste.vacina = vac.id;

-- Consultas Extra

-- Retorna a porcentagem das vacinas em cada fase na totalidade
SELECT	CAST(COUNT(CASE WHEN vac.fase = '1' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "Porcentagem na Fase 1",
	CAST(COUNT(CASE WHEN vac.fase = '2' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "Porcentagem na Fase 1",
	CAST(COUNT(CASE WHEN vac.fase = '3' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "Porcentagem na Fase 1",
	COUNT(vac.fase) AS "TOTAL"
FROM vacina AS vac

-- Retorna a porcentagem das vacinas em cada fase para cada pais
SELECT pais.nome AS "Pais",
	COUNT(CASE WHEN vac.fase = '1' then 1 ELSE NULL END) AS "Qtd Fase 1",
	CAST(COUNT(CASE WHEN vac.fase = '1' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "% Fase 1",
	COUNT(CASE WHEN vac.fase = '2' then 1 ELSE NULL END) AS "Qtd Fase 2",
	CAST(COUNT(CASE WHEN vac.fase = '2' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "% Fase 2",
	COUNT(CASE WHEN vac.fase = '3' then 1 ELSE NULL END) AS "Qtd Fase 3",
	CAST(COUNT(CASE WHEN vac.fase = '3' then 1 ELSE NULL END) AS FLOAT) / COUNT(vac.fase) AS "% Fase 3",
	COUNT(vac.fase) AS "TOTAL"
FROM instituicao AS inst
	INNER JOIN pais AS pais
		ON inst.pais = pais.id
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	INNER JOIN vacina AS vac
		ON rel.vacina = vac.id
	GROUP BY pais.nome
	ORDER BY pais.nome ASC;
