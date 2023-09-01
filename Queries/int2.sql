.mode columns
.headers on
.nullvalue NULL

--nome dos jogadores menores de idade com nome proprio começado por J

select nome Nome
from jogador
where idade<18
INTERSECT
select nome
from jogador
where nome like "J%";