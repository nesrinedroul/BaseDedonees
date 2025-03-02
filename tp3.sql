connect ing/psw ;
create user USERFOUR identified by psw1 default tablespace
Livraison_TBS temporary tablespace Livraison_TempTBS;
connect system/29112004;
desc dba_users;
select username,created from dba_users where username='USERFOUR';
connect userfour/psw1; -- DOESNT HAVE PRIVILEGES TO DO SO
connect ing/psw;
grant create session to userfour;
CONNECT system/psw;
desc dba_sys_privs;
select privilege , admin_option from dba_sys_privs where grantee='USERFOUR';
connect userfour/psw1;
select privilege , admin_option from user_sys_privs;
connect ing/psw;
grant create table , create view , create user to USERFOUR; --
create table test (a integer, b char(1));
alter user USERFOUR quota unlimited on LIVRAISON_TBS;
create table test (a integer, b char(1));
select table_name from tabs;
insert into test values (1, 'b');
select * from test;
select object_name, object_type from user_objects;
create view view1 as select a from test;