-- ============================================================
-- PROJETO: Organização de Eventos com Inscrições
-- BASE DE DADOS: UMGW (MySQL)
-- ============================================================

-- 1. LIMPEZA INICIAL
DROP DATABASE IF EXISTS UMGW;
CREATE DATABASE UMGW;
USE UMGW;

-- ------------------------------------------------------------
-- 2. CRIAÇÃO DAS TABELAS (Ponto 5.1)
-- ------------------------------------------------------------

CREATE TABLE JOGO (
    id_jogo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE ARENA (
    id_arena INT PRIMARY KEY AUTO_INCREMENT,
    numero_arena INT NOT NULL,
    capacidade INT NOT NULL
);

CREATE TABLE EQUIPA (
    id_equipa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE PARTICIPA (
    id_jogo INT NOT NULL,
    id_equipa INT NOT NULL,
    PRIMARY KEY (id_jogo, id_equipa),
    FOREIGN KEY (id_jogo) REFERENCES JOGO(id_jogo),
    FOREIGN KEY (id_equipa) REFERENCES EQUIPA(id_equipa)
);

CREATE TABLE JOGADOR (
    id_jogador INT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    curso VARCHAR(20),
    email VARCHAR(100) NOT NULL UNIQUE,
    telemovel VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE INSCRICAO_EQUIPA (
    id_jogador INT NOT NULL,
    id_equipa INT NOT NULL,
    estado VARCHAR(45) NOT NULL,
    data DATE NOT NULL,
    PRIMARY KEY (id_jogador, id_equipa),
    FOREIGN KEY (id_jogador) REFERENCES JOGADOR(id_jogador),
    FOREIGN KEY (id_equipa) REFERENCES EQUIPA(id_equipa)
);

CREATE TABLE PARTIDA (
    id_partida INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    id_jogo INT NOT NULL,
    id_arena INT NOT NULL,
    FOREIGN KEY (id_jogo) REFERENCES JOGO(id_jogo),
    FOREIGN KEY (id_arena) REFERENCES ARENA(id_arena)
);

CREATE TABLE JOGA (
    id_jogo INT NOT NULL,
    id_partida INT NOT NULL,
    id_equipa INT NOT NULL,
    resultado INT NOT NULL,
    PRIMARY KEY (id_jogo, id_partida, id_equipa),
    FOREIGN KEY (id_jogo) REFERENCES JOGO(id_jogo),
    FOREIGN KEY (id_partida) REFERENCES PARTIDA(id_partida),
    FOREIGN KEY (id_equipa) REFERENCES EQUIPA(id_equipa)
);

CREATE TABLE STAFF (
    id_staff INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    telemovel VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    funcao VARCHAR(45) NOT NULL
);

CREATE TABLE SUPERVISAO (
    id_supervisao INT AUTO_INCREMENT PRIMARY KEY,
    id_staff INT NOT NULL,
    id_partida INT NOT NULL,
    FOREIGN KEY (id_staff) REFERENCES STAFF(id_staff),
    FOREIGN KEY (id_partida) REFERENCES PARTIDA(id_partida)
);

CREATE TABLE ESPECTADOR (
    id_espectador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telemovel VARCHAR(20) NOT NULL
);

CREATE TABLE ASSISTE (
    id_assiste INT AUTO_INCREMENT PRIMARY KEY,
    id_espectador INT NOT NULL,
    id_partida INT NOT NULL,
    FOREIGN KEY (id_espectador) REFERENCES ESPECTADOR(id_espectador),
    FOREIGN KEY (id_partida) REFERENCES PARTIDA(id_partida)
);

CREATE TABLE INQUERITO (
    id_inquerito INT PRIMARY KEY AUTO_INCREMENT,
    perguntas VARCHAR(255) NOT NULL
);

CREATE TABLE RESPOSTA (
    id_jogador INT NOT NULL,
    id_inquerito INT NOT NULL,
    resposta VARCHAR(255),
    PRIMARY KEY (id_jogador, id_inquerito),
    FOREIGN KEY (id_jogador) REFERENCES JOGADOR(id_jogador),
    FOREIGN KEY (id_inquerito) REFERENCES INQUERITO(id_inquerito)
);

CREATE TABLE IF NOT EXISTS substituicao_controlo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ativa TINYINT(1) NOT NULL DEFAULT 0
);
INSERT INTO substituicao_controlo (ativa) VALUES (0);


-- ------------------------------------------------------------
-- 3. POVOAMENTO DE EXEMPLO (Ponto 5.3)
-- ------------------------------------------------------------

-- Jogos
INSERT INTO JOGO (nome) VALUES ('League of Legends'), ('Valorant'), ('CS2');

-- Arenas (10)
INSERT INTO ARENA (numero_arena, capacidade) VALUES
(1, 50), (2, 80), (3, 120), (4, 60), (5, 100), (6, 150),
(7, 70), (8, 90), (9, 110), (10, 200);

-- Equipas (40 equipas)
INSERT INTO EQUIPA (nome) VALUES
('Winx'),('Tremoços Assassinos'),('Weeknd'),('Imperiais De Elite'),
('Tropa Do Tone'),('Patos Tóxicos'),('OsMancos'),('Natinhas Sem Canela'),
('Porto d’Honra'),('Francesinhas Sem Picante'),('Pastéis De Belém de Backup'),
('Mulas De Carga Do Lobby'),('Zés dos Headshots'),('Falcões'),('Azeiteiros De Gaia'),
('Armados Em Carapaus De Corrida'),('Teclado Furioso'),('Tiro Ao Boneco'),
('Combo Errado'),('Chouriço de Sangue Frio'),('Caldo Verde E-Sports'),('Guerreiros de Aljubarrota'),
('Entrecosto com Lag'),('Vinho da Casa FC'),('Marmitas Quentes'),('Salsicharia Regional'),
('Só Dou Palha'),('Fiscais de Obra'),('Compal de Pêssego FC'),
('Tiro no Escuro'),('Condes de Ermesinde'),('Só Dou No Ar'),('Hooligans do Toy'),
('Guerreiros da Sagres'),('Iscas com Elas'),('Os Grão de Bico'),('Ucal Killers'),
('Vingadores do Preço Certo'),('Herdeiros de Dívidas'),('Fino de Pressão');

INSERT INTO PARTICIPA (id_jogo, id_equipa) VALUES
(1,4),(3,9),(2,2),(1,11),(3,7),(2,15),(1,18),(3,21),(2,26),(1,33),(3,40),(2,12),(1,1),
(2,1),(1,5),(3,5),(2,3),(3,3),(1,8),(2,8),(2,6),(3,6),(1,10),(3,10),
(2,13),(3,13),(1,16),(2,16),(1,19),(3,19),(2,14),(3,14),(1,22),(2,22),(1,25),(3,25),
(2,17),(3,17),(1,28),(2,28),(1,30),(3,30),(2,24),(3,24),(1,27),(3,27),(2,29),(3,29),
(1,20),(2,20),(3,20),(1,23),(2,23),(3,23),(1,31),(2,31),(3,31),(1,32),(2,32),(3,32),
(1,34),(2,34),(3,34),(1,35),(2,35),(3,35),(1,36),(2,36),(3,36),
(1,37),(2,37),(3,37),(1,38),(2,38),(3,38),(1,39),(2,39),(3,39);

-- Jogadores (70)
INSERT INTO JOGADOR (id_jogador, nome, curso, email, telemovel) VALUES
(1001, 'João Silva', 'Eng.Inf.', 'joao.silva@ua.pt', '913457811'),
(1002, 'Maria Costa', 'Design', 'maria.costa@um.pt', '924456789'),
(1003, 'Pedro Santos', 'Eng. Inf.', 'pedro.santos@ul.pt', '935567890'),
(1004, 'Ana Oliveira', 'Marketing', 'ana.oliveira@uf.pt', '961678901'),
(1005, 'Rui Ferreira', NULL, 'rui.ferreira@gmail.com', '927789012'),
(1006, 'Sofia Martins', 'Design', 'sofia.martins@ua.pt', '934890123'),
(1007, 'Tiago Lopes', 'Arquitetura', 'tiago.lopes@um.pt', '962765432'),
(1008, 'Inês Rodrigues', 'Marketing', 'ines.rodrigues@us.pt', '916876543'),
(1009, 'Diogo Nunes', 'Eng. Inf.', 'diogo.nunes@ua.pt', '925345679'),
(1010, 'Carla Mendes', 'Design', 'carla.mendes@um.pt', '936456780'),
(1011, 'Hugo Santos', 'Economia', 'hugo.santos@uc.pt', '963567891'),
(1012, 'Marta Pereira', 'Direito', 'marta.pereira@um.pt', '917678902'),
(1013, 'Ricardo Alves', 'Gestão', 'ricardo.alves@uc.pt', '928789013'),
(1014, 'Patrícia Correia', 'Marketing', 'patricia.correia@ua.pt', '939890124'),
(1015, 'Fábio Rodrigues', 'Eng. Inf.', 'fabio.rodrigues@um.pt', '964765433'),
(1016, 'Liliana Neves', 'Design', 'liliana.neves@ua.pt', '918876544'),
(1017, 'Gonçalo Ribeiro', NULL, 'goncalo.ribeiro@gmail.com', '929000111'),
(1018, 'André Martins', 'Eng. Civil', 'andre.martins@ua.pt', '931111222'),
(1019, 'Beatriz Silva', 'Biologia', 'beatriz.silva@um.pt', '965222333'),
(1020, 'Carlos Pereira', 'Física', 'carlos.pereira@uc.pt', '919333444'),
(1021, 'António Santos', 'Química', 'antonio.santos@ub.pt', '922444555'),
(1022, 'Eduardo Costa', 'Matemática', 'eduardo.costa@um.pt', '933555666'),
(1023, 'Filipa Rodrigues', 'História', 'filipa.rodrigues@uc.pt', '966666777'),
(1024, 'Gustavo Neves', 'Filosofia', 'gustavo.neves@ua.pt', '914777888'),
(1025, 'Helena Lopes', 'Geografia', 'helena.lopes@um.pt', '923888999'),
(1026, 'Ivo Sousa', 'Economia', 'ivo.sousa@ua.pt', '932999000'),
(1027, 'Joana Cardoso', 'Gestão', 'joana.cardoso@uc.pt', '967000111'),
(1028, 'Kevin Marques', 'Direito', 'kevin.marques@us.pt', '915111222'),
(1029, 'Lara Monteiro', 'Psicologia', 'lara.monteiro@um.pt', '926222333'),
(1030, 'Mário Pires', 'Sociologia', 'mario.pires@uc.pt', '937333444'),
(1031, 'Nádia Fonseca', 'Antropologia', 'nadia.fonseca@ua.pt', '968444555'),
(1032, 'Óscar Ribeiro', 'Letras', 'oscar.ribeiro@um.pt', '912555666'),
(1033, 'Paula Vicente', 'Medicina', 'paula.vicente@ua.pt', '921666777'),
(1034, 'Quintino Antunes', 'Farmácia', 'quintino.antunes@uc.pt', '938777888'),
(1035, 'Rosa Batista', 'Enfermagem', 'rosa.batista@ua.pt', '969888999'),
(1036, 'Simão Tavares', 'Eng. Mecânica', 'simao.tavares@um.pt', '913999000'),
(1037, 'Tatiana Morais', 'Arquitetura', 'tatiana.morais@ua.pt', '924000111'),
(1038, 'Nelson Coelho', 'Eng. Informática', 'nelson.coelho@ul.pt', '935222111'),
(1039, 'Vera Almeida', 'Matemática', 'vera.almeida@um.pt', '961333222'),
(1040, 'Sérgio Nascimento', 'Física', 'sergio.nascimento@ul.pt', '916444333'),
(1041, 'Adriana Costa', 'Biologia', 'adriana.costa@ua.pt', '927555444'),
(1042, 'Bruno Marques', 'Geologia', 'bruno.marques@um.pt', '934666555'),
(1043, 'Cátia Pinto', 'Estatística', 'catia.pinto@uc.pt', '962777666'),
(1044, 'David Correia', 'Eng. Química', 'david.correia@ua.pt', '918888777'),
(1045, 'Ema Santos', 'Design', 'ema.santos@um.pt', '929999888'),
(1046, 'Frederico Lopes', 'Economia', 'frederico.lopes@uc.pt', '931000999'),
(1047, 'Gisela Rocha', 'Direito', 'gisela.rocha@um.pt', '963111000'),
(1048, 'Hélder Neves', 'Gestão', 'helder.neves@um.pt', '917222111'),
(1049, 'Iara Henriques', 'Psicologia', 'iara.henriques@uc.pt', '928333222'),
(1050, 'Joaquim Alves', 'Sociologia', 'joaquim.alves@ua.pt', '939444333'),
(1051, 'Lara Prates', 'Letras', 'lara.prates@ua.pt', '964555444'),
(1052, 'Miguel Costa', 'Matemática', 'miguel.costa@um.pt', '916666555'),
(1053, 'Noémia Santos', 'Física', 'noemia.santos@uc.pt', '925777666'),
(1054, 'Olivério Martins', 'Química', 'oliverio.martins@ul.pt', '936888777'),
(1055, 'Patrícia Almeida', 'Biologia', 'patricia.almeida@um.pt', '961999888'),
(1056, 'Quirino Pereira', 'Farmácia', 'quirino.pereira@uc.pt', '912000999'),
(1057, 'Rui Miguel', 'Enfermagem', 'rui.miguel@ut.pt', '923111000'),
(1058, 'Sandra Pinto', 'Eng. Civil', 'sandra.pinto@um.pt', '932222111'),
(1059, 'Telmo Correia', 'Arquitetura', 'telmo.correia@uc.pt', '967333222'),
(1060, 'Ulisses Lopes', 'História', 'ulisses.lopes@up.pt', '914678145'),
(1061, 'Vânia Esteves', 'Geografia', 'vania.esteves@um.pt', '926555444'),
(1062, 'Wagner Cardoso', 'Filosofia', 'wagner.cardoso@uc.pt', '937666555'),
(1063, 'Xénia Marques', 'Antropologia', 'xenia.marques@ua.pt', '968777666'),
(1064, 'Yuri Monteiro', 'Eng. Mecânica', 'yuri.monteiro@um.pt', '915888777'),
(1065, 'Zita Fonseca', 'Eng. Informática', 'zita.fonseca@um.pt', '924999888'),
(1066, 'Alexandre Tavares', 'Design', 'alexandre.tavares@uv.pt', '933000999'),
(1067, 'Bárbara Vicente', 'Medicina', 'barbara.vicente@um.pt', '962111000'),
(1068, 'César Ribeiro', 'Letras', 'cesar.ribeiro@um.pt', '918222111'),
(1069, 'Dália Alves', 'Matemática', 'dalia.alves@um.pt', '929333222'),
(1070, 'Emanuel Santos', 'Física', 'emanuel.santos@um.pt', '934444333');

-- Inscrições (5 por equipa)
INSERT INTO INSCRICAO_EQUIPA (id_jogador, id_equipa, estado, data) VALUES
-- Winx (1)
(1001,1,'Confirmada','2026-04-01'),(1002,1,'Confirmada','2026-04-01'),(1003,1,'Confirmada','2026-04-01'),(1004,1,'Confirmada','2026-04-01'),(1005,1,'Confirmada','2026-04-01'),
-- Tremoços Assassinos (2)
(1006,2,'Confirmada','2026-04-02'),(1007,2,'Confirmada','2026-04-02'),(1008,2,'Confirmada','2026-04-02'),(1009,2,'Confirmada','2026-04-02'),(1010,2,'Confirmada','2026-04-02'),
-- Weeknd (3)
(1011,3,'Confirmada','2026-04-03'),(1012,3,'Confirmada','2026-04-03'),(1013,3,'Confirmada','2026-04-03'),(1014,3,'Confirmada','2026-04-03'),(1015,3,'Confirmada','2026-04-03'),
-- Imperiais De Elite (4)
(1016,4,'Confirmada','2026-04-04'),(1017,4,'Confirmada','2026-04-04'),(1018,4,'Confirmada','2026-04-04'),(1019,4,'Confirmada','2026-04-04'),(1020,4,'Confirmada','2026-04-04'),
-- Tropa Do Tone (5)
(1021,5,'Confirmada','2026-04-05'),(1022,5,'Confirmada','2026-04-05'),(1023,5,'Confirmada','2026-04-05'),(1024,5,'Confirmada','2026-04-05'),(1025,5,'Confirmada','2026-04-05'),
-- Patos Tóxicos (6)
(1026,6,'Confirmada','2026-04-06'),(1027,6,'Confirmada','2026-04-06'),(1028,6,'Confirmada','2026-04-06'),(1029,6,'Confirmada','2026-04-06'),(1030,6,'Confirmada','2026-04-06'),
-- OsMancos (7)
(1031,7,'Confirmada','2026-04-07'),(1032,7,'Confirmada','2026-04-07'),(1033,7,'Confirmada','2026-04-07'),(1034,7,'Confirmada','2026-04-07'),(1035,7,'Confirmada','2026-04-07'),
-- Natinhas Sem Canela (8)
(1036,8,'Confirmada','2026-04-08'),(1037,8,'Confirmada','2026-04-08'),(1038,8,'Confirmada','2026-04-08'),(1039,8,'Confirmada','2026-04-08'),(1040,8,'Confirmada','2026-04-08'),
-- Porto d’Honra_LoL (9)
(1041,9,'Confirmada','2026-04-09'),(1042,9,'Confirmada','2026-04-09'),(1043,9,'Confirmada','2026-04-09'),(1044,9,'Confirmada','2026-04-09'),(1045,9,'Confirmada','2026-04-09'),
-- Francesinhas Sem Picante (10)
(1046,10,'Confirmada','2026-04-10'),(1047,10,'Confirmada','2026-04-10'),(1048,10,'Confirmada','2026-04-10'),(1049,10,'Confirmada','2026-04-10'),(1050,10,'Confirmada','2026-04-10'),
-- Pastéis De Belém de Backup (11)
(1051,11,'Confirmada','2026-04-11'),(1052,11,'Confirmada','2026-04-11'),(1053,11,'Confirmada','2026-04-11'),(1054,11,'Confirmada','2026-04-11'),(1055,11,'Confirmada','2026-04-11'),
-- Mulas De Carga Do Lobby (12)
(1056,12,'Confirmada','2026-04-12'),(1057,12,'Confirmada','2026-04-12'),(1058,12,'Confirmada','2026-04-12'),(1059,12,'Confirmada','2026-04-12'),(1060,12,'Confirmada','2026-04-12'),
-- Zés dos Headshots (13)
(1061,13,'Confirmada','2026-04-13'),(1062,13,'Confirmada','2026-04-13'),(1063,13,'Confirmada','2026-04-13'),(1064,13,'Confirmada','2026-04-13'),(1065,13,'Confirmada','2026-04-13'),
-- Falcões_Valorant (14)
(1066,14,'Confirmada','2026-04-14'),(1067,14,'Confirmada','2026-04-14'),(1068,14,'Confirmada','2026-04-14'),(1069,14,'Confirmada','2026-04-14'),(1070,14,'Confirmada','2026-04-14'),
-- Azeiteiros De Gaia (15)
(1001,15,'Confirmada','2026-04-15'),(1006,15,'Confirmada','2026-04-15'),(1011,15,'Confirmada','2026-04-15'),(1016,15,'Confirmada','2026-04-15'),(1021,15,'Confirmada','2026-04-15'),
-- Armados Em Carapaus De Corrida (16)
(1002,16,'Confirmada','2026-04-16'),(1007,16,'Confirmada','2026-04-16'),(1012,16,'Confirmada','2026-04-16'),(1017,16,'Confirmada','2026-04-16'),(1022,16,'Confirmada','2026-04-16'),
-- Teclado Furioso (17)
(1003,17,'Confirmada','2026-04-17'),(1008,17,'Confirmada','2026-04-17'),(1013,17,'Confirmada','2026-04-17'),(1018,17,'Confirmada','2026-04-17'),(1023,17,'Confirmada','2026-04-17'),
-- Tiro Ao Boneco (18)
(1004,18,'Confirmada','2026-04-18'),(1009,18,'Confirmada','2026-04-18'),(1014,18,'Confirmada','2026-04-18'),(1019,18,'Confirmada','2026-04-18'),(1024,18,'Confirmada','2026-04-18'),
-- Combo Errado (19)
(1005,19,'Confirmada','2026-04-19'),(1010,19,'Confirmada','2026-04-19'),(1015,19,'Confirmada','2026-04-19'),(1020,19,'Confirmada','2026-04-19'),(1025,19,'Confirmada','2026-04-19'),
-- Chouriço de Sangue Frio_Valorant (20)
(1026,20,'Confirmada','2026-04-20'),(1031,20,'Confirmada','2026-04-20'),(1036,20,'Confirmada','2026-04-20'),(1041,20,'Confirmada','2026-04-20'),(1046,20,'Confirmada','2026-04-20'),
-- Caldo Verde E-Sports (21)
(1027,21,'Confirmada','2026-04-21'),(1032,21,'Confirmada','2026-04-21'),(1037,21,'Confirmada','2026-04-21'),(1042,21,'Confirmada','2026-04-21'),(1047,21,'Confirmada','2026-04-21'),
-- Guerreiros de Aljubarrota (22)
(1028,22,'Confirmada','2026-04-22'),(1033,22,'Confirmada','2026-04-22'),(1038,22,'Confirmada','2026-04-22'),(1043,22,'Confirmada','2026-04-22'),(1048,22,'Confirmada','2026-04-22'),
-- Entrecosto com Lag (23)
(1029,23,'Confirmada','2026-04-23'),(1034,23,'Confirmada','2026-04-23'),(1039,23,'Confirmada','2026-04-23'),(1044,23,'Confirmada','2026-04-23'),(1049,23,'Confirmada','2026-04-23'),
-- Vinho da Casa FC (24)
(1030,24,'Confirmada','2026-04-24'),(1035,24,'Confirmada','2026-04-24'),(1040,24,'Confirmada','2026-04-24'),(1045,24,'Confirmada','2026-04-24'),(1050,24,'Confirmada','2026-04-24'),
-- Marmitas Quentes (25)
(1051,25,'Confirmada','2026-04-25'),(1056,25,'Confirmada','2026-04-25'),(1061,25,'Confirmada','2026-04-25'),(1066,25,'Confirmada','2026-04-25'),(1070,25,'Confirmada','2026-04-25'),
-- Salsicharia Regional (26)
(1052,26,'Confirmada','2026-04-26'),(1057,26,'Confirmada','2026-04-26'),(1062,26,'Confirmada','2026-04-26'),(1067,26,'Confirmada','2026-04-26'),(1001,26,'Confirmada','2026-04-26'),
-- Só Dou Palha (27)
(1053,27,'Confirmada','2026-04-27'),(1058,27,'Confirmada','2026-04-27'),(1063,27,'Confirmada','2026-04-27'),(1068,27,'Confirmada','2026-04-27'),(1002,27,'Confirmada','2026-04-27'),
-- Fiscais de Obra (28)
(1054,28,'Confirmada','2026-04-28'),(1059,28,'Confirmada','2026-04-28'),(1064,28,'Confirmada','2026-04-28'),(1069,28,'Confirmada','2026-04-28'),(1003,28,'Confirmada','2026-04-28'),
-- Compal de Pêssego FC (29)
(1055,29,'Confirmada','2026-04-29'),(1060,29,'Confirmada','2026-04-29'),(1065,29,'Confirmada','2026-04-29'),(1070,29,'Confirmada','2026-04-29'),(1004,29,'Confirmada','2026-04-29'),
-- Tiro no Escuro (30)
(1005,30,'Confirmada','2026-04-30'),(1010,30,'Confirmada','2026-04-30'),(1015,30,'Confirmada','2026-04-30'),(1020,30,'Confirmada','2026-04-30'),(1025,30,'Confirmada','2026-04-30'),
-- Condes de Ermesinde (31)
(1006,31,'Confirmada','2026-05-01'),(1011,31,'Confirmada','2026-05-01'),(1016,31,'Confirmada','2026-05-01'),(1021,31,'Confirmada','2026-05-01'),(1026,31,'Confirmada','2026-05-01'),
-- Só Dou No Ar (32)
(1007,32,'Confirmada','2026-05-02'),(1012,32,'Confirmada','2026-05-02'),(1017,32,'Confirmada','2026-05-02'),(1022,32,'Confirmada','2026-05-02'),(1027,32,'Confirmada','2026-05-02'),
-- Hooligans do Toy (33)
(1008,33,'Confirmada','2026-05-03'),(1013,33,'Confirmada','2026-05-03'),(1018,33,'Confirmada','2026-05-03'),(1023,33,'Confirmada','2026-05-03'),(1028,33,'Confirmada','2026-05-03'),
-- Guerreiros da Sagres (34)
(1009,34,'Confirmada','2026-05-04'),(1014,34,'Confirmada','2026-05-04'),(1019,34,'Confirmada','2026-05-04'),(1024,34,'Confirmada','2026-05-04'),(1029,34,'Confirmada','2026-05-04'),
-- Iscas com Elas (35)
(1030,35,'Confirmada','2026-05-05'),(1035,35,'Confirmada','2026-05-05'),(1040,35,'Confirmada','2026-05-05'),(1045,35,'Confirmada','2026-05-05'),(1050,35,'Confirmada','2026-05-05'),
-- Os Grão de Bico (36)
(1031,36,'Confirmada','2026-05-06'),(1036,36,'Confirmada','2026-05-06'),(1041,36,'Confirmada','2026-05-06'),(1046,36,'Confirmada','2026-05-06'),(1051,36,'Confirmada','2026-05-06'),
-- Ucal Killers (37)
(1032,37,'Confirmada','2026-05-07'),(1037,37,'Confirmada','2026-05-07'),(1042,37,'Confirmada','2026-05-07'),(1047,37,'Confirmada','2026-05-07'),(1052,37,'Confirmada','2026-05-07'),
-- Vingadores do Preço Certo (38)
(1033,38,'Confirmada','2026-05-08'),(1038,38,'Confirmada','2026-05-08'),(1043,38,'Confirmada','2026-05-08'),(1048,38,'Confirmada','2026-05-08'),(1053,38,'Confirmada','2026-05-08'),
-- Herdeiros de Dívidas (39)
(1034,39,'Confirmada','2026-05-09'),(1039,39,'Confirmada','2026-05-09'),(1044,39,'Confirmada','2026-05-09'),(1049,39,'Confirmada','2026-05-09'),(1054,39,'Confirmada','2026-05-09'),
-- Fino de Pressão (40)
(1035,40,'Confirmada','2026-05-10'),(1040,40,'Confirmada','2026-05-10'),(1045,40,'Confirmada','2026-05-10'),(1050,40,'Confirmada','2026-05-10'),(1055,40,'Confirmada','2026-05-10');

-- Partidas (60)
INSERT INTO PARTIDA (data, hora_inicio, hora_fim, id_jogo, id_arena) VALUES
-- LoL (partidas 1-20)
('2026-05-10','14:00:00','15:00:00',1,1),
('2026-05-10','15:30:00','16:30:00',1,2),
('2026-05-10','17:00:00','18:00:00',1,3),
('2026-05-10','18:30:00','19:30:00',1,4),
('2026-05-13','14:00:00','15:00:00',1,5),
('2026-05-13','15:30:00','16:30:00',1,6),
('2026-05-13','17:00:00','18:00:00',1,7),
('2026-05-13','18:30:00','19:30:00',1,8),
('2026-05-16','14:00:00','15:00:00',1,9),
('2026-05-16','15:30:00','16:30:00',1,10),
('2026-05-19','14:00:00','15:00:00',1,1),
('2026-05-19','15:30:00','16:30:00',1,2),
('2026-05-19','17:00:00','18:00:00',1,3),
('2026-05-19','18:30:00','19:30:00',1,4),
('2026-05-22','14:00:00','15:00:00',1,5),
('2026-05-22','15:30:00','16:30:00',1,6),
('2026-05-22','17:00:00','18:00:00',1,7),
('2026-05-22','18:30:00','19:30:00',1,8),
('2026-05-25','14:00:00','15:00:00',1,9),
('2026-05-25','15:30:00','16:30:00',1,10),
-- Valorant (21-40)
('2026-05-11','14:00:00','15:00:00',2,1),
('2026-05-11','15:30:00','16:30:00',2,2),
('2026-05-11','17:00:00','18:00:00',2,3),
('2026-05-11','18:30:00','19:30:00',2,4),
('2026-05-14','14:00:00','15:00:00',2,5),
('2026-05-14','15:30:00','16:30:00',2,6),
('2026-05-14','17:00:00','18:00:00',2,7),
('2026-05-14','18:30:00','19:30:00',2,8),
('2026-05-17','14:00:00','15:00:00',2,9),
('2026-05-17','15:30:00','16:30:00',2,10),
('2026-05-20','14:00:00','15:00:00',2,1),
('2026-05-20','15:30:00','16:30:00',2,2),
('2026-05-20','17:00:00','18:00:00',2,3),
('2026-05-20','18:30:00','19:30:00',2,4),
('2026-05-23','14:00:00','15:00:00',2,5),
('2026-05-23','15:30:00','16:30:00',2,6),
('2026-05-23','17:00:00','18:00:00',2,7),
('2026-05-23','18:30:00','19:30:00',2,8),
('2026-05-26','14:00:00','15:00:00',2,9),
('2026-05-26','15:30:00','16:30:00',2,10),
-- CS2 (41-60)
('2026-05-12','14:00:00','15:00:00',3,1),
('2026-05-12','15:30:00','16:30:00',3,2),
('2026-05-12','17:00:00','18:00:00',3,3),
('2026-05-12','18:30:00','19:30:00',3,4),
('2026-05-15','14:00:00','15:00:00',3,5),
('2026-05-15','15:30:00','16:30:00',3,6),
('2026-05-15','17:00:00','18:00:00',3,7),
('2026-05-15','18:30:00','19:30:00',3,8),
('2026-05-18','14:00:00','15:00:00',3,9),
('2026-05-18','15:30:00','16:30:00',3,10),
('2026-05-21','14:00:00','15:00:00',3,1),
('2026-05-21','15:30:00','16:30:00',3,2),
('2026-05-21','17:00:00','18:00:00',3,3),
('2026-05-21','18:30:00','19:30:00',3,4),
('2026-05-24','14:00:00','15:00:00',3,5),
('2026-05-24','15:30:00','16:30:00',3,6),
('2026-05-24','17:00:00','18:00:00',3,7),
('2026-05-24','18:30:00','19:30:00',3,8),
('2026-05-27','14:00:00','15:00:00',3,9),
('2026-05-27','15:30:00','16:30:00',3,10);

-- JOGA (resultados com novos ids de equipa já t+a corrijido)
INSERT INTO JOGA (id_jogo, id_partida, id_equipa, resultado) VALUES
-- LoL
(1,1,1,2),(1,1,2,0), (1,2,3,1),(1,2,4,1), (1,3,5,2),(1,3,6,0), (1,4,7,2),(1,4,8,0),
(1,5,9,1),(1,5,10,1), (1,6,1,2),(1,6,3,0), (1,7,2,1),(1,7,4,1), (1,8,5,0),(1,8,7,2),
(1,9,6,1),(1,9,8,1), (1,10,9,2),(1,10,1,0), (1,11,10,0),(1,11,2,2), (1,12,3,2),(1,12,5,0),
(1,13,4,1),(1,13,6,1), (1,14,7,2),(1,14,9,0), (1,15,8,1),(1,15,10,1), (1,16,1,2),(1,16,6,0),
(1,17,2,0),(1,17,7,2), (1,18,3,1),(1,18,8,1), (1,19,4,2),(1,19,9,0), (1,20,5,1),(1,20,10,1),
-- Valorant
(2,21,11,2),(2,21,12,0), (2,22,13,1),(2,22,14,1), (2,23,15,2),(2,23,16,0), (2,24,19,2),(2,24,20,0),
(2,25,21,1),(2,25,22,1), (2,26,11,2),(2,26,13,0), (2,27,12,0),(2,27,14,2), (2,28,15,1),(2,28,19,1),
(2,29,16,2),(2,29,21,0), (2,30,20,0),(2,30,22,2), (2,31,11,1),(2,31,15,1), (2,32,12,2),(2,32,16,0),
(2,33,13,0),(2,33,19,2), (2,34,14,1),(2,34,20,1), (2,35,21,2),(2,35,11,0), (2,36,22,0),(2,36,12,2),
(2,37,13,2),(2,37,16,0), (2,38,14,0),(2,38,19,2), (2,39,15,1),(2,39,21,1), (2,40,20,2),(2,40,22,0),
-- CS2
(3,41,23,2),(3,41,24,0), (3,42,25,1),(3,42,26,1), (3,43,27,2),(3,43,28,0), (3,44,29,1),(3,44,30,1),
(3,45,31,2),(3,45,32,0), (3,46,33,2),(3,46,34,0), (3,47,35,1),(3,47,36,1), (3,48,37,2),(3,48,38,0),
(3,49,39,0),(3,49,40,2), (3,50,23,1),(3,50,25,1), (3,51,24,0),(3,51,26,2), (3,52,27,2),(3,52,29,0),
(3,53,28,1),(3,53,30,1), (3,54,31,0),(3,54,33,2), (3,55,32,2),(3,55,35,0), (3,56,34,1),(3,56,36,1),
(3,57,37,2),(3,57,39,0), (3,58,38,0),(3,58,40,2), (3,59,23,2),(3,59,31,0), (3,60,24,1),(3,60,32,1);

-- Staff (20)
INSERT INTO STAFF (nome, telemovel, email, funcao) VALUES 
('Carlos Árbitro', '912345678', 'carlos.arbitro@staff.pt', 'Árbitro'),
('Marta Supervisora', '913456789', 'marta.supervisora@staff.pt', 'Supervisora'),
('Rui Coordenador', '919999999', 'rui.coordenador@staff.pt', 'Coordenador'),
('Ana Assistente', '918888888', 'ana.assistente@staff.pt', 'Assistente'),
('Paulo Técnico', '911222333', 'paulo.tecnico@staff.pt', 'Técnico'),
('Sandra Logística', '911333444', 'sandra.logistica@staff.pt', 'Logística'),
('Bruno Comunicação', '911444555', 'bruno.comunicacao@staff.pt', 'Comunicação'),
('Carla Apoio', '911555666', 'carla.apoio@staff.pt', 'Apoio'),
('Nuno Árbitro', '911666777', 'nuno.arbitro@staff.pt', 'Árbitro'),
('Inês Supervisora', '911777888', 'ines.supervisora@staff.pt', 'Supervisora'),
('Sérgio Técnico', '911888999', 'sergio.tecnico@staff.pt', 'Técnico'),
('Patrícia Logística', '911999000', 'patricia.logistica@staff.pt', 'Logística'),
('Hugo Comunicação', '912000111', 'hugo.comunicacao@staff.pt', 'Comunicação'),
('Cláudia Apoio', '912111222', 'claudia.apoio@staff.pt', 'Apoio'),
('Tiago Árbitro', '912222333', 'tiago.arbitro@staff.pt', 'Árbitro'),
('Sofia Supervisora', '912333444', 'sofia.supervisora@staff.pt', 'Supervisora'),
('André Técnico', '912444555', 'andre.tecnico@staff.pt', 'Técnico'),
('Mónica Logística', '912555666', 'monica.logistica@staff.pt', 'Logística'),
('Ricardo Comunicação', '912666777', 'ricardo.comunicacao@staff.pt', 'Comunicação'),
('Luísa Apoio', '912777888', 'luisa.apoio@staff.pt', 'Apoio');

-- Supervisões (cada partida com 2 staffs)
INSERT INTO SUPERVISAO (id_staff, id_partida) VALUES
(1,1),(2,1),(3,2),(4,2),(5,3),(6,3),(7,4),(8,4),(9,5),(10,5),
(11,6),(12,6),(13,7),(14,7),(15,8),(16,8),(17,9),(18,9),(19,10),(20,10),
(1,11),(2,11),(3,12),(4,12),(5,13),(6,13),(7,14),(8,14),(9,15),(10,15),
(11,16),(12,16),(13,17),(14,17),(15,18),(16,18),(17,19),(18,19),(19,20),(20,20),
(1,21),(2,21),(3,22),(4,22),(5,23),(6,23),(7,24),(8,24),(9,25),(10,25),
(11,26),(12,26),(13,27),(14,27),(15,28),(16,28),(17,29),(18,29),(19,30),(20,30),
(1,31),(2,31),(3,32),(4,32),(5,33),(6,33),(7,34),(8,34),(9,35),(10,35),
(11,36),(12,36),(13,37),(14,37),(15,38),(16,38),(17,39),(18,39),(19,40),(20,40),
(1,41),(2,41),(3,42),(4,42),(5,43),(6,43),(7,44),(8,44),(9,45),(10,45),
(11,46),(12,46),(13,47),(14,47),(15,48),(16,48),(17,49),(18,49),(19,50),(20,50),
(1,51),(2,51),(3,52),(4,52),(5,53),(6,53),(7,54),(8,54),(9,55),(10,55),
(11,56),(12,56),(13,57),(14,57),(15,58),(16,58),(17,59),(18,59),(19,60),(20,60);

-- Espectadores (60)
INSERT INTO ESPECTADOR (nome, email, telemovel) VALUES 
('Zé Povinho', 'ze.povinho@gmail.com', '923456781'),
('Rita Alves', 'rita.alves@ua.pt', '934567812'),
('Luís Pereira', 'luis.pereira@uc.pt', '961234567'),
('Sara Dias', 'sara_dias@hotmail.com', '927654321'),
('Nuno Matias', 'nuno.matias@ul.pt', '936789123'),
('Cátia Rocha', 'catia.rocha@yahoo.com', '965432187'),
('Andreia Gomes', 'andreia.gomes@ua.pt', '931112223'),
('Bruno Rocha', 'brocha@gmail.com', '962223334'),
('Cátia Miranda', 'catia.miranda@uc.pt', '924445556'),
('David Antunes', 'david.antunes@outlook.com', '933334445'),
('Elisa Teixeira', 'elisa.teixeira@ul.pt', '966778899'),
('Fernando Moura', 'fmoura@gmail.com', '928887776'),
('Gabriela Cunha', 'gabriela.cunha@ua.pt', '937771112'),
('Hélder Matos', 'helder.matos@sapo.pt', '963339991'),
('Irina Esteves', 'irina.esteves@uc.pt', '921234890'),
('Joaquim Lamego', 'joaquim.lamego@hotmail.com', '932145678'),
('Lara Prates', 'lara.prates@ul.pt', '964567891'),
('Micael Santos', 'micael.santos@gmail.com', '929876543'),
('Núria Correia', 'nuria.correia@ua.pt', '935551234'),
('Orlando Pais', 'orlando.pais@outlook.com', '967123456'),
('Patrícia Soares', 'patricia.soares@uc.pt', '922334455'),
('Quim Barreiros', 'quim.barreiros@gmail.com', '938889900'),
('Rosa Mota', 'rosa.mota@ul.pt', '969998877'),
('Sílvia Alberto', 'silvia.alberto@sapo.pt', '926667788'),
('Tó Zé', 'toze@gmail.com', '931231231'),
('Ulisses Pereira', 'ulisses.pereira@ua.pt', '964321789'),
('Vânia Fernandes', 'vaniaf@yahoo.com', '923219876'),
('Wagner Sousa', 'wagner.sousa@uc.pt', '936541278'),
('Xana Carvalho', 'xana.carvalho@hotmail.com', '965678123'),
('Yara Martins', 'yara.martins@ul.pt', '927891234'),
('Zulmira Santos', 'zulmira.santos@gmail.com', '934112233'),
('Abel Ferreira', 'abel.ferreira@ua.pt', '961998877'),
('Benedita Castro', 'benedita.castro@sapo.pt', '922556677'),
('Custódio Marques', 'custodio.marques@uc.pt', '933667788'),
('Dulcineia Pereira', 'dulcineia.p@hotmail.com', '966112233'),
('Egídio Costa', 'egidio.costa@ul.pt', '928223344'),
('Felismina Rodrigues', 'felismina.r@gmail.com', '937445566'),
('Gualberto Neves', 'gualberto.neves@ua.pt', '963556677'),
('Hermínia Alves', 'herminia.alves@yahoo.com', '921667788'),
('Ildefonso Sousa', 'ildefonso.sousa@uc.pt', '932778899'),
('Jacinta Cardoso', 'jacinta.cardoso@outlook.com', '964889911'),
('Laurindo Marques', 'laurindo.marques@ul.pt', '929991122'),
('Madalena Monteiro', 'madalena.monteiro@gmail.com', '935123987'),
('Narciso Pires', 'narciso.pires@ua.pt', '967654321'),
('Odete Fonseca', 'odete.fonseca@sapo.pt', '923987654'),
('Porfírio Ribeiro', 'porfirio.ribeiro@uc.pt', '934876512'),
('Quitéria Vicente', 'quiteria.vicente@hotmail.com', '961112345'),
('Reinaldo Antunes', 'reinaldo.antunes@ul.pt', '926543219'),
('Salomé Batista', 'salome.batista@gmail.com', '933219988'),
('Telmo Tavares', 'telmo.tavares@ua.pt', '965112233'),
('Urbano Morais', 'urbano.morais@yahoo.com', '927223344'),
('Valquíria Leal', 'valquiria.leal@uc.pt', '936334455'),
('Xisto Pacheco', 'xisto.pacheco@outlook.com', '962445566'),
('Eva Mendes', 'eva.mendes@ul.pt', '924556677'),
('Fábio Coelho', 'fabio.coelho@gmail.com', '931667788'),
('Glória Azevedo', 'gloria.azevedo@sapo.pt', '966778811'),
('Horácio Lima', 'horacio.lima@ua.pt', '928889922'),
('Íris Duarte', 'iris.duarte@hotmail.com', '937990011'),
('Jéssica Cardoso', 'jessica.cardoso@uc.pt', '963101010'),
('Zacarias Guedes', 'zacarias.guedes@outlook.com', '921202020');


-- Assiste 
INSERT INTO ASSISTE (id_espectador, id_partida) VALUES
(4,1),(17,1),(29,1),(8,1),(56,1),(33,1),(12,1),(48,1),(25,1),(39,1),(6,1),(51,1),(14,1),(2,1),(44,1),(21,1),(37,1),(9,1),(58,1),(30,1),(11,1),(46,1),(19,1),(35,1),(60,1),
(7,2),(22,2),(41,2),(13,2),(54,2),(26,2),(38,2),(1,2),(49,2),(16,2),(31,2),(57,2),(10,2),(45,2),(28,2),(5,2),(52,2),(20,2),(36,2),(8,2),(59,2),(24,2),(42,2),(15,2),(33,2),
(18,3),(47,3),(9,3),(30,3),(55,3),(12,3),(39,3),(6,3),(51,3),(23,3),(40,3),(14,3),(58,3),(27,3),(3,3),(44,3),(19,3),(35,3),(60,3),(11,3),(48,3),(25,3),(41,3),(7,3),(53,3),
(5,4),(29,4),(46,4),(17,4),(34,4),(8,4),(56,4),(21,4),(37,4),(10,4),(50,4),(26,4),(43,4),(2,4),(59,4),(13,4),(31,4),(45,4),(18,4),(54,4),(24,4),(39,4),(6,4),(52,4),(28,4),
(1,5),(33,5),(47,5),(15,5),(40,5),(22,5),(57,5),(11,5),(36,5),(4,5),(49,5),(27,5),(42,5),(19,5),(58,5),(9,5),(30,5),(53,5),(14,5),(44,5),(25,5),(38,5),(7,5),(51,5),(20,5),
(12,6),(35,6),(48,6),(18,6),(56,6),(24,6),(41,6),(3,6),(50,6),(29,6),(13,6),(45,6),(21,6),(37,6),(8,6),(59,6),(16,6),(32,6),(54,6),(5,6),(43,6),(27,6),(10,6),(52,6),(39,6),
(6,7),(31,7),(47,7),(14,7),(58,7),(23,7),(40,7),(9,7),(55,7),(19,7),(36,7),(2,7),(49,7),(28,7),(11,7),(42,7),(17,7),(60,7),(25,7),(44,7),(7,7),(51,7),(33,7),(15,7),(38,7),
(20,8),(46,8),(13,8),(34,8),(57,8),(8,8),(39,8),(24,8),(50,8),(5,8),(41,8),(29,8),(16,8),(53,8),(1,8),(37,8),(22,8),(48,8),(10,8),(59,8),(27,8),(43,8),(18,8),(32,8),(54,8),
(4,9),(35,9),(52,9),(12,9),(44,9),(26,9),(60,9),(15,9),(38,9),(7,9),(49,9),(21,9),(33,9),(58,9),(9,9),(45,9),(30,9),(17,9),(55,9),(2,9),(40,9),(24,9),(51,9),(11,9),(36,9),
(14,10),(47,10),(25,10),(39,10),(6,10),(54,10),(18,10),(31,10),(43,10),(8,10),(59,10),(20,10),(35,10),(1,10),(50,10),(27,10),(41,10),(13,10),(57,10),(22,10),(37,10),(5,10),(48,10),(29,10),(10,10),
(3,11),(42,11),(19,11),(53,11),(11,11),(36,11),(60,11),(24,11),(45,11),(7,11),(51,11),(28,11),(14,11),(39,11),(2,11),(56,11),(17,11),(33,11),(49,11),(9,11),(40,11),(21,11),(58,11),(12,11),(31,11),
(5,12),(47,12),(26,12),(38,12),(15,12),(54,12),(20,12),(41,12),(8,12),(50,12),(29,12),(13,12),(57,12),(23,12),(35,12),(1,12),(44,12),(18,12),(52,12),(10,12),(37,12),(24,12),(59,12),(6,12),(32,12),
(16,13),(48,13),(30,13),(42,13),(7,13),(55,13),(21,13),(39,13),(4,13),(51,13),(27,13),(11,13),(45,13),(19,13),(60,13),(25,13),(36,13),(2,13),(58,13),(14,13),(40,13),(9,13),(53,13),(22,13),(34,13),
(1,14),(46,14),(24,14),(37,14),(12,14),(49,14),(31,14),(57,14),(17,14),(43,14),(5,14),(52,14),(20,14),(38,14),(8,14),(55,14),(29,14),(13,14),(60,14),(26,14),(41,14),(10,14),(47,14),(18,14),(35,14),
(6,15),(50,15),(28,15),(39,15),(14,15),(58,15),(22,15),(44,15),(3,15),(53,15),(19,15),(36,15),(9,15),(48,15),(25,15),(42,15),(11,15),(56,15),(30,15),(16,15),(45,15),(1,15),(51,15),(24,15),(37,15),
(7,16),(41,16),(18,16),(54,16),(12,16),(35,16),(59,16),(21,16),(43,16),(4,16),(49,16),(27,16),(10,16),(57,16),(23,16),(38,16),(1,16),(52,16),(29,16),(15,16),(46,16),(6,16),(50,16),(32,16),(40,16),
(13,17),(44,17),(25,17),(36,17),(8,17),(58,17),(20,17),(47,17),(2,17),(53,17),(31,17),(11,17),(42,17),(17,17),(55,17),(28,17),(39,17),(5,17),(51,17),(24,17),(60,17),(14,17),(45,17),(9,17),(34,17),
(3,18),(48,18),(19,18),(37,18),(16,18),(56,18),(22,18),(41,18),(7,18),(52,18),(30,18),(13,18),(44,18),(1,18),(59,18),(26,18),(35,18),(10,18),(50,18),(21,18),(43,18),(6,18),(57,18),(24,18),(38,18),
(5,19),(46,19),(28,19),(40,19),(11,19),(54,19),(18,19),(49,19),(2,19),(53,19),(33,19),(14,19),(42,19),(25,19),(60,19),(9,19),(51,19),(20,19),(37,19),(4,19),(58,19),(27,19),(45,19),(12,19),(39,19),
(1,20),(47,20),(23,20),(36,20),(15,20),(55,20),(31,20),(43,20),(8,20),(50,20),(29,20),(17,20),(44,20),(6,20),(59,20),(24,20),(35,20),(13,20),(52,20),(21,20),(41,20),(10,20),(57,20),(26,20),(38,20),
(9,21),(34,21),(52,21),(18,21),(41,21),(7,21),(56,21),(23,21),(39,21),(12,21),(47,21),(1,21),(58,21),(26,21),(35,21),(14,21),(50,21),(20,21),(44,21),(5,21),(60,21),(29,21),(37,21),(10,21),(53,21),
(3,22),(48,22),(22,22),(36,22),(15,22),(55,22),(31,22),(42,22),(8,22),(51,22),(24,22),(40,22),(11,22),(57,22),(19,22),(46,22),(2,22),(59,22),(27,22),(33,22),(13,22),(54,22),(21,22),(38,22),(6,22),
(17,23),(45,23),(28,23),(43,23),(4,23),(52,23),(25,23),(35,23),(9,23),(60,23),(14,23),(49,23),(20,23),(37,23),(1,23),(56,23),(30,23),(41,23),(12,23),(53,23),(18,23),(47,23),(7,23),(58,23),(24,23),
(10,24),(39,24),(22,24),(50,24),(5,24),(44,24),(29,24),(36,24),(13,24),(57,24),(21,24),(42,24),(2,24),(51,24),(26,24),(33,24),(16,24),(55,24),(8,24),(48,24),(19,24),(40,24),(1,24),(59,24),(31,24),
(6,25),(46,25),(23,25),(38,25),(11,25),(54,25),(27,25),(35,25),(4,25),(52,25),(18,25),(43,25),(9,25),(58,25),(24,25),(37,25),(14,25),(49,25),(3,25),(60,25),(20,25),(41,25),(7,25),(56,25),(32,25),
(15,26),(45,26),(28,26),(34,26),(10,26),(53,26),(22,26),(39,26),(1,26),(57,26),(17,26),(48,26),(25,26),(36,26),(12,26),(50,26),(6,26),(59,26),(19,26),(44,26),(30,26),(42,26),(8,26),(55,26),(21,26),
(2,27),(47,27),(26,27),(35,27),(13,27),(54,27),(24,27),(38,27),(5,27),(51,27),(16,27),(43,27),(11,27),(58,27),(29,27),(33,27),(7,27),(60,27),(18,27),(40,27),(22,27),(46,27),(9,27),(52,27),(31,27),
(14,28),(49,28),(20,28),(41,28),(3,28),(56,28),(27,28),(37,28),(10,28),(53,28),(24,28),(35,28),(1,28),(57,28),(17,28),(45,28),(12,28),(50,28),(6,28),(59,28),(19,28),(43,28),(8,28),(54,28),(30,28),
(4,29),(52,29),(21,29),(36,29),(15,29),(48,29),(25,29),(39,29),(11,29),(55,29),(28,29),(34,29),(2,29),(60,29),(18,29),(44,29),(7,29),(51,29),(22,29),(40,29),(13,29),(46,29),(9,29),(58,29),(31,29),
(5,30),(47,30),(23,30),(38,30),(14,30),(53,30),(26,30),(35,30),(1,30),(56,30),(17,30),(42,30),(10,30),(59,30),(29,30),(33,30),(6,30),(50,30),(19,30),(45,30),(24,30),(37,30),(8,30),(54,30),(32,30),
(12,31),(49,31),(20,31),(41,31),(3,31),(57,31),(27,31),(36,31),(11,31),(52,31),(22,31),(39,31),(5,31),(60,31),(16,31),(43,31),(9,31),(55,31),(30,31),(34,31),(1,31),(47,31),(18,31),(44,31),(7,31),
(14,32),(51,32),(25,32),(38,32),(13,32),(53,32),(28,32),(35,32),(4,32),(58,32),(19,32),(42,32),(10,32),(59,32),(23,32),(37,32),(6,32),(46,32),(21,32),(40,32),(15,32),(50,32),(8,32),(54,32),(31,32),
(2,33),(48,33),(26,33),(33,33),(12,33),(56,33),(24,33),(41,33),(5,33),(57,33),(17,33),(45,33),(11,33),(52,33),(29,33),(36,33),(7,33),(60,33),(18,33),(43,33),(20,33),(39,33),(9,33),(51,33),(30,33),
(3,34),(49,34),(22,34),(35,34),(14,34),(53,34),(27,34),(38,34),(1,34),(58,34),(16,34),(42,34),(10,34),(54,34),(25,34),(37,34),(6,34),(47,34),(19,34),(44,34),(12,34),(50,34),(8,34),(55,34),(31,34),
(4,35),(46,35),(23,35),(34,35),(15,35),(52,35),(28,35),(39,35),(2,35),(57,35),(17,35),(41,35),(11,35),(59,35),(24,35),(36,35),(7,35),(48,35),(20,35),(43,35),(13,35),(51,35),(9,35),(56,35),(30,35),
(5,36),(47,36),(21,36),(38,36),(14,36),(53,36),(26,36),(35,36),(1,36),(58,36),(18,36),(42,36),(10,36),(54,36),(25,36),(37,36),(6,36),(49,36),(19,36),(44,36),(12,36),(50,36),(8,36),(55,36),(31,36),
(3,37),(45,37),(22,37),(33,37),(15,37),(57,37),(27,37),(40,37),(4,37),(52,37),(16,37),(41,37),(11,37),(60,37),(24,37),(36,37),(7,37),(48,37),(18,37),(43,37),(20,37),(39,37),(9,37),(51,37),(30,37),
(2,38),(46,38),(23,38),(34,38),(13,38),(53,38),(28,38),(35,38),(1,38),(58,38),(17,38),(42,38),(10,38),(55,38),(25,38),(37,38),(6,38),(47,38),(19,38),(44,38),(12,38),(50,38),(8,38),(56,38),(31,38),
(4,39),(49,39),(21,39),(38,39),(14,39),(52,39),(26,39),(36,39),(3,39),(57,39),(18,39),(41,39),(11,39),(59,39),(24,39),(35,39),(7,39),(48,39),(20,39),(43,39),(13,39),(51,39),(9,39),(54,39),(30,39),
(5,40),(47,40),(22,40),(33,40),(15,40),(53,40),(27,40),(39,40),(2,40),(58,40),(16,40),(42,40),(10,40),(55,40),(25,40),(37,40),(6,40),(46,40),(19,40),(44,40),(12,40),(50,40),(8,40),(56,40),(31,40),
(1,41),(48,41),(23,41),(35,41),(14,41),(52,41),(28,41),(38,41),(3,41),(57,41),(17,41),(41,41),(11,41),(59,41),(24,41),(36,41),(7,41),(49,41),(20,41),(43,41),(13,41),(51,41),(9,41),(55,41),(30,41),
(4,42),(46,42),(21,42),(34,42),(15,42),(53,42),(27,42),(40,42),(2,42),(58,42),(18,42),(42,42),(10,42),(54,42),(25,42),(37,42),(6,42),(47,42),(19,42),(44,42),(12,42),(50,42),(8,42),(56,42),(31,42),
(5,43),(49,43),(22,43),(33,43),(13,43),(52,43),(26,43),(39,43),(1,43),(57,43),(16,43),(41,43),(11,43),(60,43),(24,43),(35,43),(7,43),(48,43),(18,43),(43,43),(20,43),(38,43),(9,43),(51,43),(30,43),
(3,44),(45,44),(23,44),(34,44),(14,44),(53,44),(28,44),(36,44),(2,44),(58,44),(17,44),(42,44),(10,44),(55,44),(25,44),(37,44),(6,44),(46,44),(19,44),(44,44),(12,44),(50,44),(8,44),(56,44),(31,44),
(4,45),(47,45),(21,45),(38,45),(15,45),(52,45),(27,45),(35,45),(1,45),(57,45),(18,45),(41,45),(11,45),(59,45),(24,45),(36,45),(7,45),(49,45),(20,45),(43,45),(13,45),(51,45),(9,45),(54,45),(30,45),
(5,46),(46,46),(22,46),(33,46),(14,46),(53,46),(26,46),(39,46),(2,46),(58,46),(16,46),(42,46),(10,46),(55,46),(25,46),(37,46),(6,46),(48,46),(19,46),(44,46),(12,46),(50,46),(8,46),(56,46),(31,46),
(3,47),(49,47),(23,47),(34,47),(13,47),(52,47),(28,47),(36,47),(1,47),(57,47),(17,47),(41,47),(11,47),(60,47),(24,47),(35,47),(7,47),(47,47),(18,47),(43,47),(20,47),(38,47),(9,47),(51,47),(30,47),
(4,48),(45,48),(21,48),(38,48),(15,48),(53,48),(27,48),(40,48),(2,48),(58,48),(18,48),(42,48),(10,48),(54,48),(25,48),(37,48),(6,48),(46,48),(19,48),(44,48),(12,48),(50,48),(8,48),(55,48),(31,48),
(5,49),(47,49),(22,49),(33,49),(14,49),(52,49),(26,49),(39,49),(1,49),(57,49),(16,49),(41,49),(11,49),(59,49),(24,49),(35,49),(7,49),(48,49),(18,49),(43,49),(20,49),(38,49),(9,49),(51,49),(30,49),
(3,50),(46,50),(23,50),(34,50),(13,50),(53,50),(28,50),(36,50),(2,50),(58,50),(17,50),(42,50),(10,50),(55,50),(25,50),(37,50),(6,50),(49,50),(19,50),(44,50),(12,50),(50,50),(8,50),(56,50),(31,50),

(4,51),(45,51),(21,51),(38,51),(15,51),(52,51),(27,51),(40,51),(1,51),(57,51),(18,51),(41,51),(11,51),(59,51),(24,51),(36,51),(7,51),(47,51),(20,51),(43,51),(13,51),(51,51),(9,51),(54,51),(30,51),
(5,52),(46,52),(22,52),(33,52),(14,52),(53,52),(26,52),(39,52),(2,52),(58,52),(16,52),(42,52),(10,52),(55,52),(25,52),(37,52),(6,52),(48,52),(19,52),(44,52),(12,52),(50,52),(8,52),(56,52),(31,52),
(3,53),(49,53),(23,53),(34,53),(13,53),(52,53),(28,53),(36,53),(1,53),(57,53),(17,53),(41,53),(11,53),(60,53),(24,53),(35,53),(7,53),(46,53),(18,53),(43,53),(20,53),(38,53),(9,53),(51,53),(30,53),
(4,54),(45,54),(21,54),(38,54),(15,54),(53,54),(27,54),(40,54),(2,54),(58,54),(18,54),(42,54),(10,54),(54,54),(25,54),(37,54),(6,54),(47,54),(19,54),(44,54),(12,54),(50,54),(8,54),(55,54),(31,54),
(5,55),(46,55),(22,55),(33,55),(14,55),(52,55),(26,55),(39,55),(1,55),(57,55),(16,55),(41,55),(11,55),(59,55),(24,55),(35,55),(7,55),(48,55),(18,55),(43,55),(20,55),(38,55),(9,55),(51,55),(30,55),
(3,56),(49,56),(23,56),(34,56),(13,56),(53,56),(28,56),(36,56),(2,56),(58,56),(17,56),(42,56),(10,56),(55,56),(25,56),(37,56),(6,56),(46,56),(19,56),(44,56),(12,56),(50,56),(8,56),(56,56),(31,56),
(4,57),(45,57),(21,57),(38,57),(15,57),(52,57),(27,57),(40,57),(1,57),(57,57),(18,57),(41,57),(11,57),(59,57),(24,57),(36,57),(7,57),(47,57),(20,57),(43,57),(13,57),(51,57),(9,57),(54,57),(30,57),
(5,58),(46,58),(22,58),(33,58),(14,58),(53,58),(26,58),(39,58),(2,58),(58,58),(16,58),(42,58),(10,58),(55,58),(25,58),(37,58),(6,58),(48,58),(19,58),(44,58),(12,58),(50,58),(8,58),(56,58),(31,58),
(3,59),(49,59),(23,59),(34,59),(13,59),(52,59),(28,59),(36,59),(1,59),(57,59),(17,59),(41,59),(11,59),(60,59),(24,59),(35,59),(7,59),(46,59),(18,59),(43,59),(20,59),(38,59),(9,59),(51,59),(30,59),
(4,60),(45,60),(21,60),(38,60),(15,60),(53,60),(27,60),(40,60),(2,60),(58,60),(18,60),(42,60),(10,60),(54,60),(25,60),(37,60),(6,60),(47,60),(19,60),(44,60),(12,60),(50,60),(8,60),(55,60),(31,60);


-- Inquéritos
INSERT INTO INQUERITO (id_inquerito, perguntas) VALUES
(1,
'1. Como avalia o evento?
2. Recomendaria o evento a um amigo?
3. Que jogos gostaria de ver na próxima edição?
4. Como classifica a organização?
5. Avalie a pontualidade das partidas.
6. Comentários adicionais?');

-- Respostas 
INSERT INTO RESPOSTA (id_jogador, id_inquerito, resposta) VALUES
(1001,1,'1. Muito bom. 2. Sim. 3. CS2. 4. Excelente. 5. Pontual. 6. Evento bem organizado.'),
(1004,1,'1. Bom. 2. Sim. 3. Valorant. 4. Boa organização. 5. Poucos atrasos. 6. Staff simpático.'),
(1007,1,'1. Excelente. 2. Sim. 3. League of Legends. 4. Muito boa. 5. Horários cumpridos. 6. Experiência incrível.'),
(1010,1,'1. Razoável. 2. Talvez. 3. CS2 e Valorant. 4. Boa. 5. Alguns atrasos. 6. Podia haver mais variedade.'),
(1013,1,'1. Muito bom. 2. Sim. 3. Overwatch 2. 4. Excelente. 5. Muito pontual. 6. Gostei bastante.'),
(1016,1,'1. Bom. 2. Sim. 3. Rainbow Six Siege. 4. Organizado. 5. Horários aceitáveis. 6. Boa experiência.'),
(1019,1,'1. Médio. 2. Não sei. 3. CS2. 4. Razoável. 5. Alguns atrasos. 6. Som alto demais.'),
(1022,1,'1. Excelente. 2. Sim. 3. Valorant e CS2. 4. Muito boa. 5. Perfeita. 6. Quero voltar.'),
(1025,1,'1. Bom. 2. Sim. 3. League of Legends. 4. Boa organização. 5. Pontualidade boa. 6. Evento divertido.'),
(1028,1,'1. Muito bom. 2. Sim. 3. Valorant. 4. Excelente. 5. Bem organizada. 6. Mais torneios 5v5 seriam ótimos.'),
(1031,1,'1. Excelente. 2. Sim. 3. CS2 e League of Legends. 4. Muito organizada. 5. Sem atrasos. 6. Staff impecável.'),
(1034,1,'1. Bom. 2. Sim. 3. Dota 2. 4. Boa. 5. Horários corretos. 6. Boa experiência competitiva.'),
(1037,1,'1. Muito bom. 2. Sim. 3. Valorant. 4. Excelente. 5. Muito pontual. 6. Nada a apontar.'),
(1040,1,'1. Bom. 2. Sim. 3. CS2. 4. Bem organizada. 5. Alguns atrasos leves. 6. Evento divertido.'),
(1043,1,'1. Excelente. 2. Sim. 3. League of Legends e Valorant. 4. Muito boa. 5. Horários perfeitos. 6. Evento fantástico.'),
(1046,1,'1. Bom. 2. Sim. 3. Rainbow Six Siege. 4. Boa organização. 5. Pontual. 6. Voltaria certamente.'),
(1049,1,'1. Muito bom. 2. Sim. 3. CS2 competitivo. 4. Excelente organização. 5. Muito pontual. 6. Grande ambiente.'),
(1052,1,'1. Razoável. 2. Talvez. 3. Valorant. 4. Média. 5. Alguns atrasos. 6. Melhorar setups.'),
(1055,1,'1. Excelente. 2. Sim. 3. CS2 e Valorant. 4. Muito organizada. 5. Horários perfeitos. 6. Evento memorável.'),
(1058,1,'1. Bom. 2. Sim. 3. League of Legends. 4. Boa organização. 5. Bastante pontual. 6. Staff disponível.'),
(1061,1,'1. Muito bom. 2. Sim. 3. Overwatch 2. 4. Excelente. 5. Horários corretos. 6. Adorei participar.'),
(1064,1,'1. Excelente. 2. Sim. 3. CS2 e Rainbow Six Siege. 4. Muito organizada. 5. Sem atrasos. 6. Quero mais edições.'),
(1067,1,'1. Bom. 2. Sim. 3. Valorant. 4. Boa. 5. Pontualidade aceitável. 6. Evento bem conseguido.'),
(1070,1,'1. Excelente. 2. Sim. 3. League of Legends e CS2. 4. Excelente organização. 5. Muito pontual. 6. Parabéns pela iniciativa.');

-- ------------------------------------------------------------
-- 5.2 CRIAÇÃO DE UTILIZADORES E GESTÃO DE PERMISSÕES
-- ------------------------------------------------------------

-- Utilizador administrador (todos os privilégios)
CREATE USER IF NOT EXISTS 'admin_torneio'@'localhost' IDENTIFIED BY 'admin2026';
GRANT ALL PRIVILEGES ON UMGW.* TO 'admin_torneio'@'localhost';

-- Utilizador de consulta (só leitura)
CREATE USER IF NOT EXISTS 'consulta_torneio'@'localhost' IDENTIFIED BY 'consulta2026';
GRANT SELECT ON UMGW.* TO 'consulta_torneio'@'localhost';

-- Utilizador para gestão de equipas (inserir e consultar)
CREATE USER IF NOT EXISTS 'gestor_equipas'@'localhost' IDENTIFIED BY 'equipas2026';
GRANT SELECT, INSERT, UPDATE ON UMGW.EQUIPA TO 'gestor_equipas'@'localhost';
GRANT SELECT, INSERT, UPDATE ON UMGW.JOGADOR TO 'gestor_equipas'@'localhost';
GRANT SELECT, INSERT, UPDATE ON UMGW.INSCRICAO_EQUIPA TO 'gestor_equipas'@'localhost';
GRANT SELECT ON UMGW.JOGO TO 'gestor_equipas'@'localhost';
GRANT SELECT ON UMGW.PARTICIPA TO 'gestor_equipas'@'localhost';

-- Utilizador para gestão de eventos (partidas e resultados)
CREATE USER IF NOT EXISTS 'gestor_eventos'@'localhost' IDENTIFIED BY 'eventos2026';
GRANT SELECT, INSERT, UPDATE ON UMGW.PARTIDA TO 'gestor_eventos'@'localhost';
GRANT SELECT, INSERT, UPDATE ON UMGW.JOGA TO 'gestor_eventos'@'localhost';
GRANT SELECT, INSERT, UPDATE ON UMGW.SUPERVISAO TO 'gestor_eventos'@'localhost';
GRANT SELECT ON UMGW.JOGO TO 'gestor_eventos'@'localhost';
GRANT SELECT ON UMGW.ARENA TO 'gestor_eventos'@'localhost';
GRANT SELECT ON UMGW.EQUIPA TO 'gestor_eventos'@'localhost';
GRANT SELECT ON UMGW.STAFF TO 'gestor_eventos'@'localhost';

-- Aplicar as alterações
FLUSH PRIVILEGES;

-- ------------------------------------------------------------
-- 5.7 INDEXAÇÃO
-- ------------------------------------------------------------
CREATE INDEX idx_jogador_nome ON JOGADOR (nome);
CREATE INDEX idx_partida_data ON PARTIDA (data);
CREATE INDEX idx_equipa_nome ON EQUIPA (nome);
CREATE INDEX idx_joga_equipa ON JOGA (id_equipa);

-- JOGA: resultados por partida e por jogo
CREATE INDEX idx_joga_partida ON JOGA (id_partida);
CREATE INDEX idx_joga_jogo ON JOGA (id_jogo);

-- PARTIDA: filtragem por jogo, arena e ordenação cronológica
CREATE INDEX idx_partida_jogo ON PARTIDA (id_jogo);
CREATE INDEX idx_partida_arena ON PARTIDA (id_arena);
CREATE INDEX idx_partida_data_hora ON PARTIDA (data, hora_inicio);

-- INSCRICAO_EQUIPA: consultas por equipa e por jogador
CREATE INDEX idx_inscricao_equipa ON INSCRICAO_EQUIPA (id_equipa);
CREATE INDEX idx_inscricao_jogador ON INSCRICAO_EQUIPA (id_jogador);

-- SUPERVISAO: staff por partida e partidas por staff
CREATE INDEX idx_supervisao_partida ON SUPERVISAO (id_partida);
CREATE INDEX idx_supervisao_staff ON SUPERVISAO (id_staff);

-- ASSISTE: espectadores de uma partida e partidas de um espectador
CREATE INDEX idx_assiste_partida ON ASSISTE (id_partida);
CREATE INDEX idx_assiste_espectador ON ASSISTE (id_espectador);

-- RESPOSTA: respostas a um inquérito
CREATE INDEX idx_resposta_inquerito ON RESPOSTA (id_inquerito);

-- PARTICIPA: equipas de um jogo 
CREATE INDEX idx_participa_equipa ON PARTICIPA (id_equipa);

-- JOGADOR: procura por email 
CREATE INDEX idx_jogador_email ON JOGADOR (email);

-- ------------------------------------------------------------
-- 4. VIEWS (Ponto 5.5)
-- ------------------------------------------------------------

-- 4.1 RANKING DE EQUIPAS POR JOGO
CREATE VIEW RANKING_EQUIPAS AS
SELECT 
    j.nome AS Jogo,
    e.nome AS Equipa,
    SUM(jo.resultado) AS Pontos_Total,
    COUNT(CASE WHEN jo.resultado = 2 THEN 1 END) AS Vitorias,
    COUNT(CASE WHEN jo.resultado = 0 THEN 1 END) AS Derrotas,
    COUNT(CASE WHEN jo.resultado = 1 THEN 1 END) AS Empates
FROM JOGA jo
JOIN EQUIPA e ON jo.id_equipa = e.id_equipa
JOIN JOGO j ON jo.id_jogo = j.id_jogo
GROUP BY jo.id_jogo, e.id_equipa
ORDER BY Pontos_Total DESC;

-- 4.2 JOGADORES INSCRITOS E RESPETIVAS EQUIPAS
CREATE VIEW JOGADORES_INSCRITOS AS
SELECT 
    jg.nome AS Jogador,
    e.nome AS Equipa,
    j.nome AS Jogo
FROM JOGADOR jg
JOIN INSCRICAO_EQUIPA ie ON jg.id_jogador = ie.id_jogador
JOIN EQUIPA e ON ie.id_equipa = e.id_equipa
JOIN PARTICIPA p ON e.id_equipa = p.id_equipa
JOIN JOGO j ON p.id_jogo = j.id_jogo;

-- 4.3 PARTIDAS COM NÚMERO DE ESPECTADORES
CREATE VIEW PARTIDAS_COM_ESPECTADORES AS
SELECT 
    p.id_partida,
    j.nome AS Jogo,
    a.numero_arena AS Arena,
    COUNT(aa.id_espectador) AS Num_Espectadores
FROM PARTIDA p
JOIN JOGO j ON p.id_jogo = j.id_jogo
JOIN ARENA a ON p.id_arena = a.id_arena
LEFT JOIN ASSISTE aa ON p.id_partida = aa.id_partida
GROUP BY p.id_partida, j.nome, a.numero_arena;

-- 4.4 STAFF ALOCADO A CADA PARTIDA
CREATE VIEW STAFF_PARTIDAS AS
SELECT 
    p.id_partida,
    j.nome AS Jogo,
    s.nome AS Staff,
    s.funcao AS Funcao
FROM SUPERVISAO sup
JOIN PARTIDA p ON sup.id_partida = p.id_partida
JOIN JOGO j ON p.id_jogo = j.id_jogo
JOIN STAFF s ON sup.id_staff = s.id_staff
ORDER BY p.id_partida, s.nome;

-- 4.5 CLASSIFICAÇÃO GERAL
CREATE VIEW CLASSIFICACAO_GERAL AS
SELECT 
    e.nome AS Equipa,
    SUM(jo.resultado) AS Pontos_Total,
    COUNT(CASE WHEN jo.resultado = 2 THEN 1 END) AS Vitorias,
    COUNT(CASE WHEN jo.resultado = 0 THEN 1 END) AS Derrotas,
    COUNT(CASE WHEN jo.resultado = 1 THEN 1 END) AS Empates
FROM JOGA jo
JOIN EQUIPA e ON jo.id_equipa = e.id_equipa
GROUP BY e.id_equipa, e.nome
ORDER BY Pontos_Total DESC;

-- 4.6 JOGADORES MULTI-JOGO (inscritos em mais do que um jogo)
CREATE VIEW JOGADORES_MULTIJOGO AS
SELECT 
    jg.nome AS Jogador,
    COUNT(DISTINCT j.id_jogo) AS Jogos_Diferentes,
    GROUP_CONCAT(DISTINCT j.nome ORDER BY j.nome SEPARATOR ', ') AS Jogos
FROM JOGADOR jg
JOIN INSCRICAO_EQUIPA ie ON jg.id_jogador = ie.id_jogador
JOIN EQUIPA e ON ie.id_equipa = e.id_equipa
JOIN PARTICIPA p ON e.id_equipa = p.id_equipa
JOIN JOGO j ON p.id_jogo = j.id_jogo
GROUP BY jg.id_jogador, jg.nome
HAVING COUNT(DISTINCT j.id_jogo) > 1
ORDER BY Jogos_Diferentes DESC;

-- 4.7 ESTATÍSTICAS POR JOGO (total equipas, partidas, espectadores)
CREATE VIEW ESTATISTICAS_POR_JOGO AS
SELECT 
    j.nome AS Jogo,
    COUNT(DISTINCT p.id_equipa) AS Num_Equipas,
    COUNT(DISTINCT part.id_partida) AS Num_Partidas,
    COUNT(DISTINCT aa.id_espectador) AS Num_Espectadores_Unicos
FROM JOGO j
LEFT JOIN PARTICIPA p ON j.id_jogo = p.id_jogo
LEFT JOIN PARTIDA part ON j.id_jogo = part.id_jogo
LEFT JOIN ASSISTE aa ON part.id_partida = aa.id_partida
GROUP BY j.id_jogo, j.nome;

-- 4.8 HORÁRIOS DAS EQUIPAS (calendário)
CREATE VIEW CALENDARIO_EQUIPAS AS
SELECT 
    e.nome AS Equipa,
    j.nome AS Jogo,
    p.data,
    p.hora_inicio,
    a.numero_arena AS Arena,
    jo.resultado
FROM JOGA jo
JOIN EQUIPA e ON jo.id_equipa = e.id_equipa
JOIN PARTIDA p ON jo.id_partida = p.id_partida
JOIN JOGO j ON p.id_jogo = j.id_jogo
JOIN ARENA a ON p.id_arena = a.id_arena
ORDER BY p.data, p.hora_inicio, e.nome;

-- 4.9 INQUÉRITOS COM RESPOSTAS
CREATE VIEW ANALISE_INQUERITOS AS
SELECT 
    i.perguntas AS Pergunta,
    COUNT(r.id_jogador) AS Total_Respostas,
    COUNT(DISTINCT r.id_jogador) AS Jogadores_Unicos,
    ROUND(COUNT(r.id_jogador) / (SELECT COUNT(*) FROM JOGADOR) * 100, 2) AS Taxa_Resposta_Percentual
FROM INQUERITO i
LEFT JOIN RESPOSTA r ON i.id_inquerito = r.id_inquerito
GROUP BY i.id_inquerito, i.perguntas
ORDER BY Total_Respostas DESC;

-- 4.10 EQUIPAS COMPLETAS
CREATE VIEW EQUIPAS_COMPLETAS AS
SELECT 
    e.nome AS Equipa,
    j.nome AS Jogo,
    COUNT(ie.id_jogador) AS Jogadores_Inscritos,
    CASE 
        WHEN COUNT(ie.id_jogador) = 5 THEN 'Completa'
        ELSE 'Incompleta'
    END AS Estado
FROM EQUIPA e
JOIN PARTICIPA p ON e.id_equipa = p.id_equipa
JOIN JOGO j ON p.id_jogo = j.id_jogo
LEFT JOIN INSCRICAO_EQUIPA ie ON e.id_equipa = ie.id_equipa
LEFT JOIN JOGADOR jg ON ie.id_jogador = jg.id_jogador
GROUP BY e.id_equipa, e.nome, j.id_jogo, j.nome
ORDER BY e.nome, j.nome;

-- ------------------------------------------------------------
-- 5.6 INTERROGAÇÕES SQL (Exemplos de execução)
-- ------------------------------------------------------------

-- 5.6.1 Ranking de equipas
SELECT * FROM RANKING_EQUIPAS;

-- 5.6.2 Jogadores da equipa 'Iscas com Elas'
SELECT jg.nome, jg.curso
FROM JOGADOR jg
JOIN INSCRICAO_EQUIPA ie ON jg.id_jogador = ie.id_jogador
JOIN EQUIPA e ON ie.id_equipa = e.id_equipa
WHERE e.nome LIKE 'Iscas com Elas';

-- 5.6.3 Partidas de LoL com arena
SELECT 
    p.id_partida,
    p.data,
    p.hora_inicio,
    a.numero_arena AS Arena,
    e1.nome AS Equipa1,
    jo1.resultado AS Resultado_E1,
    e2.nome AS Equipa2,
    jo2.resultado AS Resultado_E2
FROM PARTIDA p
JOIN JOGA jo1 ON p.id_partida = jo1.id_partida AND jo1.id_jogo = p.id_jogo
JOIN EQUIPA e1 ON jo1.id_equipa = e1.id_equipa
JOIN JOGA jo2 ON p.id_partida = jo2.id_partida AND jo2.id_jogo = p.id_jogo AND jo2.id_equipa != jo1.id_equipa
JOIN EQUIPA e2 ON jo2.id_equipa = e2.id_equipa
JOIN ARENA a ON p.id_arena = a.id_arena
JOIN JOGO j ON p.id_jogo = j.id_jogo
WHERE j.nome = 'League of Legends' AND e1.id_equipa < e2.id_equipa;

-- 5.6.4 Staff da partida 1
SELECT s.nome, s.funcao, s.email
FROM STAFF s
JOIN SUPERVISAO sup ON s.id_staff = sup.id_staff
WHERE sup.id_partida = 1;

-- 5.6.5 Espectadores de LoL
SELECT DISTINCT esp.nome, esp.email
FROM ESPECTADOR esp
JOIN ASSISTE a ON esp.id_espectador = a.id_espectador
JOIN PARTIDA p ON a.id_partida = p.id_partida
JOIN JOGO j ON p.id_jogo = j.id_jogo
WHERE j.nome = 'League of Legends';

-- 5.6.6 Partidas com mais espectadores 
SELECT * FROM PARTIDAS_COM_ESPECTADORES
ORDER BY Num_Espectadores DESC;

-- 5.6.7 Staff que supervisionou partidas de League of Legends 
SELECT * FROM STAFF_PARTIDAS
WHERE Jogo = 'League of Legends';

-- 5.6.8 Quantas equipas estão inscritas em CS2?
SELECT 
    COUNT(DISTINCT p.id_equipa) AS total_equipas
FROM PARTICIPA p
JOIN JOGO j ON p.id_jogo = j.id_jogo
WHERE j.nome = 'CS2';

-- 5.6.9 Jogadores inscritos em CS2 e Valorant
SELECT 
    jg.id_jogador,
    jg.nome AS Jogador
FROM JOGADOR jg
JOIN INSCRICAO_EQUIPA ie ON jg.id_jogador = ie.id_jogador
JOIN PARTICIPA p ON ie.id_equipa = p.id_equipa
JOIN JOGO j ON p.id_jogo = j.id_jogo
WHERE j.nome IN ('CS2', 'Valorant')
GROUP BY jg.id_jogador, jg.nome
HAVING COUNT(DISTINCT j.nome) = 2;
    
-- 5.6.10 Qual o jogo com mais jogadores inscritos?
SELECT 
    j.nome AS Jogo,
    COUNT(DISTINCT ie.id_jogador) AS Total_Jogadores
FROM JOGO j
JOIN PARTICIPA p ON j.id_jogo = p.id_jogo
JOIN INSCRICAO_EQUIPA ie ON p.id_equipa = ie.id_equipa
GROUP BY j.id_jogo, j.nome
ORDER BY Total_Jogadores DESC
LIMIT 1;

-- 5.6.11 Horários das partidas de Valorant
SELECT 
    p.id_partida,
    p.data,
    p.hora_inicio,
    p.hora_fim
FROM PARTIDA p
JOIN JOGO j ON p.id_jogo = j.id_jogo
WHERE j.nome = 'Valorant'
ORDER BY p.data, p.hora_inicio;

-- 5.6.12 Jogadores que responderam ao inquérito e respetivas respostas
SELECT 
    jg.nome AS Jogador,
    i.perguntas AS Pergunta,
    r.resposta AS Resposta
FROM RESPOSTA r
JOIN JOGADOR jg ON r.id_jogador = jg.id_jogador
JOIN INQUERITO i ON r.id_inquerito = i.id_inquerito
ORDER BY jg.nome, i.id_inquerito;

-- 5.6.13 Partidas que terminaram em empate
SELECT 
    p.id_partida,
    j.nome AS Jogo,
    p.data,
    p.hora_inicio,
    GROUP_CONCAT(e.nome SEPARATOR ' vs ') AS Equipas,
    MIN(jo.resultado) AS Resultado
FROM PARTIDA p
JOIN JOGO j ON p.id_jogo = j.id_jogo
JOIN JOGA jo ON p.id_partida = jo.id_partida
JOIN EQUIPA e ON jo.id_equipa = e.id_equipa
GROUP BY p.id_partida, j.nome, p.data, p.hora_inicio
HAVING COUNT(DISTINCT jo.resultado) = 1;

-- ------------------------------------------------------------
-- 5.8 TRIGGERS, FUNÇÕES, PROCEDIMENTOS
-- ------------------------------------------------------------


-- ============================================================
-- TRIGGER 1: Limite de 5 jogadores por equipa
-- ============================================================
DELIMITER $$
CREATE TRIGGER verifica_limite_equipa
BEFORE INSERT ON INSCRICAO_EQUIPA
FOR EACH ROW
BEGIN
    DECLARE num INT;
    DECLARE em_substituicao BOOLEAN;

    SELECT ativa INTO em_substituicao FROM substituicao_controlo LIMIT 1;

    IF em_substituicao = FALSE THEN
        SELECT COUNT(*) INTO num
        FROM INSCRICAO_EQUIPA
        WHERE id_equipa = NEW.id_equipa;

        IF num >= 5 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: A equipa já tem 5 jogadores!';
        END IF;
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 2: Verificar horário da partida (hora_fim > hora_inicio)
-- ============================================================
DELIMITER $$
CREATE TRIGGER verifica_horario_partida
BEFORE INSERT ON PARTIDA
FOR EACH ROW
BEGIN
    IF NEW.hora_fim <= NEW.hora_inicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: A hora de fim deve ser posterior á hora de início.';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 3: Impedir que um jogador se inscreva em duas equipas do MESMO JOGO
-- ============================================================
DELIMITER $$
CREATE TRIGGER verifica_um_jogo_por_jogador
BEFORE INSERT ON INSCRICAO_EQUIPA
FOR EACH ROW
BEGIN
    DECLARE jogo_existente INT;

    SELECT DISTINCT p.id_jogo INTO jogo_existente
    FROM INSCRICAO_EQUIPA ie
    JOIN PARTICIPA p ON ie.id_equipa = p.id_equipa
    WHERE ie.id_jogador = NEW.id_jogador
      AND p.id_jogo IN (
          SELECT id_jogo FROM PARTICIPA WHERE id_equipa = NEW.id_equipa
      )
    LIMIT 1;   -- Tava a me dar erro e pus isto e correu

    IF jogo_existente IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O jogador já está inscrito numa equipa desse jogo!';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 4: Evitar sobreposição de partidas na mesma arena
-- ============================================================
DELIMITER $$
CREATE TRIGGER verifica_sobreposicao_arena
BEFORE INSERT ON PARTIDA
FOR EACH ROW
BEGIN
    DECLARE conflito INT;
    SELECT COUNT(*) INTO conflito
    FROM PARTIDA
    WHERE id_arena = NEW.id_arena
      AND data = NEW.data
      AND (
          (NEW.hora_inicio >= hora_inicio AND NEW.hora_inicio < hora_fim)   -- começa durante
          OR (NEW.hora_fim > hora_inicio AND NEW.hora_fim <= hora_fim)       -- termina durante
          OR (NEW.hora_inicio <= hora_inicio AND NEW.hora_fim >= hora_fim)   -- cobre todo o intervalo
      );
    IF conflito > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Arena já ocupada nesse horário.';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 5: Garantir exatamente 2 equipas por partida
-- ============================================================
DELIMITER $$
CREATE TRIGGER verifica_duas_equipas_por_partida
AFTER INSERT ON JOGA
FOR EACH ROW
BEGIN
    DECLARE total_equipas INT;
    SELECT COUNT(DISTINCT id_equipa) INTO total_equipas
    FROM JOGA
    WHERE id_partida = NEW.id_partida AND id_jogo = NEW.id_jogo;
    IF total_equipas > 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Uma partida não pode ter mais de 2 equipas.';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 6: Impedir remoção de última inscrição de uma equipa
-- ============================================================
DELIMITER $$
CREATE TRIGGER impede_remover_jogador_unico
BEFORE DELETE ON INSCRICAO_EQUIPA
FOR EACH ROW
BEGIN
    DECLARE total INT;
    DECLARE em_substituicao BOOLEAN;

    SELECT ativa INTO em_substituicao FROM substituicao_controlo LIMIT 1;

    IF em_substituicao = FALSE THEN
        SELECT COUNT(*) INTO total
        FROM INSCRICAO_EQUIPA
        WHERE id_equipa = OLD.id_equipa;

        IF total <= 5 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: Equipa deve ter pelo menos 5 jogadores inscritos.';
        END IF;
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- TRIGGER 7: Evitar sobreposição de horários para jogadores
-- ============================================================

DELIMITER $$
CREATE TRIGGER verifica_sobreposicao_jogador
BEFORE INSERT ON JOGA
FOR EACH ROW
BEGIN
    DECLARE conflito INT;
    -- Verifica se algum jogador da equipa que vai jogar já tem outra partida na mesma data/hora
    SELECT COUNT(*) INTO conflito
    FROM JOGA jo_existente
    JOIN PARTIDA p_existente ON jo_existente.id_partida = p_existente.id_partida
    JOIN INSCRICAO_EQUIPA ie_existente ON jo_existente.id_equipa = ie_existente.id_equipa
    WHERE ie_existente.id_jogador IN (
        SELECT ie.id_jogador
        FROM INSCRICAO_EQUIPA ie
        WHERE ie.id_equipa = NEW.id_equipa
    )
    AND p_existente.data = (SELECT data FROM PARTIDA WHERE id_partida = NEW.id_partida)
    AND p_existente.hora_inicio = (SELECT hora_inicio FROM PARTIDA WHERE id_partida = NEW.id_partida)
    AND p_existente.id_partida != NEW.id_partida; -- exclui a própria partida que está a ser inserida

    IF conflito > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Um ou mais jogadores já têm uma partida nesse horário.';
    END IF;
END$$
DELIMITER ;


-- ============================================================
-- TRIGGER 8: IMPEDIR que arena tenha mais do que a capacidade
-- ============================================================

DELIMITER $$
CREATE TRIGGER verifica_capacidade_arena
BEFORE INSERT ON ASSISTE
FOR EACH ROW
BEGIN
    DECLARE cap INT;
    DECLARE num_espectadores INT;

    -- Capacidade da arena onde a partida se realiza
    SELECT a.capacidade INTO cap
    FROM PARTIDA p
    JOIN ARENA a ON p.id_arena = a.id_arena
    WHERE p.id_partida = NEW.id_partida;

    -- Número atual de espectadores nessa partida
    SELECT COUNT(*) INTO num_espectadores
    FROM ASSISTE
    WHERE id_partida = NEW.id_partida;

    IF num_espectadores >= cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Capacidade da arena esgotada para esta partida.';
    END IF;
END$$
DELIMITER ;



-- ============================================================
-- FUNÇÃO 1: Total de pontos de uma equipa num jogo
-- ============================================================
DELIMITER $$
CREATE FUNCTION total_pontos_equipa(p_id_equipa INT, p_id_jogo INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT SUM(resultado) INTO total
    FROM JOGA
    WHERE id_equipa = p_id_equipa AND id_jogo = p_id_jogo;
    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

-- ============================================================
-- FUNÇÃO 2: Número de espectadores de uma partida
-- ============================================================
DELIMITER $$
CREATE FUNCTION espectadores_partida(p_id_partida INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num INT;
    SELECT COUNT(*) INTO num
    FROM ASSISTE
    WHERE id_partida = p_id_partida;
    RETURN num;
END$$
DELIMITER ;

-- ============================================================
-- FUNÇÃO 3: Total de espectadores únicos de um jogo
-- ============================================================
DELIMITER $$
CREATE FUNCTION total_espectadores_jogo(p_id_jogo INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT a.id_espectador) INTO total
    FROM ASSISTE a
    JOIN PARTIDA p ON a.id_partida = p.id_partida
    WHERE p.id_jogo = p_id_jogo;
    RETURN IFNULL(total, 0);
END$$
DELIMITER ;


-- ============================================================
-- PROCEDIMENTO 1: Inscrever jogador com validações
-- ============================================================
DELIMITER $$
CREATE PROCEDURE inscrever_jogador(
    IN p_id_jogador INT,
    IN p_id_equipa INT,
    IN p_estado VARCHAR(45),
    IN p_data DATE
)
BEGIN
    DECLARE num_elementos INT;

    -- Verifica se a equipa já tem 5 jogadores
    SELECT COUNT(*) INTO num_elementos
    FROM INSCRICAO_EQUIPA
    WHERE id_equipa = p_id_equipa;

    IF num_elementos >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: A equipa já está completa.';
    ELSE
        -- Insere a inscrição
        INSERT INTO INSCRICAO_EQUIPA (id_jogador, id_equipa, estado, data)
        VALUES (p_id_jogador, p_id_equipa, p_estado, p_data);
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- PROCEDIMENTO 2: Atualizar pontos das equipas após inserção de resultados
-- ============================================================
DELIMITER $$
CREATE PROCEDURE atualizar_pontos_equipa(
    IN p_id_partida INT,
    IN p_id_equipa INT,
    IN p_resultado INT
)
BEGIN
    -- Insere ou atualiza o resultado na tabela JOGA
    INSERT INTO JOGA (id_jogo, id_partida, id_equipa, resultado)
    SELECT p.id_jogo, p.id_partida, p_id_equipa, p_resultado
    FROM PARTIDA p
    WHERE p.id_partida = p_id_partida
    ON DUPLICATE KEY UPDATE resultado = p_resultado;
END$$
DELIMITER ;


-- ============================================================
-- PROCEDIMENTO 3: Substituir um jogador de uma equipa
-- ============================================================

DELIMITER $$
CREATE PROCEDURE substituir_jogador(
    IN p_id_equipa INT,
    IN p_id_jogador_sair INT,
    IN p_id_jogador_entrar INT,
    IN p_estado VARCHAR(45),
    IN p_data DATE
)
BEGIN
    DECLARE num_antes INT;

    -- Verifica se o jogador que vai sair realmente está na equipa
    SELECT COUNT(*) INTO num_antes
    FROM INSCRICAO_EQUIPA
    WHERE id_equipa = p_id_equipa AND id_jogador = p_id_jogador_sair;

    IF num_antes = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O jogador a substituir não pertence a esta equipa.';
    END IF;

    -- Ativar modo substituição
    UPDATE substituicao_controlo SET ativa = TRUE WHERE id = 1;

    -- Remover o jogador antigo
    DELETE FROM INSCRICAO_EQUIPA
    WHERE id_equipa = p_id_equipa AND id_jogador = p_id_jogador_sair;

    -- Inserir o novo jogador
    INSERT INTO INSCRICAO_EQUIPA (id_jogador, id_equipa, estado, data)
    VALUES (p_id_jogador_entrar, p_id_equipa, p_estado, p_data);

    -- Desativar modo substituição
    UPDATE substituicao_controlo SET ativa = FALSE WHERE id = 1;
END$$
DELIMITER ;


-- Isto aqui n precisam de correr é simplesmente para ver se as funcoes e isso tao a funcionar direito:
-- Quer dizer n é para ignorar mas tipo voçês entendem é mais para mostrar ao stor

-- Isto é melhor executar indidualemnte que é mais facil assim 

-- ================================================================
-- BLOCO DE TESTES DOS MECANISMOS (PONTO 5.8).
-- ================================================================

-- ----------------------------------------------------------------
-- TESTE 1: TRIGGER 1 – Limite de 5 jogadores por equipa
-- ----------------------------------------------------------------
-- A equipa 1 já tem 5 jogadores.
-- Deve FALHAR com "A equipa já tem 5 jogadores!"
INSERT INTO INSCRICAO_EQUIPA (id_jogador, id_equipa, estado, data)
VALUES (1016, 1, 'Confirmada', '2026-04-10');

-- ----------------------------------------------------------------
-- TESTE 2: TRIGGER 2 – Horário de partida inválido
-- ----------------------------------------------------------------
-- hora_fim <= hora_inicio
-- Deve FALHAR com "A hora de fim deve ser posterior à hora de início."
INSERT INTO PARTIDA (data, hora_inicio, hora_fim, id_jogo, id_arena)
VALUES ('2026-05-10', '14:00:00', '14:00:00', 1, 1);

-- ----------------------------------------------------------------
-- TESTE 3: TRIGGER 3 – Jogador em duas equipas do mesmo jogo
-- ----------------------------------------------------------------
-- O jogador 1003 (Pedro Santos) já está na equipa 1.
-- Tentamos inscrevê-lo nos Fénix_LoL (equipa 3, também LoL).
-- Deve FALHAR com "O jogador já está inscrito numa equipa desse jogo!"
INSERT INTO INSCRICAO_EQUIPA (id_jogador, id_equipa, estado, data)
VALUES (1003, 3, 'Confirmada', '2026-04-10');

-- ----------------------------------------------------------------
-- TESTE 4: TRIGGER 4 – Sobreposição de arena
-- ----------------------------------------------------------------
-- Já existe uma partida na arena 1, dia 2026-05-10, 14:00-15:00.
-- Tentamos inserir uma partida no mesmo dia/arena com horário sobreposto.
-- Deve FALHAR com "Arena já ocupada nesse horário."
INSERT INTO PARTIDA (data, hora_inicio, hora_fim, id_jogo, id_arena)
VALUES ('2026-05-10', '14:30:00', '15:30:00', 1, 1);

-- ----------------------------------------------------------------
-- TESTE 5: TRIGGER 5 – Limite de 2 equipas por partida 
-- ----------------------------------------------------------------
-- A partida 1 já tem 2 equipas .
-- Tentamos inserir uma terceira equipa.
-- Deve FALHAR com "Uma partida não pode ter mais de 2 equipas."
INSERT INTO JOGA (id_jogo, id_partida, id_equipa, resultado)
VALUES (1, 1, 3, 0);

-- ----------------------------------------------------------------
-- TESTE 6: TRIGGER 6 – Impedir remoção de inscrição 
-- ----------------------------------------------------------------
-- Equipa 1 tem exatamente 5 jogadores.
-- Tentar apagar um deles deve FALHAR.
DELETE FROM INSCRICAO_EQUIPA WHERE id_jogador = 1001 AND id_equipa = 1;

-- ----------------------------------------------------------------
-- TESTE 8: FUNÇÃO 1 – total_pontos_equipa
-- ----------------------------------------------------------------
-- Pontos dos id_equipa=1 no LoL id_jogo=1
SELECT total_pontos_equipa(1, 1) AS Pontos_Winx;

-- ----------------------------------------------------------------
-- TESTE 9: FUNÇÃO 2 – espectadores_partida
-- ----------------------------------------------------------------
-- Espectadores da partida 1
SELECT espectadores_partida(1) AS Espectadores_Partida1;

-- ----------------------------------------------------------------
-- TESTE 10: FUNÇÃO 3 – total_espectadores_jogo
-- ----------------------------------------------------------------
-- Espectadores únicos de LoL (id_jogo=1)
SELECT total_espectadores_jogo(1) AS Espectadores_LoL;

-- ----------------------------------------------------------------
-- TESTE 11: PROCEDIMENTO 1 – inscrever_jogador (com validação)
-- ----------------------------------------------------------------
-- 11.1 Tentar inscrever num equipa cheia (id_equipa=1) – Deve FALHAR
CALL inscrever_jogador(1016, 1, 'Confirmada', '2026-04-10');

-- 11.2 Criar equipa vazia e inscrever um jogador que ainda não está no LoL
INSERT INTO EQUIPA (nome) VALUES ('Equipa Proc');
INSERT INTO PARTICIPA (id_jogo, id_equipa) VALUES (1, (SELECT id_equipa FROM EQUIPA WHERE nome = 'Equipa Proc'));

-- Criar um jogador de teste que não pertence a nenhuma equipa
INSERT INTO JOGADOR (id_jogador, nome, curso, email, telemovel)
VALUES (2001, 'Teste Proc', NULL, 'teste.proc@ua.pt', '910000000');

-- Inscrever o jogador de teste na nova equipa (deve funcionar)
CALL inscrever_jogador(2001, (SELECT id_equipa FROM EQUIPA WHERE nome = 'Equipa Proc'), 'Confirmada', '2026-04-10');

-- Verificar que foi inserido
SELECT * FROM INSCRICAO_EQUIPA WHERE id_equipa = (SELECT id_equipa FROM EQUIPA WHERE nome = 'Equipa Proc');


-- ----------------------------------------------------------------
-- TESTE 12: PROCEDIMENTO 2 – atualizar_pontos_equipa
-- ----------------------------------------------------------------
-- Atualiza o resultado da partida 1, equipa 1 para 2 pontos
-- A partida 1 tem as equipas 1 e 2 xd
CALL atualizar_pontos_equipa(1, 1, 2);
-- Verifica se o resultado foi alterado 
SELECT * FROM JOGA WHERE id_partida = 1 AND id_equipa = 1;
-- Volta para o valor original (2) 
UPDATE JOGA SET resultado = 2 WHERE id_partida = 1 AND id_equipa = 1;


-- ----------------------------------------------------------------
-- TESTE 13: TRIGGER 7 – Sobreposição de horários de jogadores
-- ----------------------------------------------------------------
-- O jogador 1001 (João Silva) já joga na partida 1 (LoL, 2026-05-10, 14:00),
-- através da equipa 1 (Winx).
-- Tentamos colocar-lo noutra partida (Valorant) com a equipa 15 (Azeiteiros de Gaia)
-- no mesmo dia e hora. Deve FALHAR porque o João não pode estar em dois sítios ao mesmo tempo.
INSERT INTO PARTIDA (data, hora_inicio, hora_fim, id_jogo, id_arena)
VALUES ('2026-05-10', '14:00:00', '15:00:00', 2, 2);               -- Nova partida de Valorant

SET @nova = LAST_INSERT_ID();                                        -- Guarda o ID gerado

INSERT INTO JOGA (id_jogo, id_partida, id_equipa, resultado)
VALUES (2, @nova, 15, 2);                                            -- Inscreve Azeiteiros de Gaia deve FALAHR


-- ----------------------------------------------------------------
-- TESTE 14: TRIGGER 8 – Capacidade da arena excedida
-- ----------------------------------------------------------------
-- A partida 1 está na arena 1, que tem capacidade 50.
-- Vamos tentar registar o 51.º espectador.

-- Temos de ver quantas pessoas estão
SELECT capacidade FROM ARENA WHERE id_arena = 1;

-- Adicionar espectadores até atingir o maximo
INSERT INTO ASSISTE (id_espectador, id_partida)
VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), 
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 1), (12, 1), (13, 1), (14, 1), (15, 1),
(16, 1), (17, 1), (18, 1), (19, 1), (20, 1),
(21, 1), (22, 1), (23, 1), (24, 1), (25, 1);

-- Agora tentamos inserir mais um espectador (o 51.º).
-- Deve FALHAR com "Erro: Capacidade da arena esgotada para esta partida."
INSERT INTO ASSISTE (id_espectador, id_partida)
VALUES (26, 1);


-- ----------------------------------------------------------------
-- TESTE 15: PROCEDIMENTO 3 – Substituir jogador
-- ----------------------------------------------------------------
-- A equipa 1 (Winx) tem 5 jogadores: 1001, 1002, 1003, 1004, 1005.
-- Substituímos o João Silva (1001) por um jogador novo (2002).

-- 1. Criar um jogador de teste
INSERT INTO JOGADOR (id_jogador, nome, curso, email, telemovel) VALUES
(2002, 'Substituto Teste', NULL, 'substituto.teste@ua.pt', '919000000');

-- 2. Estado antes da substituição
SELECT * FROM INSCRICAO_EQUIPA WHERE id_equipa = 1;

-- 3. Substituir João Silva (1001) pelo jogador Teste (2002)
CALL substituir_jogador(1, 1001, 2002, 'Confirmada', '2026-05-15');
-- Estado após a substituição (2002 no lugar do 1001)
SELECT * FROM INSCRICAO_EQUIPA WHERE id_equipa = 1;

-- ================================================================
-- FIM DO BLOCO DE TESTES
-- ================================================================



-- ------------------------------------------------------------
-- FIM DO SCRIPT
-- ------------------------------------------------------------
