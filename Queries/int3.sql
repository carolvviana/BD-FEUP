.mode columns
.headers on
.nullvalue NULL

-- nome e idade dos 10 jogadores que marcaram golos em mais jogos e o número de jogos em que o fizeram

select Nome Nome, Idade Idade, count(marcador) JogosComGolo
from participa p join jogador j on p.idjogador=j.idjogador
where marcador=1
group by p.idjogador
order by JogosComGolo desc
limit 10;