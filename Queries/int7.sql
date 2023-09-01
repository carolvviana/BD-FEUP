.mode columns
.headers on
.nullvalue NULL

-- sigla e totais de golos marcados e sofridos por cada equipa na época

select e1 as Equipa, vgolos + hgolos as Marcados, vcontra + hcontra as Sofridos
from (
--golos marcados pelas equipas como visitantes
select e.sigla e1, sum(j.golosVisitante) as vgolos, sum(j.golosVisitado) as vcontra
from equipa e, jogo j
where e.idequipa = j.idvisitante
group by j.idvisitante) join (
--golos marcados pelas equipas como visitados
select e.sigla e2, sum(j.golosVisitado) as hgolos, sum(j.golosVisitante) as hcontra
from equipa e, jogo j
where e.idequipa = j.idvisitado
group by j.idvisitado) on e1 = e2; 
