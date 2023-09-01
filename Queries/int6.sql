.mode columns
.headers on
.nullvalue NULL

--nome, posição e nacionalidade dos jogadores que marcaram golos em todos os jogos em que participaram

select j.nome Nome, j.nacionalidade Nacionalidade, j.posicao Posição
from (
select j1
from (
select idjogador j1, count(idjogo) nrjogos
from participa
group by idjogador)
join
(select idjogador j2, count(marcador) jogosmarcados
from participa
where marcador=1
group by idjogador) on j1=j2
where nrjogos=jogosmarcados) res join jogador j on res.j1=j.idjogador;