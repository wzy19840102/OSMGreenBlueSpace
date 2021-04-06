-- required tables
CREATE TABLE highway (
 osm_id bigint,
 tags hstore,
 geom_wgs geometry(LINESTRING, 4326)
);

CREATE TABLE green_blue_polygon (
 osm_id bigint,
 tags hstore,
 green_blue varchar,
 geom_wgs geometry(MULTIPOLYGON, 4326)
);

CREATE TABLE green_blue_line (
 osm_id bigint,
 tags hstore,
 green_blue varchar,
 geom_wgs geometry(LINESTRING, 4326)
);

CREATE TABLE green_blue_point (
 osm_id bigint,
 tags hstore,
 green_blue varchar,
 geom_wgs geometry(POINT, 4326)
);

-- populate tables
-- highways
INSERT INTO highway (osm_id, tags, geom_wgs)
 SELECT id, tags, linestring FROM ways
 WHERE tags -> 'highway' IS NOT NULL;

-- green & blue polygon features 
INSERT INTO green_blue_polygon (osm_id, tags, green_blue, geom_wgs)
 SELECT
    r_outer.id AS osm_id,
    r_outer.tags AS tags,
    CASE
     WHEN (r_outer.tags -> 'natural'::text) = 'bay'::text THEN 'blue'::text
     WHEN (r_outer.tags -> 'natural'::text) = 'water'::text THEN 'blue'::text
     WHEN (r_outer.tags -> 'waterway'::text) = 'riverbank'::text THEN 'blue'::text
     WHEN (r_outer.tags -> 'landuse'::text) = 'basin'::text THEN 'blue'::text
     WHEN (r_outer.tags -> 'landuse'::text) = 'reservoir'::text THEN 'blue'::text
     ELSE 'green'::text
    END AS green_blue,
    ( SELECT st_multi(st_difference(( SELECT st_union(st_makevalid(st_makepolygon(merged_outer.geom))) AS st_union
                   FROM ( SELECT (st_dump(st_linemerge(st_geomfromtext(st_astext(st_linemerge(st_collect(joined_outer.linestring))), 4326)))).geom AS geom
                           FROM ( SELECT ways.linestring
                                   FROM ways
                                  WHERE (ways.id IN ( SELECT rm.member_id
   FROM relation_members rm
  WHERE rm.relation_id = r_outer.id AND (rm.member_role = 'outer'::text OR rm.member_role = ''::text) AND rm.member_type = 'W'::bpchar)) AND st_npoints(ways.linestring) > 1) joined_outer) merged_outer
                  WHERE st_isclosed(merged_outer.geom) AND st_npoints(merged_outer.geom) > 3), COALESCE(( SELECT st_union(st_makevalid(st_makepolygon(merged_i.geom))) AS st_union
                   FROM ( SELECT (st_dump(st_linemerge(st_geomfromtext(st_astext(st_linemerge(st_collect(joined.linestring))), 4326)))).geom AS geom
                           FROM ( SELECT ways.linestring
                                   FROM ways
                                  WHERE (ways.id IN ( SELECT rm.member_id
   FROM relation_members rm
  WHERE rm.relation_id = r_outer.id AND rm.member_role = 'inner'::text AND rm.member_type = 'W'::bpchar)) AND st_npoints(ways.linestring) > 1) joined) merged_i
                  WHERE st_isclosed(merged_i.geom) AND st_npoints(merged_i.geom) > 3), st_geomfromtext('POLYGON EMPTY'::text)))) AS st_multi) AS geom
   FROM relations r_outer
  WHERE r_outer.tags @> '"type"=>"multipolygon"'::hstore AND ((r_outer.tags -> 'amenity'::text) = 'grave_yard'::text OR (r_outer.tags -> 'barrier'::text) = 'hedge'::text OR (r_outer.tags -> 'landuse'::text) = 'allotments'::text OR (r_outer.tags -> 'landuse'::text) = 'cemetery'::text OR (r_outer.tags -> 'landuse'::text) = 'farmland'::text OR (r_outer.tags -> 'landuse'::text) = 'forest'::text OR (r_outer.tags -> 'landuse'::text) = 'grass'::text OR (r_outer.tags -> 'landuse'::text) = 'greenfield'::text OR (r_outer.tags -> 'landuse'::text) = 'meadow'::text OR (r_outer.tags -> 'landuse'::text) = 'orchard'::text OR (r_outer.tags -> 'landuse'::text) = 'recreation_ground'::text OR (r_outer.tags -> 'landuse'::text) = 'village_green'::text OR (r_outer.tags -> 'landuse'::text) = 'vineyard'::text OR (r_outer.tags -> 'leisure'::text) = 'garden'::text OR (r_outer.tags -> 'leisure'::text) = 'golf_course'::text OR (r_outer.tags -> 'leisure'::text) = 'nature_reserve'::text OR (r_outer.tags -> 'leisure'::text) = 'park'::text OR (r_outer.tags -> 'leisure'::text) = 'pitch'::text OR (r_outer.tags -> 'natural'::text) = 'scrub'::text OR (r_outer.tags -> 'natural'::text) = 'tree_row'::text OR (r_outer.tags -> 'natural'::text) = 'heath'::text OR (r_outer.tags -> 'natural'::text) = 'grassland'::text OR (r_outer.tags -> 'natural'::text) = 'wetland'::text OR (r_outer.tags -> 'natural'::text) = 'camp_site'::text OR (r_outer.tags -> 'natural'::text) = 'water'::text OR (r_outer.tags -> 'waterway'::text) = 'riverbank'::text OR (r_outer.tags -> 'natural'::text) = 'bay'::text OR (r_outer.tags -> 'landuse'::text) = 'basin'::text OR (r_outer.tags -> 'landuse'::text) = 'reservoir'::text) AND ( SELECT st_geometrytype(st_union(st_makevalid(st_makepolygon(merged_outer.geom)))) = ANY (ARRAY['ST_Polygon'::text, 'ST_MultiPolygon'::text])
           FROM ( SELECT (st_dump(st_linemerge(st_geomfromtext(st_astext(st_linemerge(st_collect(joined_outer.linestring))), 4326)))).geom AS geom
                   FROM ( SELECT ways.linestring
                           FROM ways
                          WHERE (ways.id IN ( SELECT rm.member_id
                                   FROM relation_members rm
                                  WHERE rm.relation_id = r_outer.id AND (rm.member_role = 'outer'::text OR rm.member_role = ''::text) AND rm.member_type = 'W'::bpchar)) AND st_npoints(ways.linestring) > 1) joined_outer) merged_outer
          WHERE st_isclosed(merged_outer.geom) AND st_npoints(merged_outer.geom) > 3)
 UNION
  SELECT 
	ways.id AS osm_id,
    ways.tags AS tags,
	CASE
     WHEN (ways.tags -> 'amenity'::text) = 'fountain'::text THEN 'blue'::text
     WHEN (ways.tags -> 'natural'::text) = 'water'::text THEN 'blue'::text
     WHEN (ways.tags -> 'natural'::text) = 'bay'::text THEN 'blue'::text
     WHEN (ways.tags -> 'waterway'::text) = 'riverbank'::text THEN 'blue'::text
     WHEN (ways.tags -> 'landuse'::text) = 'basin'::text THEN 'blue'::text
     WHEN (ways.tags -> 'landuse'::text) = 'reservoir'::text THEN 'blue'::text
     ELSE 'green'::text
    END AS green_blue,
    st_multi(st_makepolygon(ways.linestring)) AS geom
   FROM ways
  WHERE ((ways.tags -> 'amenity'::text) = 'grave_yard'::text OR (ways.tags -> 'landuse'::text) = 'allotments'::text OR (ways.tags -> 'landuse'::text) = 'cemetery'::text OR (ways.tags -> 'landuse'::text) = 'farmland'::text OR (ways.tags -> 'landuse'::text) = 'forest'::text OR (ways.tags -> 'landuse'::text) = 'grass'::text OR (ways.tags -> 'landuse'::text) = 'greenfield'::text OR (ways.tags -> 'landuse'::text) = 'meadow'::text OR (ways.tags -> 'landuse'::text) = 'orchard'::text OR (ways.tags -> 'landuse'::text) = 'recreation_ground'::text OR (ways.tags -> 'landuse'::text) = 'village_green'::text OR (ways.tags -> 'landuse'::text) = 'vineyard'::text OR (ways.tags -> 'leisure'::text) = 'garden'::text OR (ways.tags -> 'leisure'::text) = 'golf_course'::text OR (ways.tags -> 'leisure'::text) = 'nature_reserve'::text OR (ways.tags -> 'leisure'::text) = 'park'::text OR (ways.tags -> 'leisure'::text) = 'pitch'::text OR (ways.tags -> 'natural'::text) = 'scrub'::text OR (ways.tags -> 'natural'::text) = 'heath'::text OR (ways.tags -> 'natural'::text) = 'grassland'::text OR (ways.tags -> 'natural'::text) = 'wetland'::text OR (ways.tags -> 'natural'::text) = 'camp_site'::text OR (ways.tags -> 'amenity'::text) = 'fountain'::text OR (ways.tags -> 'landuse'::text) = 'basin'::text OR (ways.tags -> 'landuse'::text) = 'reservoir'::text OR (ways.tags -> 'natural'::text) = 'water'::text OR (ways.tags -> 'natural'::text) = 'bay'::text OR (ways.tags -> 'waterway'::text) = 'riverbank'::text) AND st_numpoints(ways.linestring) > 3 AND st_isclosed(ways.linestring);

