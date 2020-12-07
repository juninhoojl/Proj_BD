# i) Junção externa

-- Lista nome da instituicao e pais que pertence
-- fazendo uma juncao externa a esquerda
-- ordenando pelo nome do pais

SELECT
	inst.nome AS "Instituicao",
	pais.nome AS "Pais"
FROM pais
LEFT OUTER JOIN instituicao as inst ON (inst.id=pais.id)
ORDER BY pais.nome ASC;

# ii) Seleção com like

-- Lista nome da vacina, local de teste, principio ativo e quantidade de teste
-- para as vacinas que tenham menos de 5000 testes e o nome contenha a letra v
-- e ordena de acordo com o nome do local

SELECT vac.nome AS "Vacina", vac.principio AS "Principio",
	teste.local AS "Local", teste.quantidade AS "Quantidade"
	FROM teste
	INNER JOIN vacina AS vac
		ON teste.vacina = vac.id
WHERE teste.quantidade < 5000 AND vac.nome LIKE '%v%'
ORDER BY teste.local ASC;

# iii) Função de agregação

-- Lista a quantidade de vacinas que cada instituicao esta relacionad
-- agregando as instituicoes e ordenando pelo nome

SELECT inst.nome AS "Intituicoes",
	COUNT(rel.instituicao) AS "Quantidade"
FROM instituicao AS inst
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	GROUP BY inst.nome
	ORDER BY inst.nome ASC;

# iv) Função de agregação com having

-- Lista local de teste e quantidade de teste
-- agregando a menor quantidade de testes 
-- de acordo com os locais que tenham o maximo menor que 5000

SELECT teste.local AS "Local",
	min(teste.quantidade) AS "Menor quantidade"
	FROM teste
	GROUP BY teste.local
	HAVING max(teste.quantidade) < 5000;

# v) Junção interna com mais de duas tabelas

-- Lista a quantidade de vacinas e diferentes instituicoes que estao atuando em cada continente
-- ordenado pelo nome do continente

SELECT pais.continente AS "Pais",
	COUNT(CASE WHEN vac.fase = '1' then 1 ELSE NULL END) AS "Qtd Fase 1",
	COUNT(CASE WHEN vac.fase = '2' then 1 ELSE NULL END) AS "Qtd Fase 2",
	COUNT(CASE WHEN vac.fase = '3' then 1 ELSE NULL END) AS "Qtd Fase 3",
	COUNT(inst.nome) AS "Intituicoes",
	COUNT(vac.fase) AS "TOTAL"
FROM instituicao AS inst
	INNER JOIN pais AS pais
		ON inst.pais = pais.id
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	INNER JOIN vacina AS vac
		ON rel.vacina = vac.id
	GROUP BY pais.continente
	ORDER BY pais.continente ASC;


# vi) Operador de conjunto (union ou insertct ou except)

-- Apresenta a unicao dos locais de teste e de distribuicao
-- mostrando somente os locais que possuem mais de um caractere de tamanho de nome (os da distribuicao)
-- ordena de maeira invertida de acordo com o nome do local

SELECT local FROM teste
	UNION
SELECT local FROM distribuicao
WHERE local LIKE '__%'
ORDER BY local DESC;


# vii)Junção natural

-- Lista os nomes das vacinas, quantidade de teste, fase e local
-- somente das que tem mais de 2000 testes
-- e ordena com base no nome da vacina
-- essa operacao poderia ter sido feita usando inner join tambem

SELECT vac.nome AS "Vacina",
	teste.quantidade AS "Quantidade",
	teste.local AS "Local",
	vac.fase AS "Fase"
FROM teste
NATURAL JOIN vacina AS vac
	WHERE quantidade > 2000
ORDER BY vac.nome DESC;

# viii) Consulta aninhada com ‘=’

-- Retorna nome da vacina, quantidade e local para os registros da teste
-- porem somente os que quando o local e quantidade sao iguais
-- ou seja  temos os testes que estao utilizando toda a quantidade de distriuicao recebida
-- por eles mesmos e estao testando nesse mesmo local

SELECT vac.nome AS "Vacina",
	teste.quantidade AS "Quantidade",
	teste.local AS "Local"
FROM teste
INNER JOIN vacina AS vac
		ON teste.vacina = vac.id
WHERE EXISTS (SELECT * FROM distribuicao AS "dist" WHERE teste.quantidade = dist.quantidade and teste.local = dist.local)
ORDER BY vac.nome DESC;

# ix) Consulta aninhada com in ou not in

-- Retorna nome da vacina, quantidade e local para os registros da teste
-- porem somente os que os locais nao existem na dsitribuiscao e ordena pela quantidade
-- ou seja, vamos ter os locais que estao sendo testados porem nao receberam a distribuicao diretamente

SELECT vac.nome AS "Vacina",
	teste.quantidade AS "Quantidade",
	teste.local AS "Local"
FROM teste
INNER JOIN vacina AS vac
		ON teste.vacina = vac.id
WHERE local NOT IN (SELECT local FROM distribuicao)
ORDER BY teste.quantidade ASC;

# x) Divisão

SELECT p.nome 
	FROM pais p
		WHERE (SELECT COUNT(DISTINCT d.vacina) 
	FROM distribuicao d 
		WHERE d.local = p.id) = (SELECT COUNT(*) FROM vacina)







