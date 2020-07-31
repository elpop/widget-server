CREATE SEQUENCE match_seq;

CREATE TABLE match
(
  id            bigint       not null 
                                 DEFAULT NEXTVAL('match_seq') primary key,
  status        integer      not null default (10001),
  name          varchar(50)  not null,
  place         varchar(50)  null,
  date_time     timestamp    not null default(now()),
  score_type    char(1)      not null default('P') /* P => Points, T => Time, B => Both (Points and Time) */
);

CREATE UNIQUE INDEX un_matchs_name ON match(name);

CREATE SEQUENCE player_Seq;

CREATE TABLE player
(
  id            bigint       not null 
                                 DEFAULT NEXTVAL('player_seq') primary key,
  status        integer      not null default (10001),
  name          varchar(50)  not null,
  color         varchar(6)   not null default('FFFFFF'),
  logo          varchar(50)  null
);

CREATE UNIQUE INDEX un_player_name ON player(name);

CREATE SEQUENCE match_player_seq;

CREATE TABLE match_player
(
  id            bigint       not null 
                                 DEFAULT NEXTVAL('match_player_seq') primary key,
  status        integer      not null default (10001),
  match_id      bigint       references match(id),
  player_id     bigint       references player(id)
);

CREATE UNIQUE INDEX UN_match_player ON match_player(match_id, player_ID);

create sequence score_seq;

create table score
(
  id              bigint    not null
                                DEFAULT NEXTVAL('score_seq') primary key,
                                 
  match_player_id bigint    not null references match_player(id),                             
  date_time       timestamp not null default(now()),
  points          real      null,
  record_time     real      null
);

/* Sample Data */

insert into match (name, place) values('Hogwarts Quidditch Cup 2020','Hogwarts Quidditch Stadium');
insert into player (name, color, logo) values('Gryffindor','C33D44','Gryffindor.jpg');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),10);
insert into player (name, color, logo) values('Hufflepuff','FEF075','Hufflepuff.jpg');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),12);

insert into match (name, place) values('Hogwarts Quidditch semifinals','Dark Lake');
insert into player (name, color, logo) values('Ravenclaw','252B8D', 'Ravenclaw.jpg');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),11);
insert into player (name, color, logo) values('Slytherin' ,'33A172','Slytherin.jpg');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),17);

insert into match (name, place) values('Triwizard Tournament','Dark Lake');
insert into player (name, color, logo) values('Victor Krum','A7B68F','DurmstrangCrest.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),2);
insert into player (name, color, logo) values('Fleur Delacour','519D8D','BeauxbatonsCrest.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),3);
insert into player (name, color, logo) values('Cedric Diggory','FEDC00','HogwartsCrest.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),4);
insert into player (name, color, logo) values('Harry Potter','FEDC00','HogwartsCrest.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,points) values(currval('match_player_seq'),3);

insert into match (name, place, score_type) values('Men''s 200m individual medley Final','','T');
insert into player (name, color, logo) values('Michael Phelps','FFFFFF','us.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),114.66);
insert into player (name, color, logo) values('Kosuke Hagino','FFFFFF','jp.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),116.61);
insert into player (name, color, logo) values('Wang Shun','FFFFFF','cn.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),117.05);
insert into player (name, color, logo) values('Hiromasa Fujimori','FFFFFF','jp.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),117.21);
insert into player (name, color, logo) values('Ryan Lochte','FFFFFF','us.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),117.47);
insert into player (name, color, logo) values('Philip Heintz','FFFFFF','de.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),117.48);
insert into player (name, color, logo) values('Thiago Pereira','FFFFFF','br.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),118.02);
insert into player (name, color, logo) values('Daniel Wallace','FFFFFF','uk.png');
insert into match_player(match_id, player_id) values(currval('match_seq'),currval('player_seq'));
insert into score (match_player_id,record_time) values(currval('match_player_seq'),118.54);

