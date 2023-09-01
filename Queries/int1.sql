.mode columns
.headers on
.nullvalue NULL

-- sigla, nome e pontuação da equipas que vão às competições europeias no final da época

select sigla Sigla, nome Nome, max(pontos) Pontos
from resultados r join equipa e on e.idequipa=r.idequipa
group by r.idequipa
order by Pontos desc
limit 5;