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
	(DEFAULT, 1500, 'Idosos', current_timestamp, 3, 1),
	(DEFAULT, 2000, 'Adultos', current_timestamp, 4, 3),
	(DEFAULT, 900, 'Profissionais de Saude', current_timestamp, 1, 3),
	(DEFAULT, 1300, 'Grupo de Risco', current_timestamp, 5, 3);

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
