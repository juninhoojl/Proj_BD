
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

-- Gatilho: ao ser inserido um registro em relvactestacom, este gatilho verifica se a Vacina inserida é de Fase 3
-- caso o grupo prioritário seja 'Grupo de Risco'
CREATE OR REPLACE FUNCTION gatilho_grupo_fase() RETURNS trigger AS $$
DECLARE
	fase_vacina INT := (SELECT fase FROM Vacina Vac WHERE Vac.id = NEW.vacina);
	grupo grupos := (SELECT biotipo FROM Acompanhamento Ac WHERE Ac.id = NEW.acompanhamento);
BEGIN
	IF fase_vacina < 3 AND grupo = 'Grupo de Risco' THEN 
		RAISE EXCEPTION 'Vacina de fase % não pode ser testada em Grupo de Risco.', fase_vacina;
	END IF;
	
	RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER gatilho_grupo_fase AFTER INSERT ON relvactestacom
	FOR EACH ROW EXECUTE PROCEDURE gatilho_grupo_fase();

/* PARA GERAR O EXCEPTION

INSERT INTO Teste (ID, Vacina, Quantidade, DataInicio, DataFim, Local)
	VALUES (10, 3, 2000, current_timestamp, current_timestamp, 1);
	
INSERT INTO Acompanhamento (ID, Teste, Quantidade, Status, Biotipo, Local)
	VALUES (10, 10, 70, 'Ocorrendo', 'Grupo de Risco', 'Hospital Morto Vivo');

INSERT INTO RelVacTestAcom(Vacina, Teste, Acompanhamento)
	VALUES (1, 10, 10);




-- Para apagar refazer o teste
DELETE FROM RelVacTestAcom WHERE acompanhamento = 6
*/
