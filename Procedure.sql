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
