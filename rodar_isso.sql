DROP DATABASE IF EXISTS projeto_bd1;
CREATE DATABASE projeto_bd1; 
USE projeto_bd1;
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

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

CREATE TYPE grupos AS ENUM ('Todos', 'Criancas', 'Adultos', 'Idosos', 'Profissionais de Saude', 'Grupo de Risco', 'Outro');
CREATE SEQUENCE Distribuicao_id_seq;
CREATE TABLE Distribuicao(
	ID INT NOT NULL DEFAULT nextval('Distribuicao_id_seq') PRIMARY KEY,
	Quantidade INTEGER NOT NULL,
	Grupo grupos NOT NULL,
	Data TIMESTAMP NOT NULL,
	Local INT NOT NULL,
	Vacina INT NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Local) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Distribuicao_id_seq OWNED BY Distribuicao.ID;

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
INSERT INTO Pais (ID, Nome, Sigla, Continente) VALUES 
	(DEFAULT, 'Brasil', 'BR', 'America'),
	(DEFAULT, 'Argentina', 'AR', 'America'),
	(DEFAULT, 'Estados Unidos', 'US', 'America'),
	(DEFAULT, 'Alemanha', 'DL', 'Europa'),
	(DEFAULT, 'China', 'CH', 'Asia'),
	(DEFAULT, 'Japao', 'JP', 'Asia');

-- Vacina
INSERT INTO Vacina (ID, Nome, Fase, Principio) VALUES 
	(DEFAULT, 'Sinovac', '3', 'Inativada'),
	(DEFAULT, 'Coronavac', '2', 'Inativada'),
	(DEFAULT, 'AstraZeneca', '2', 'Toxoide'),
	(DEFAULT, 'Pfizer', '3', 'Imunoglobulina'),
	(DEFAULT, 'Moderna', '3', 'Atenuada');

-- Instituicao
INSERT INTO Instituicao (ID, Pais, Nome, Local, Governo, Beneficiario) VALUES 
	(DEFAULT, 1, 'UNIFEI', 'Itajuba', 'Federal', ''),
	(DEFAULT, 4, 'Samsung', 'Beijing', '', 'Samsung Inc.'),
	(DEFAULT, 3, 'Oxford', 'Oxford', 'Federal', ''),
	(DEFAULT, 1, 'Barraca Amarela', 'Piranguinho', '', 'Doces 123'),
	(DEFAULT, 5, 'Juji TV', 'Minato Tokyo', '', 'Fuji Media Holdings, Inc.');

-- RelInstVac
INSERT INTO RelInstVac (Vacina, Instituicao) VALUES 
	(1, 1),
	(1, 2),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 4),
	(5, 5);

-- Distribuicao
INSERT INTO Distribuicao (ID, Quantidade, Grupo, Data, Local, Vacina) VALUES
	(DEFAULT, 1000, 'Criancas', current_timestamp, 1, 1),
	(DEFAULT, 1500, 'Idosos', current_timestamp, 1, 2),
	(DEFAULT, 2000, 'Adultos', current_timestamp, 1, 3),
	(DEFAULT, 900, 'Profissionais de Saude', current_timestamp, 1, 4),
	(DEFAULT, 1300, 'Idosos', current_timestamp, 1, 5),
	(DEFAULT, 1000, 'Criancas', current_timestamp, 1, 1),
	(DEFAULT, 1500, 'Idosos', current_timestamp, 3, 1),
	(DEFAULT, 2000, 'Adultos', current_timestamp, 4, 3),
	(DEFAULT, 900, 'Profissionais de Saude', current_timestamp, 1, 3),
	(DEFAULT, 1300, 'Profissionais de Saude', current_timestamp, 5, 3);	

-- Teste
INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local) VALUES 
	(DEFAULT, 1, 1300, current_timestamp, current_timestamp, 'Itajuba'),
	(DEFAULT, 2, 5000, current_timestamp, current_timestamp, 'China'),
	(DEFAULT, 2, 10000, current_timestamp, current_timestamp, 'Estado de Sao Paulo'),
	(DEFAULT, 3, 7000, current_timestamp, current_timestamp, 'Estado do Rio de Janeiro'),
	(DEFAULT, 1, 2000, current_timestamp, current_timestamp, 'Ile de France');

-- RelTestPai
INSERT INTO RelTestPai (Teste, Pais) VALUES 
	(1, 1),
	(2, 1),
	(2, 2),
	(3, 3),
	(4, 5);

-- Acompanhamento
INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local) VALUES 
	(DEFAULT, 1, 50, 'Ocorrendo', 'Profissionais de Saude', 'Hospital Morto Vivo'),
	(DEFAULT, 1, 50, 'Ocorrendo', 'Idosos', 'Hospital Morto Vivo'),
	(DEFAULT, 1, 50, 'Ocorrendo', 'Adultos', 'Hospital Morto Vivo'),
	(DEFAULT, 2, 70, 'Ocorrendo', 'Outro', 'Empresa 1'),
	(DEFAULT, 2, 70, 'Ocorrendo', 'Adultos', 'Empresa 1');

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

-- Função: ela rebece um id de Vacina de Fase 3 e a quantidade de vacina que deseja distribuir em cada um dos países
-- que não possui uma vacina de Fase 3 distribuída
CREATE OR REPLACE FUNCTION semDistr_pais(Vac INT, Qtd INT) 
RETURNS VOID AS $$
DECLARE
	pais_sem INT;
	fase INT := (SELECT Fase FROM Vacina WHERE id = Vac);
BEGIN
	IF fase = 3 THEN
		FOR pais_sem IN
			SELECT id FROM Pais WHERE nome NOT IN 
				(SELECT p.nome FROM Distribuicao d, Pais p WHERE d.local = p.id AND vacina = 3) 
			LOOP
			INSERT INTO Distribuicao VALUES (DEFAULT, Qtd, 'Todos', CURRENT_TIMESTAMP, pais_sem, Vac);
		END LOOP;
	ELSE
		RAISE EXCEPTION 'Vacina de fase % não pode ser testada em Grupo de Risco.', fase;
	END IF;
END;

$$ LANGUAGE plpgsql;

-- Para adicionar Vacina de Fase 3 em países que não possui Vacinas de Fase 3 distribuída
-- SELECT semDistr_pais(1, 2500)

-- Para gerar um erro quando não é atribuído uma Vacina de Fase 3
-- SELECT semDistr_pais(3, 2500);


