-- DROP DATABASE IF EXISTS projeto_bd1;
-- CREATE DATABASE projeto_bd1; 
-- USE projeto_bd1;

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';

CREATE SEQUENCE Vacina_id_seq;

CREATE TABLE Vacina(
	ID INT NOT NULL DEFAULT nextval('Vacina_id_seq') PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL UNIQUE,
	Fase VARCHAR(25) NOT NULL,
	Principio VARCHAR(25) NOT NULL
);

ALTER SEQUENCE Vacina_id_seq OWNED BY Vacina.ID;

CREATE SEQUENCE Distribuicao_id_seq;

CREATE TABLE Distribuicao(
	ID INT NOT NULL DEFAULT nextval('Distribuicao_id_seq') PRIMARY KEY,
	Quantidade INTEGER NOT NULL,
	Grupo VARCHAR(25) NOT NULL,
	Data TIMESTAMP NOT NULL,
	Local VARCHAR(25) NOT NULL,
	Vacina INT NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE Acompanhamento_id_seq;

CREATE TABLE Acompanhamento(
	ID INT NOT NULL DEFAULT nextval('Acompanhamento_id_seq') PRIMARY KEY,
	Quantidade INTEGER NOT NULL,
	Status VARCHAR(25) NOT NULL,
	Biotipo VARCHAR(25) NOT NULL,
	Local VARCHAR(25) NOT NULL
);

ALTER SEQUENCE Acompanhamento_id_seq OWNED BY Acompanhamento.ID;

CREATE SEQUENCE Pais_id_seq;

CREATE TYPE continentes AS ENUM ('America-Norte', 'America-Sul', 'Asia', 'Europa', 'Africa', 'Oceania');

CREATE TABLE Pais (
	ID INT NOT NULL DEFAULT nextval('Pais_id_seq') PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL,
	Sigla VARCHAR(3) NOT NULL,
	Continente continentes  NOT NULL
);

ALTER SEQUENCE Pais_id_seq OWNED BY Pais.ID;

CREATE SEQUENCE PassaraPor_id_seq;

CREATE TABLE PassaraPor(
	ID INT NOT NULL DEFAULT nextval('PassaraPor_id_seq') PRIMARY KEY,
	Vacina INT NOT NULL,
	Acompanhamento INT NOT NULL,
	FOREIGN KEY (Vacina) REFERENCES Vacina(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Acompanhamento) REFERENCES Acompanhamento(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(ID, Vacina, Acompanhamento)
);

ALTER SEQUENCE PassaraPor_id_seq OWNED BY PassaraPor.ID;

CREATE SEQUENCE Teste_id_seq;

CREATE TABLE Teste(
	ID INT NOT NULL DEFAULT nextval('Teste_id_seq') PRIMARY KEY,
	Quantidade INTEGER NOT NULL,
	DataInicio TIMESTAMP NOT NULL,
	DataFim TIMESTAMP NOT NULL,
	Local VARCHAR(25) NOT NULL,
	PassaraPor INT,
	FOREIGN KEY (PassaraPor) REFERENCES PassaraPor(ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER SEQUENCE Teste_id_seq OWNED BY Teste.ID;

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
		ON DELETE CASCADE ON UPDATE CASCADE
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

CREATE TABLE Feito(
	Teste INT NOT NULL,
	Pais INT NOT NULL,
	FOREIGN KEY (Teste) REFERENCES Teste(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Pais) REFERENCES Pais(ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(Testes, Pais)
);