-- green & blue line features
INSERT INTO green_blue_line (osm_id, tags, green_blue, geom_wgs)
 SELECT 
  ways.id AS osm_id,
  ways.tags AS tags,
  CASE
   WHEN (ways.tags -> 'waterway'::text) = 'canal'::text OR (ways.tags -> 'waterway'::text) = 'river'::text OR (ways.tags -> 'waterway'::text) = 'stream'::text THEN 'blue'::text
   ELSE 'green'::text
  END AS green_blue,
  ways.linestring AS geom_wgs
   FROM ways
  WHERE ((ways.tags -> 'barrier'::text) = 'hedge'::text OR (ways.tags -> 'natural'::text) = 'tree_row'::text OR (ways.tags -> 'waterway'::text) = 'stream'::text OR (ways.tags -> 'waterway'::text) = 'canal'::text OR (ways.tags -> 'waterway'::text) = 'line'::text) AND ways.linestring IS NOT NULL;

-- green & blue point features  
INSERT INTO green_blue_point (osm_id, tags, green_blue, geom_wgs)
 SELECT
  nodes.id AS osm_id,
  nodes.tags AS tags,
  CASE
   WHEN (nodes.tags -> 'amenity'::text) = 'fountain'::text THEN 'blue'::text
   WHEN (nodes.tags -> 'natural'::text) = 'spring'::text THEN 'blue'::text
   WHEN (nodes.tags -> 'waterway'::text) = 'waterfall'::text THEN 'blue'::text
   ELSE 'green'::text
  END AS green_blue,
  nodes.geom AS geom_wgs
 FROM nodes
 WHERE ((nodes.tags -> 'barrier'::text) = 'hedge'::text OR (nodes.tags -> 'natural'::text) = 'tree'::text OR (nodes.tags -> 'amenity'::text) = 'fountain'::text OR (nodes.tags -> 'natural'::text) = 'spring'::text OR (nodes.tags -> 'waterway'::text) = 'waterfall'::text) AND nodes.geom IS NOT NULL;

