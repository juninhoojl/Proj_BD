-- DROP DATABASE IF EXISTS projeto_bd1;
-- CREATE DATABASE projeto_bd1; 
-- USE projeto_bd1;

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
	Pais INT NOT NULL,
	Quantidade INTEGER NOT NULL,
	DataInicio TIMESTAMP NOT NULL,
	DataFim TIMESTAMP NOT NULL,
	Local VARCHAR(25) NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Pais) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Teste_id_seq OWNED BY Teste.ID;

CREATE TYPE tipostatus AS ENUM ('Ocorrendo', 'Finalizado', 'Abortado', 'Iniciado');
CREATE SEQUENCE Acompanhamento_id_seq;
CREATE TABLE Acompanhamento(
	ID INT NOT NULL DEFAULT nextval('Acompanhamento_id_seq') PRIMARY KEY,
	Teste INT NOT NULL,
	Quantidade INTEGER NOT NULL,
	Status tipostatus NOT NULL,
	Observacoes VARCHAR(50),
	Biotipo grupos NOT NULL,
	Local VARCHAR(25) NOT NULL,
	FOREIGN KEY (Teste) REFERENCES Teste(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE Acompanhamento_id_seq OWNED BY Acompanhamento.ID;

-- ATE AQUI OK

CREATE SEQUENCE Instituicao_id_seq;
CREATE TYPE tipoinsti AS ENUM ('Publica', 'Privada');
CREATE TABLE Instituicao(
	ID INT NOT NULL DEFAULT nextval('Instituicao_id_seq') PRIMARY KEY,
	Tipo tipoinsti NOT NULL,
	Pais INT NOT NULL,
	Nome VARCHAR(25) NOT NULL,
	Local VARCHAR(25) NOT NULL,
	GovOuBenef VARCHAR(25) NOT NULL,
	FOREIGN KEY (Pais) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE(Nome)
);
ALTER SEQUENCE Instituicao_id_seq OWNED BY Instituicao.ID;

CREATE SEQUENCE RelInstVac_id_seq;
CREATE TABLE RelInstVac(
	ID INT NOT NULL DEFAULT nextval('RelInstVac_id_seq') PRIMARY KEY,
	Vacina INT NOT NULL,
	Instituicao INT NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Instituicao) REFERENCES Instituicao(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER SEQUENCE RelInstVac_id_seq OWNED BY RelInstVac.ID;

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
	VALUES (DEFAULT, 'Coronavac', '3', 'Inativada');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'AstraZeneca', '3', 'Toxoide');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES (DEFAULT, 'Pfizer', '3', 'Imunoglobulina');

INSERT INTO Vacina (ID, Nome, Fase, Principio)
	VALUES(DEFAULT, 'Moderna', '3', 'Atenuada');


-- Instituicao

INSERT INTO Instituicao (ID, Tipo, Pais, Nome, Local, GovOuBenef)
	VALUES (DEFAULT, 'Publica', 1, 'UNIFEI', 'Itajuba', 'Federal');

INSERT INTO Instituicao (ID, Tipo, Pais, Nome, Local, GovOuBenef)
	VALUES (DEFAULT, 'Privada', 4, 'Samsung', 'Beijing', 'Samsung Inc.');

INSERT INTO Instituicao (ID, Tipo, Pais, Nome, Local, GovOuBenef)
	VALUES (DEFAULT, 'Publica', 3, 'Oxford', 'Oxford', 'Federal');

INSERT INTO Instituicao (ID, Tipo, Pais, Nome, Local, GovOuBenef)
	VALUES (DEFAULT, 'Publica', 1, 'Barraca Amarela', 'Piranguinho', 'Municipal');

INSERT INTO Instituicao (ID, Tipo, Pais, Nome, Local, GovOuBenef)
	VALUES (DEFAULT, 'Privada', 5, 'Juji TV', 'Minato Tokyo', 'Fuji Media Holdings, Inc.');


-- RelInstVac

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 1, 1);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 1, 2);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 2, 2);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 3, 3);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 4, 4);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 5, 4);

INSERT INTO RelInstVac (ID, Vacina, Instituicao)
	VALUES (DEFAULT, 5, 5);


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



-- REFAZER A PARTIR DAQUI


-- Teste

INSERT INTO Teste (ID, Vacina, Pais, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 1, 1, 1300, current_timestamp, current_timestamp, 'Itajuba');

INSERT INTO Teste (ID, Vacina, Pais, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 2, 2, 5000, current_timestamp, current_timestamp, 'China');

INSERT INTO Teste (ID, Vacina, Pais, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 2, 2, 10000, current_timestamp, current_timestamp, 'Estado de Sao Paulo');

INSERT INTO Teste (ID, Vacina, Pais, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 3, 5, 7000, current_timestamp, current_timestamp, 'Estado do Rio de Janeiro');

INSERT INTO Teste (ID, Vacina, Pais, Quantidade, DataInicio, DataFim, Local)
	VALUES (DEFAULT, 1, 3, 2000, current_timestamp, current_timestamp, 'Ile de France');

-- Acompanhamento


INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Observacoes, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Parece que funciona', 'Profissionais de Saude', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Observacoes, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Morreram todos', 'Idosos', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Observacoes, Biotipo, Local)
	VALUES (DEFAULT, 1, 50, 'Ocorrendo', 'Se recusaram a ser vacinados', 'Adultos', 'Hospital Morto Vivo');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Observacoes, Biotipo, Local)
	VALUES (DEFAULT, 2, 70, 'Ocorrendo', '50% abandonou programa', 'Outro', 'Empresa 1');

INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Observacoes, Biotipo, Local)
	VALUES (DEFAULT, 2, 70, 'Ocorrendo', 'Sem recursos para continuar', 'Adultos', 'Empresa 1');


-- pg_dump -U joseluizjunior -W -F p projeto_bd1 > ~/Documents/Backup_1
