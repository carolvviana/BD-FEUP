.mode columns
.headers on
.nullvalue NULL

-- média das idades dos jogadores da equipa que ficou em 1º lugar nas diferentes jornadas, sigla da equipa respetiva e id da jornada

with medias as (
    --media de idades por equipa
    select e.idequipa, e.sigla , round(avg(j.idade),2) MediaIdades
    from equipa e join jogador j on e.idequipa = j.idequipa
    group by e.idequipa
),
vencedores as (
    --equipa vencedora por jornada
    select idjornada, idequipa
    from resultados
    group by idjornada
    having max(pontos)
)
select v.idjornada Jornada, m.sigla Equipa, m.MediaIdades
from medias m join vencedores v on m.idequipa = v.idequipa
order by Jornada; 