create extension if not exists btree_gist;

create sequence if not exists test_sequence
minvalue 100
maxvalue 200
increment 5;
