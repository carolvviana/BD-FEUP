PRAGMA foreign_keys=ON;
drop trigger if exists InsParticipante;

create trigger InsParticipante
before insert on participa
for each row
when (new.idjogador not in (select pl.idjogador as P
                        from jogo j, jogador pl
                        where pl.idequipa = j.idvisitante and j.idjogo = new.idjogo
                        union
                        select pl.idjogador as P
                        from jogo j, jogador pl
                        where pl.idequipa = j.idvisitado and j.idjogo = new.idjogo))
begin
    select raise(abort, "Jogador não pertence a nenhuma das equipas envolvidas no jogo");
end;