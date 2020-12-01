-- DROP DATABASE IF EXISTS projeto_bd1;
-- CREATE DATABASE projeto_bd1; 
-- USE projeto_bd1;
-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';

CREATE TYPE principios AS ENUM ('Inativada', 'Toxoide', 'Imunoglobulina', 'Atenuada');
CREATE TYPE fases AS ENUM ('1', '2', '3');
CREATE SEQUENCE Vacina_id_seq;
CREATE TABLE Vacina(
	ID INT NOT NULL DEFAULT nextval('Vacina_id_seq') PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL UNIQUE,
	Fase fases NOT NULL,
	Principio principios NOT NULL,
	UNIQUE(Nome)
);
ALTER SEQUENCE Vacina_id_seq OWNED BY Vacina.ID;

CREATE TYPE grupos AS ENUM ('Criancas', 'Adultos', 'Idosos', 'Profissionais de Saude', 'Grupo de Risco', 'Outro');
CREATE SEQUENCE Distribuicao_id_seq;
CREATE TABLE Distribuicao(
	ID INT NOT NULL DEFAULT nextval('Distribuicao_id_seq') PRIMARY KEY,
	Quantidade INTEGER NOT NULL,
	Grupo grupos NOT NULL,
	Data TIMESTAMP NOT NULL,
	Local VARCHAR(25) NOT NULL,
	Vacina INT NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Distribuicao_id_seq OWNED BY Distribuicao.ID;


CREATE SEQUENCE Pais_id_seq;

CREATE TYPE continentes AS ENUM ('America', 'Asia', 'Europa', 'Africa', 'Oceania', 'Antartida');
CREATE TABLE Pais (
	ID INT NOT NULL DEFAULT nextval('Pais_id_seq') PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL,
	Sigla VARCHAR(3) NOT NULL,
	Continente continentes NOT NULL,
	UNIQUE(Nome),
	UNIQUE(Sigla)
);
ALTER SEQUENCE Pais_id_seq OWNED BY Pais.ID;

CREATE SEQUENCE Teste_id_seq;
CREATE TABLE Teste(
	ID INT NOT NULL DEFAULT nextval('Teste_id_seq') PRIMARY KEY,
	Vacina INT NOT NULL,
	Quantidade INTEGER NOT NULL,
	DataInicio TIMESTAMP NOT NULL,
	DataFim TIMESTAMP NOT NULL,
	Local VARCHAR(25) NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Teste_id_seq OWNED BY Teste.ID;


CREATE TABLE RelTestPai(
	Teste INT NOT NULL,
	Pais INT NOT NULL,
	PRIMARY KEY(Teste, Pais),
	FOREIGN KEY (Teste) REFERENCES Teste(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Pais) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TYPE tipostatus AS ENUM ('Ocorrendo', 'Finalizado', 'Abortado', 'Iniciado');
CREATE SEQUENCE Acompanhamento_id_seq;
CREATE TABLE Acompanhamento(
	ID INT NOT NULL DEFAULT nextval('Acompanhamento_id_seq') PRIMARY KEY,
	Teste INT NOT NULL,
	Quantidade INTEGER NOT NULL,
	Status tipostatus NOT NULL,
	Biotipo grupos NOT NULL,
	Local VARCHAR(25) NOT NULL,
	FOREIGN KEY (Teste) REFERENCES Teste(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Acompanhamento_id_seq OWNED BY Acompanhamento.ID;

CREATE SEQUENCE Instituicao_id_seq;
CREATE TABLE Instituicao(
	ID INT NOT NULL DEFAULT nextval('Instituicao_id_seq') PRIMARY KEY,
	Pais INT NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Local VARCHAR(25) NOT NULL,
	Governo VARCHAR(25),
	Beneficiario VARCHAR(25),
	FOREIGN KEY (Pais) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE(Nome)
);
ALTER SEQUENCE Instituicao_id_seq OWNED BY Instituicao.ID;


CREATE TABLE RelInstVac(
	Vacina INT NOT NULL,
	Instituicao INT NOT NULL,
	PRIMARY KEY(Vacina, Instituicao),
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Instituicao) REFERENCES Instituicao(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RelVacTestAcom(
	Vacina INT NOT NULL,
	Teste INT NOT NULL,
	Acompanhamento INT NOT NULL,
	PRIMARY KEY(Vacina, Teste, Acompanhamento),
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Teste) REFERENCES Teste(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Acompanhamento) REFERENCES Acompanhamento(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Pais
INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'Brasil', 'BR', 'America');

INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'Argentina', 'AR', 'America');

INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'Estados Unidos', 'US', 'America');

INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'Alemanha', 'DL', 'Europa');

INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'China', 'CH', 'Asia');

INSERT INTO Pais (ID, Nome, Sigla, Continente)
	VALUES (DEFAULT, 'Japao', 'JP', 'Asia');

-- Vacina

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'Sinovac', '3', 'Inativada');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'Coronavac', '1', 'Inativada');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'AstraZeneca', '2', 'Toxoide');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'Pfizer', '1', 'Imunoglobulina');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES(DEFAULT, 'Moderna', '3', 'Atenuada');

