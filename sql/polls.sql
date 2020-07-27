CREATE SEQUENCE Poll_Seq;

CREATE TABLE Poll
(
  ID          integer      not null 
                           DEFAULT NEXTVAL('Poll_Seq') primary key,
  Status      integer      not null default (10001),
  Description varchar(30)  not null,
  start_time  timestamp    not null default(now()),
  end_time    timestamp    not null
);

CREATE UNIQUE INDEX UN_Poll_Description ON Poll(Description);

CREATE SEQUENCE Poll_Questions_Seq;

CREATE TABLE Poll_Questions
(
  ID            integer      not null 
                                 DEFAULT NEXTVAL('Poll_Questions_Seq') primary key,
  Poll_ID       integer      not null references Poll (ID),
  Status        integer      not null default (10001),
  Description   varchar(50)  not null,
  Color         varchar(6)   not null default('FFFFFF')
);

CREATE UNIQUE INDEX UN_Poll_ID_Description ON Poll_Questions (ID, Poll_ID, Description);

create sequence Votes_seq;

create table Votes
(
  ID               bigint    not null
                                 DEFAULT NEXTVAL('Votes_seq') primary key,
  Poll_Question_ID integer   not null references Poll_Questions (ID),                             
  Status           integer   not null default(10001),
  Date_Time        Timestamp not null default(now()),
  Value            bigint    not null default(1)
);

/* Sample Data */

insert into Poll (Description, end_time) values('Hogwarts Houses', (now() + interval '1 month'));
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Gryffindor','C33D44');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 10);
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Hufflepuff','FEF075');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 7);
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Ravenclaw','252B8D');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 8);
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Slytherin','33A172');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 12);

insert into Poll (Description, end_time) values('2020 Presidential Election', (now() + interval '1 month'));
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Donald John Trump','ff0000');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 7945765);
insert into Poll_Questions (Poll_ID, Description, Color) values(currval('Poll_Seq'),'Joseph Robinette Biden Jr.','0000ff');
insert into Votes (Poll_Question_ID, Value) values(currval('Poll_Questions_Seq'), 12743298);

