PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS RESULTADOS;
DROP TABLE IF EXISTS PARTICIPA;
DROP TABLE IF EXISTS JOGO;
DROP TABLE IF EXISTS EQUIPA;
DROP TABLE IF EXISTS JOGADOR;
DROP TABLE IF EXISTS JORNADA;
DROP TABLE IF EXISTS PTSVISITANTE;
DROP TABLE IF EXISTS PTSVISITADO;
DROP TABLE IF EXISTS EQUIPA;


CREATE TABLE JORNADA (
 idjornada INT NOT NULL UNIQUE,
 numero INT CHECK(numero>0 and numero<=30),
 PRIMARY KEY(idjornada)
);

CREATE TABLE EQUIPA (
 idequipa INT NOT NULL UNIQUE,
 nome VARCHAR(255),
 sigla VARCHAR(5),
 PRIMARY KEY(idequipa)
);

CREATE TABLE RESULTADOS (
 idresultados INTEGER PRIMARY KEY UNIQUE,
 idjornada INT NOT NULL,
 idequipa INT NOT NULL,
 pontos INT NOT NULL CHECK(pontos>=0),
 FOREIGN KEY(idequipa) REFERENCES EQUIPA(idequipa),
 FOREIGN KEY(idjornada) REFERENCES JORNADA(idjornada),
 UNIQUE (idjornada, idequipa)
);

CREATE TABLE JOGO (
 idjogo INTEGER PRIMARY KEY UNIQUE,
 hora TIME,
 data VARCHAR(255),
 golosVisitante INT CHECK(golosVisitante>=0),
 golosVisitado INT CHECK(golosVisitado>=0),
 idjornada INT NOT NULL,
 idvisitante INT NOT NULL,
 idvisitado INT NOT NULL,
 local VARCHAR(255),
 ptsVisitado INT CHECK(ptsVisitado>=0 AND ptsVisitado<=3),
 ptsVisitante INT CHECK(ptsVisitante>=0 AND ptsVisitante<=3),
 FOREIGN KEY(idvisitante) REFERENCES EQUIPA(idequipa),
 FOREIGN KEY(idjornada) REFERENCES JORNADA(idjornada),
 UNIQUE (idjornada, idvisitante),
 UNIQUE (idjornada, idvisitado),
 FOREIGN KEY(idvisitado) REFERENCES EQUIPA(idequipa)
);

CREATE TABLE JOGADOR (
 idjogador INT NOT NULL UNIQUE,
 nome VARCHAR(255),
 idade CHAR(2) CHECK(idade>=0),
 nacionalidade VARCHAR(255),
 numero INT CHECK(numero>=0 AND numero<=99),
 posicao VARCHAR(255) CHECK(posicao = 'goalkeeper' OR posicao = 'centre back' OR posicao = 'line player' OR posicao = 'left back' OR posicao = 'right wing' OR posicao = 'left wing' ),
 idequipa INT NOT NULL,
 PRIMARY KEY(idjogador),
 FOREIGN KEY(idequipa) REFERENCES EQUIPA(idequipa),
 UNIQUE (idjogador, idequipa)
);

CREATE TABLE PARTICIPA (
 idjogador INT NOT NULL,
 idjogo INT NOT NULL,
 marcador INT NOT NULL CHECK(marcador=0 OR marcador=1),
 PRIMARY KEY(idjogador,idjogo),
 FOREIGN KEY(idjogo) REFERENCES JOGO(idjogo),
 FOREIGN KEY(idjogador) REFERENCES JOGADOR(idjogador)
);

--tabelas auxiliares
CREATE TABLE PTSVISITANTE(
pontos integer
);
CREATE TABLE PTSVISITADO(
pontos integer
);

--TRIGGER RESTRIÇÃO #1
drop trigger if exists ValidaJornada;
--trigger que verifica se os jogos são inseridos na ordem de jornada certa
create trigger ValidaJornada
before insert on jogo
for each row
begin
    with max as (
    select max(idjornada) as MAXJ
    from jogo)

    select
        CASE
            WHEN (new.idjornada < MAXJ)
            THEN raise(abort, "Impossível inserir jogo relativo a uma jornada antiga")
        end
    from max;
end;

drop trigger if exists InsJogo;
--Adiciona registos à tabela resultados baseados na inserção de jogos
create trigger InsJogo
after insert on jogo
for each row
begin
    --equipa visitante =========================================================================================================
    insert into PTSVISITANTE(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitante = new.idvisitante) 
            THEN
                (select sum(ptsVisitante) pontos1 
                from jogo
                where idvisitante = new.idvisitante
                group by idvisitante)
            ELSE
                0
        END;
    insert into PTSVISITADO(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitado = new.idvisitante) 
            THEN
                (select sum(ptsVisitado) pontos1
                from jogo
                where idvisitado = new.idvisitante
                group by idvisitado)
            ELSE
                0
        END;

    insert into resultados(idresultados, pontos, idjornada, idequipa)
    select NULL idresultados, (V.pontos + H.pontos) pontos, new.idjornada, new.idvisitante
    from PTSVISITANTE V join PTSVISITADO H;

    delete from PTSVISITANTE;
    delete from PTSVISITADO;
    --equipa visitada ======================================================================================================================
    insert into PTSVISITANTE(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitante = new.idvisitado) 
            THEN
                (select sum(ptsVisitante) pontos1 
                from jogo
                where idvisitante = new.idvisitado
                group by idvisitante)
            ELSE
                0
        END;
    insert into PTSVISITADO(pontos)
    select
        CASE
            WHEN
                EXISTS (select 1 from jogo where idvisitado = new.idvisitado)
            THEN
                (select sum(ptsVisitado) pontos1
                from jogo
                where idvisitado = new.idvisitado
                group by idvisitado)
            ELSE
                0
        END;

    insert into resultados(idresultados, pontos, idjornada, idequipa)
    select NULL idresultados, (V.pontos + H.pontos) pontos, new.idjornada, new.idvisitado
    from PTSVISITANTE V join PTSVISITADO H;

    delete from PTSVISITANTE;
    delete from PTSVISITADO;
end;

--TRIGGER RESTRIÇÃO #2
drop trigger if exists UpdateJogo;
--impede a alteração de registos na tabela resultados
create trigger UpdateJogo
before update on jogo
for each row
begin
select
    raise(abort, "Não é permitido alterar registos na tabela jogo. Se necessário, proceda à remoção e inserção.");
end;

COMMIT;
