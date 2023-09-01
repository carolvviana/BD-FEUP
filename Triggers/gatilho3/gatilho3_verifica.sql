select * from resultados order by idresultados desc;
select * from participa where idjogo = 110;
select * from jogo order by idjogo desc;

delete from jogo where idjogo = 1; --falha
delete from jogo where idjogo = 110;

select * from jogo order by idjogo desc;
select * from participa where idjogo = 110;
select * from resultados order by idresultados desc;