-- Instituicao

INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario)
	VALUES (DEFAULT, 1, 'UNIFEI', 'Itajuba', 'Federal', '');

INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario)
	VALUES (DEFAULT, 4, 'Samsung', 'Beijing', '', 'Samsung Inc.');

INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario)
	VALUES (DEFAULT, 3, 'Oxford', 'Oxford', 'Federal', '');

INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario)
	VALUES (DEFAULT, 1, 'Barraca Amarela', 'Piranguinho', '', 'Doces 123');

INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario)
	VALUES (DEFAULT, 5, 'Juji TV', 'Minato Tokyo', '', 'Fuji Media Holdings, Inc.');

-- RelInstVac

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (1, 1);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (1, 2);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (2, 2);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (3, 3);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (4, 4);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (5, 4);

INSERT INTO RelInstVac (Vacina, Instituicao)
	VALUES (5, 5);


-- Distribuicao

INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina)
	VALUES (DEFAULT, 1000, 'Criancas', current_timestamp, 'Itajuba', 1);

INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina)
	VALUES (DEFAULT, 1500, 'Idosos', current_timestamp, 'Piranguinho', 1);

INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina)
	VALUES (DEFAULT, 2000, 'Adultos', current_timestamp, 'Campos do Jordao', 3);

INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina)
	VALUES (DEFAULT, 900, 'Profissionais de Saude', current_timestamp, 'Cristina', 3);

INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina)
	VALUES (DEFAULT, 1300, 'Grupo de Risco', current_timestamp, 'Itajuba', 3);


-- Teste

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 1, 1300, current_timestamp, current_timestamp, 'Itajuba');

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 2, 5000, current_timestamp, current_timestamp, 'China');

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 2, 10000, current_timestamp, current_timestamp, 'Estado de Sao Paulo');

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 3, 7000, current_timestamp, current_timestamp, 'Estado do Rio de Janeiro');

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 1, 2000, current_timestamp, current_timestamp, 'Ile de France');


-- RelTestPai

INSERT INTO RelTestPai (Teste, Pais)
	VALUES (1, 1);

INSERT INTO RelTestPai (Teste, Pais)
	VALUES (2, 1);

INSERT INTO RelTestPai (Teste, Pais)
	VALUES (2, 2);

INSERT INTO RelTestPai (Teste, Pais)
	VALUES (3, 3);

INSERT INTO RelTestPai (Teste, Pais)
	VALUES (4, 5);

-- Acompanhamento

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Profissionais de Saude', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Idosos', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Adultos', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (DEFAULT, 2, 70, 'Ocorrendo', 'Outro', 'Empresa 1');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (DEFAULT, 2, 70, 'Ocorrendo', 'Adultos', 'Empresa 1');


-- RelTestPai

INSERT INTO RelVacTestAcom (Vacina, Teste, Acompanhamento)
	VALUES (1, 1, 2);

INSERT INTO RelVacTestAcom (Vacina, Teste, Acompanhamento)
	VALUES (1, 2, 1);

INSERT INTO RelVacTestAcom (Vacina, Teste, Acompanhamento)
	VALUES (2, 3, 4);

INSERT INTO RelVacTestAcom (Vacina, Teste, Acompanhamento)
	VALUES (3, 4, 5);

INSERT INTO RelVacTestAcom (Vacina, Teste, Acompanhamento)
	VALUES (4, 4, 3);

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


-- Extra

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


-- Divisao

--  Seleciona todas as vacinas que estao na fase 1 que nao estao em teste nenhum

SELECT nome AS "Nome", fase AS "Fase", principio AS "Principio"
	FROM vacina WHERE fase = '1'
EXCEPT
SELECT vac.nome, vac.fase, vac.principio
	FROM teste
	INNER JOIN vacina AS vac
		ON teste.vacina = vac.id;







