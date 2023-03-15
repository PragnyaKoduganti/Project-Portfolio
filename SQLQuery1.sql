create table Business(
id int primary key,
name varchar(500) not null,
images binary,
);

create table States(
id int primary key,
name varchar(500) not null,
foreign key(id) references Business(id) on update cascade on delete cascade,
);

create table Building(
id int primary key,
Buildid int,
addresses varchar(500) not null,
foreign key(Buildid) references States(id) on update cascade on delete set null,
);

create table BusinessLocation(
id int primary key,
LocatedAt int,
PartOf int,
PrimaryLocatedAt int,
Descriptions  varchar(5000),
foreign key(LocatedAt) references Building(id) on update cascade on delete set null,
foreign key(PartOf) references Business(id) on update cascade on delete set null,
foreign key(PrimaryLocatedAt) references Business(id) on update cascade on delete set null,
unique(PrimaryLocatedAt), 
);

create table NetworkProvider(
id int primary key,
foreign key(id) references Business(id) on update cascade on delete cascade,
);



create table network(
id int primary key,
WithinState int,
IsProvidedBy int,
NetworkType varchar(20) check(NetworkType in('terrestrial','microwave','electric','satellite')),
capacity float(6) not null,
cost varchar(500) not null,
foreign key(WithinState) references States(id) on update cascade on delete set null,
foreign key(IsProvidedBy) references NetworkProvider(id) on update cascade on delete set null,
);


create table Connection(
ConnectedBy int,
ConnectedTo int,
usage float(6) not null,
foreign key(ConnectedBy) references network(id) on update cascade on delete cascade,
foreign key(ConnectedTo) references BusinessLocation(id) on update cascade on delete cascade,
primary key(ConnectedBy, ConnectedTo),
);

create table LogoBusiness(
buildlogo int references Business(id) on update cascade on delete cascade,
images binary,
primary key(buildlogo,images),
);


