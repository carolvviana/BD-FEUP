.mode columns
.headers on
.nullvalue NULL

-- jogo com mais golos, o jogo com menos golos e respetivas equipas participantes, resultados e data. Média de golos por jogo da época.

select 'Jogo com mais golos' Evento, j.data Data, e1.sigla || ' - ' || e1.nome Visitado , e2.sigla || ' - ' || e2.nome Visitante, golosVisitado || '-' || golosVisitante Resultado, max(golosVisitante+golosVisitado) [Total Golos / Média]
from jogo j 
join equipa e1 on j.idvisitado = e1.idequipa
join equipa e2 on j.idvisitante = e2.idequipa
union
select 'Jogo com menos golos' Evento, j.data, e1.sigla || ' - ' || e1.nome Visitado , e2.sigla || ' - ' || e2.nome Visitante, golosVisitado || '-' || golosVisitante Resultado, min(golosVisitante+golosVisitado) totalgolos
from jogo j 
join equipa e1 on j.idvisitado = e1.idequipa
join equipa e2 on j.idvisitante = e2.idequipa
union
select 'Média de golos' Evento, '-' , '-', '-', '-', round(avg(golosVisitante+golosVisitado), 2) totalgolos
from jogo j;