-- update overlapping features: green_blue_polygon
-- under construction
/*
--CREATE VIEW tmp AS
SELECT
 a.osm_id, ST_Difference(a.geom_wgs, ST_Union(b.geom_wgs))	-- ERROR handling required
 --CASE
 -- WHEN ST_Area(a.geom_wgs) > ST_Area(b.geom_wgs) THEN ST_Union(b.geom_wgs) ELSE a.geom_wgs END
FROM
 green_blue_polygon a
JOIN
 green_blue_polygon b ON 
	ST_Within(b.geom_wgs, a.geom_wgs) OR 
	(ST_Overlaps(a.geom_wgs, b.geom_wgs) AND ST_Area(a.geom_wgs) > ST_Area(b.geom_wgs))
WHERE
 a.osm_id IN (279069845,279069846,279069847,99057186,99057184,99057185)
 AND a.osm_id != b.osm_id
GROUP BY a.osm_id, a.geom_wgs;

-- update table green_blue_polygon
UPDATE green_blue_polygon a
 SET geom_wgs = CASE WHEN ST_IsEmpty(tmp.new_geom) IS true THEN NULL ELSE ST_Multi(tmp.new_geom) END
FROM (
 SELECT
  a.osm_id, ST_Difference(a.geom_wgs, ST_Union(b.geom_wgs)) AS new_geom
 FROM
  green_blue_polygon a
 JOIN
  green_blue_polygon b ON 
	ST_Within(b.geom_wgs, a.geom_wgs) OR 
	(ST_Overlaps(a.geom_wgs, b.geom_wgs) AND ST_Area(a.geom_wgs) > ST_Area(b.geom_wgs))
 WHERE
  a.osm_id != b.osm_id
 GROUP BY
  a.osm_id, a.geom_wgs) tmp
WHERE
 tmp.osm_id = a.osm_id;

*/