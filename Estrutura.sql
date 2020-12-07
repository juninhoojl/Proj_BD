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

