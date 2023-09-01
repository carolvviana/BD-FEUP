PRAGMA foreign_keys=ON;
drop trigger if exists RemJogo;

--apaga resgistos na tabela resultados e participa baseados na remoção de um jogo
create trigger RemJogo
before delete on jogo
for each row
begin
    with max as (
    select max(idjornada) as MAXJ
    from jogo)
    

    select
        CASE
            WHEN (old.idjornada < MAXJ)
            THEN raise(abort, "Só é permitido remover jogos por ordem decrescente de jornada") 
        end
    from max;
    
    --este código só é executado se o trigger não tiver sido abortado pela instrução anterior
    --apagar registos na tabela resultados
    delete from resultados  where idjornada=old.idjornada and idequipa=old.idvisitante;
    delete from resultados  where idjornada=old.idjornada and idequipa=old.idvisitado;
    --apaga registos na tabela jogo
    delete from participa where idjogo = old.idjogo;
end;