-- DB構築するクエリをここへ記載したりする。複数のクエリを配置してもOK。pd_dumpしたものでもOK。以下はサンプル。

CREATE USER test_pg_user WITH PASSWORD 'test_pg_user_passwd' CREATEDB;
CREATE DATABASE test_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';
ALTER DATABASE test_db OWNER TO test_pg_user;

\connect test_db

SET statement_timeout = 0;
-- SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

CREATE SCHEMA test_schema;


ALTER SCHEMA test_schema OWNER TO test_pg_user;
ALTER USER test_pg_user SET search_path TO test_schema;

SET search_path = test_schema, pg_catalog;


CREATE TABLE test_schema.users
(
	-- ユーザ名
	user_name text NOT NULL,
	-- パスワード
	user_password text NOT NULL,
	CONSTRAINT users_pkey PRIMARY KEY (user_name)
) WITHOUT OIDS;


ALTER TABLE users OWNER TO test_pg_user;

INSERT INTO users VALUES ('user1', 'user1pass');
INSERT INTO users VALUES ('user2', 'user2pass');
INSERT INTO users VALUES ('user3', 'user3pass');

