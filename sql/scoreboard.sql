CREATE SEQUENCE Matchs_Seq;

CREATE TABLE Matchs
(
  ID            bigint       not null 
                                 DEFAULT NEXTVAL('Matchs_Seq') primary key,
  Status        integer      not null default (10001),
  Name          varchar(50)  not null,
  Place         varchar(50)  null,
  date_time     timestamp    not null default(now())
);

CREATE UNIQUE INDEX UN_Matchs_Name ON Matchs(Name);

CREATE SEQUENCE Teams_Seq;

CREATE TABLE Teams
(
  ID            bigint       not null 
                                 DEFAULT NEXTVAL('Teams_Seq') primary key,
  Status        integer      not null default (10001),
  Name          varchar(50)  not null,
  Color         varchar(6)   not null default('FFFFFF'),
  Logo          varchar(50)  null
);

CREATE UNIQUE INDEX UN_Teams_Names ON Teams(Name);

CREATE SEQUENCE Matchs_Teams_Seq;

CREATE TABLE Matchs_Teams
(
  ID            bigint       not null 
                                 DEFAULT NEXTVAL('Matchs_Teams_Seq') primary key,
  Status        integer      not null default (10001),
  Match_ID      bigint       references Matchs(ID),
  Teams_ID      bigint       references Teams(ID)
);

CREATE UNIQUE INDEX UN_Matchs_Teams ON Matchs_Teams(Match_ID, Teams_ID);

create sequence Points_seq;

create table Points
(
  ID               bigint     not null
                                 DEFAULT NEXTVAL('Points_seq') primary key,
                                 
  Matchs_Teams_ID  bigint     not null references Matchs_Teams(ID),                             
  Points           integer    not null default(1),
  date_time        timestamp  not null default(now())
);

/* Sample Data */

insert into Matchs (Name, Place) values('Hogwarts Quidditch Cup 2020','Hogwarts Quidditch Stadium');

insert into Teams (Name, Color, Logo) values('Gryffindor','C33D44','Gryffindor.jpg');
insert into Teams (Name, Color, Logo) values('Hufflepuff','FEF075','Hufflepuff.jpg');
insert into Teams (Name, Color, Logo) values('Ravenclaw','252B8D', 'Ravenclaw.jpg');
insert into Teams (Name, Color, Logo) values('Slytherin' ,'33A172','Slytherin.jpg');

