-- CREATE SCHEMA analysis;

-- SELECT *
-- FROM staging.colors;

-- Finding the length of the variables
SELECT
	MAX(LENGTH(set_num)),
	MAX(LENGTH(name)),
	MAX(theme_id),
	MIN(theme_id),
	MAX(year),
	MIN(year),
	MIN(num_parts),
	MAX(num_parts)
FROM staging.sets;

DROP TABLE IF EXISTS analysis.colors CASCADE;
DROP TABLE IF EXISTS analysis.inventories CASCADE;
DROP TABLE IF EXISTS analysis.inventory_parts CASCADE; 
DROP TABLE IF EXISTS analysis.inventory_sets CASCADE;
DROP TABLE IF EXISTS analysis.part_categories CASCADE;
DROP TABLE IF EXISTS analysis.parts CASCADE;
DROP TABLE IF EXISTS analysis.sets CASCADE;
DROP TABLE IF EXISTS analysis.themes CASCADE;

CREATE TABLE analysis.colors(
	id smallint,
	name varchar(50),
	rgb varchar(6),
	is_trans varchar(1)
);

CREATE TABLE analysis.inventories(
	id smallint,
	version smallint,
	set_num varchar(20)
);

CREATE TABLE analysis.inventory_parts(
	inventory_id smallint,
	part_num varchar(20),
	color_id smallint,
	quantiy smallint,
	is_spare varchar(5)
);

CREATE TABLE analysis.inventory_sets(
	inventory_id smallint,
	set_num varchar(15),
	quantity varchar(70)
);

CREATE TABLE analysis.part_categories(
	id smallint,
	name varchar(50)
);

CREATE TABLE analysis.parts(
	part_num varchar(20),
	name varchar(230),
	part_cat_id smallint
);

CREATE TABLE analysis.themes(
	id smallint,
	name varchar(40),
	parent_id smallint
);

CREATE TABLE analysis.sets(
	set_num varchar(20),
	name varchar(100),
	year smallint,
	theme_id smallint,
	num_parts smallint
);

--- Insert
INSERT INTO analysis.colors(
	SELECT * FROM staging.colors
);
INSERT INTO analysis.inventories(
	SELECT * FROM staging.inventories
);

INSERT INTO analysis.inventory_parts(
	SELECT * FROM staging.inventory_parts
);

INSERT INTO analysis.inventory_sets(
	SELECT * FROM staging.inventory_sets
);

INSERT INTO analysis.part_categories(
	SELECT * FROM staging.part_categories
);

INSERT INTO analysis.parts(
	SELECT * FROM staging.parts
);

INSERT INTO analysis.sets(
	SELECT * FROM staging.sets
);

INSERT INTO analysis.themes(
	SELECT * FROM staging.themes
);

INSERT INTO analysis.parts(
	SELECT DISTINCT
	IP.part_num,
	NULL as name,
	CAST(NULL as smallint) as part_cat_id
	FROM analysis.inventory_parts as IP
	LEFT JOIN analysis.parts as P ON IP.part_num = P.part_num
	WHERE P.part_num is NULL
);

-- Alter table
ALTER TABLE analysis.colors ADD PRIMARY KEY (id);
ALTER TABLE analysis.inventories ADD PRIMARY KEY (id);
ALTER TABLE analysis.parts ADD PRIMARY KEY (part_num);
ALTER TABLE analysis.part_categories ADD PRIMARY KEY (id);
ALTER TABLE analysis.sets ADD PRIMARY KEY (set_num);
ALTER TABLE analysis.themes ADD PRIMARY KEY (id);

-- ADD FK
ALTER TABLE analysis.parts ADD FOREIGN KEY (part_cat_id)
	REFERENCES analysis.part_categories(id);

ALTER TABLE analysis.inventory_parts ADD FOREIGN KEY (inventory_id)
	REFERENCES analysis.inventories(id);

ALTER TABLE analysis.inventory_parts ADD FOREIGN KEY (part_num)
	REFERENCES analysis.parts(part_num);

ALTER TABLE analysis.inventory_parts ADD FOREIGN KEY (color_id)
	REFERENCES analysis.colors(id);

ALTER TABLE analysis.inventory_sets ADD FOREIGN KEY (inventory_id)
	REFERENCES analysis.inventories(id);

ALTER TABLE analysis.inventory_sets ADD FOREIGN KEY (set_num)
	REFERENCES analysis.sets(set_num);

ALTER TABLE analysis.sets ADD FOREIGN KEY (theme_id)
	REFERENCES analysis.themes(id);

ALTER TABLE analysis.inventories ADD FOREIGN KEY (set_num)
	REFERENCES analysis.sets(set_num);