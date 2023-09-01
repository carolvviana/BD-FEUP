PRAGMA foreign_keys=ON;
drop trigger if exists InsJogo;

--Adiciona registos à tabela resultados baseados na inserção de jogos
create trigger InsJogo
after insert on jogo
for each row
begin
    --equipa visitante =========================================================================================================
    insert into PTSVISITANTE(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitante = new.idvisitante) 
            THEN
                (select sum(ptsVisitante) pontos1 
                from jogo
                where idvisitante = new.idvisitante
                group by idvisitante)
            ELSE
                0
        END;
    insert into PTSVISITADO(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitado = new.idvisitante) 
            THEN
                (select sum(ptsVisitado) pontos1
                from jogo
                where idvisitado = new.idvisitante
                group by idvisitado)
            ELSE
                0
        END;

    insert into resultados(idresultados, pontos, idjornada, idequipa)
    select NULL idresultados, (V.pontos + H.pontos) pontos, new.idjornada, new.idvisitante
    from PTSVISITANTE V join PTSVISITADO H;

    delete from PTSVISITANTE;
    delete from PTSVISITADO;
    --equipa visitada ======================================================================================================================
    insert into PTSVISITANTE(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitante = new.idvisitado)
            THEN
                (select sum(ptsVisitante) pontos1 
                from jogo
                where idvisitante = new.idvisitado
                group by idvisitante)
            ELSE
                0
        END;
    insert into PTSVISITADO(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitado = new.idvisitado)
            THEN
                (select sum(ptsVisitado) pontos1
                from jogo
                where idvisitado = new.idvisitado
                group by idvisitado)
            ELSE
                0
        END;

    insert into resultados(idresultados, pontos, idjornada, idequipa)
    select NULL idresultados, (V.pontos + H.pontos) pontos, new.idjornada, new.idvisitado
    from PTSVISITANTE V join PTSVISITADO H;

    delete from PTSVISITANTE;
    delete from PTSVISITADO;
end;