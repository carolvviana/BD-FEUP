.mode columns
.headers on
.nullvalue NULL

-- RESULTADO( V, D, E) DE CADA EQUIPA POR CADA JORNADA. '-' CASO NÃO TENHA JOGADO. 

-- todas as equipas por cada jornada, independentemente se participou em jogo ou não
with BASE as (select * from equipa left outer join jornada)
--resultados como visitante
select BASE.sigla Equipa, BASE.idjornada Jornada, ifnull(j.data, '-') Data, 
case
    when ptsVisitante = 3 then 'V'
    when ptsVisitante = 2 then 'E'
    when ptsVisitante = 1 then 'D'
    else '-'
end as Resultado
from BASE left outer join jogo j on BASE.idequipa = j.idvisitante and BASE.idjornada = j.idjornada
UNION ALL
--resultados como visitado
select BASE.sigla, BASE.idjornada, ifnull(j.data, '-') Data, 
case 
    when ptsVisitado = 3 then 'V'
    when ptsVisitado = 2 then 'E'
    when ptsVisitado = 1 then 'D'
    else '-'
end as Resultado
from BASE left outer join jogo j on BASE.idequipa = j.idvisitado and BASE.idjornada = j.idjornada
--retirar tuplos(equipa, jornada) duplicados, mantendo o que contém a informação que queremos
group by BASE.sigla, BASE.idjornada
having max(Resultado)
order by BASE.sigla, BASE.idjornada, Resultado DESC;