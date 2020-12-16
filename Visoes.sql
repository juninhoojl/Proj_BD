-- View atualizável e atualizada

CREATE VIEW vinstituicoes AS
	SELECT *
	FROM instituicao
	WHERE instituicao.governo LIKE '%Federal%';

-- Vizualizamos a view
SELECT * FROM vinstituicoes;


-- Inserimos um valor pela view para verificar se é atualizável
INSERT INTO vinstituicoes VALUES (DEFAULT, 1, 'Abcde', 'Campinas', 'Federal', '');

-- Garantimos que foi atulizada
SELECT * FROM instituicao;

-- View materializada (Cria uma tabela real)

CREATE MATERIALIZED VIEW vvacinafase3brasil AS SELECT 
inst.nome AS "Instituicao", pais.nome AS "Pais", vac.nome AS "Vacina", vac.fase AS "Fase", vac.principio AS "Principio"
FROM instituicao AS inst 
	INNER JOIN pais AS pais
		ON inst.pais = pais.id
	INNER JOIN RelInstVac AS rel
		ON rel.instituicao = inst.id
	INNER JOIN vacina AS vac
		ON rel.vacina = vac.id
	WHERE vac.fase = '3' AND pais.nome = 'Brasil';

select * from vvacinafase3brasil;

