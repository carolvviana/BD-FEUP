.mode columns
.headers on
.nullvalue NULL

-- percentagem das equipas cuja sigla não é de 3 caracteres

select nrSiglas*100.0/count(distinct sigla) Percentagem
from equipa, (
select count(sigla) nrSiglas
from equipa
where sigla not in(
select sigla
from equipa
where sigla like "___"));