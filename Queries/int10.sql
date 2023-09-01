.mode columns
.headers on
.nullvalue NULL

-- DIFERENÇA ENTRE A PERCENTAGEM DE JOGOS EM QUE OS JOGADORES DO FCP, EM MÉDIA, MARCARAM GOLO E A PERCENTAGEM DE JOGOS EM QUE CADA JOGADOR, EM MÉDIA, MARCOU GOLO

drop view if exists FCP_jogos_goleados;
drop view if exists percentagem_jogos_goleados;

create view if not exists FCP_jogos_goleados as 
select j1, round(jogosgoleados*100.0/nrjogos,2) percentagem_jogos_goleados
from (
/*nr jogos de cada jogador do fcp*/
select jogador.idjogador j1, count(participa.idjogo) nrjogos
from jogador, equipa, participa
where jogador.idequipa=equipa.idequipa and equipa.sigla="FCP" and participa.idjogador=jogador.idjogador
group by jogador.idjogador
order by jogador.idjogador) t1
join
(
/*nr jogos de cada jogador do fcp onde marcou golo*/
select jogador.idjogador j2, count(participa.marcador) jogosgoleados
from jogador, equipa, participa
where jogador.idequipa=equipa.idequipa and equipa.sigla="FCP" and participa.idjogador=jogador.idjogador and marcador=1
group by jogador.idjogador
order by jogador.idjogador) t2 on j1=j2
group by j1;

create view if not exists percentagem_jogos_goleados as
select j1, round(jogosgoleados*100.0/nrjogos,2) percentagem_jogos_goleados
from(
/*nr jogos de cada jogador*/
(select jogador.idjogador j1, count(participa.idjogo) nrjogos
from jogador, equipa, participa
where jogador.idequipa=equipa.idequipa and participa.idjogador=jogador.idjogador
group by jogador.idjogador
order by jogador.idjogador) t1
join
(
/*nr jogos de cada jogador onde marcou golo*/
select jogador.idjogador j2, count(participa.marcador) jogosgoleados
from jogador, equipa, participa
where jogador.idequipa=equipa.idequipa and participa.idjogador=jogador.idjogador and marcador=1
group by jogador.idjogador
order by jogador.idjogador) t2 on j1=j2);

select round(avg2-avg1,2) as Diferença
from(
(select round(avg(percentagem_jogos_goleados),2) avg1
from FCP_jogos_goleados)
join(
select round(avg(percentagem_jogos_goleados),2) avg2
from percentagem_jogos_goleados));