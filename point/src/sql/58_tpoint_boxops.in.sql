/*****************************************************************************
 *
 * tpoint_boxops.sql
 *	  Bounding box operators for temporal points.
 *
 * Portions Copyright (c) 2020, Esteban Zimanyi, Arthur Lesuisse, 
 * 		Universite Libre de Bruxelles
 * Portions Copyright (c) 1996-2020, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 *****************************************************************************/

/*****************************************************************************
 * Casting for tbox
 *****************************************************************************/

CREATE FUNCTION stbox(box2d)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'box2d_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(box3d)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'box3d_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geometry)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geography)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(timestamptz)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'timestamp_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(timestampset)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'timestampset_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(period)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'period_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(periodset)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'periodset_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geometry, timestamptz)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_timestamp_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geography, timestamptz)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_timestamp_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geometry, period)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_period_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(geography, period)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'geo_period_to_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(tgeompoint)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION stbox(tgeogpoint)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE CAST (box2d AS stbox) WITH FUNCTION stbox(box2d) AS IMPLICIT;
CREATE CAST (box3d AS stbox) WITH FUNCTION stbox(box3d) AS IMPLICIT;
CREATE CAST (geometry AS stbox) WITH FUNCTION stbox(geometry) AS IMPLICIT;
CREATE CAST (geography AS stbox) WITH FUNCTION stbox(geography) AS IMPLICIT;
CREATE CAST (timestamptz AS stbox) WITH FUNCTION stbox(timestamptz) AS IMPLICIT;
CREATE CAST (timestampset AS stbox) WITH FUNCTION stbox(timestampset) AS IMPLICIT;
CREATE CAST (period AS stbox) WITH FUNCTION stbox(period) AS IMPLICIT;
CREATE CAST (periodset AS stbox) WITH FUNCTION stbox(periodset) AS IMPLICIT;
CREATE CAST (tgeompoint AS stbox) WITH FUNCTION stbox(tgeompoint);
CREATE CAST (tgeogpoint AS stbox) WITH FUNCTION stbox(tgeogpoint);

CREATE FUNCTION stboxes(tgeompoint)
	RETURNS stbox[]
	AS 'MODULE_PATHNAME', 'tpoint_stboxes'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************/

CREATE FUNCTION expandSpatial(stbox, float)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'stbox_expand_spatial'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION expandSpatial(tgeompoint, float)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_expand_spatial'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION expandSpatial(tgeogpoint, float)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_expand_spatial'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION expandTemporal(stbox, interval)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'stbox_expand_temporal'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION expandTemporal(tgeompoint, interval)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_expand_temporal'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION expandTemporal(tgeogpoint, interval)
	RETURNS stbox
	AS 'MODULE_PATHNAME', 'tpoint_expand_temporal'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************
 * Contains
 *****************************************************************************/

CREATE FUNCTION contains_bbox(geometry, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(stbox, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeompoint, geometry)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeompoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeompoint, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = geometry, RIGHTARG = tgeompoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = stbox, RIGHTARG = tgeompoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeompoint, RIGHTARG = geometry,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeompoint, RIGHTARG = stbox,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeompoint, RIGHTARG = tgeompoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/

CREATE FUNCTION contains_bbox(geography, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(stbox, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeogpoint, geography)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeogpoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains_bbox(tgeogpoint, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contains_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = geography, RIGHTARG = tgeogpoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = stbox, RIGHTARG = tgeogpoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = geography,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = stbox,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR @> (
	PROCEDURE = contains_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = tgeogpoint,
	COMMUTATOR = <@,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************
 * Contained
 *****************************************************************************/

CREATE FUNCTION contained_bbox(geometry, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(stbox, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeompoint, geometry)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeompoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeompoint, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = geometry, RIGHTARG = tgeompoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = stbox, RIGHTARG = tgeompoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeompoint, RIGHTARG = geometry,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeompoint, RIGHTARG = stbox,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeompoint, RIGHTARG = tgeompoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/

CREATE FUNCTION contained_bbox(geography, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(stbox, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeogpoint, geography)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeogpoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contained_bbox(tgeogpoint, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'contained_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = geography, RIGHTARG = tgeogpoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = stbox, RIGHTARG = tgeogpoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = geography,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = stbox,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR <@ (
	PROCEDURE = contained_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = tgeogpoint,
	COMMUTATOR = @>,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************
 * Overlaps
 *****************************************************************************/

CREATE FUNCTION overlaps_bbox(geometry, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(stbox, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeompoint, geometry)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeompoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeompoint, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = geometry, RIGHTARG = tgeompoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = stbox, RIGHTARG = tgeompoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeompoint, RIGHTARG = geometry,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeompoint, RIGHTARG = stbox,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeompoint, RIGHTARG = tgeompoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/

CREATE FUNCTION overlaps_bbox(geography, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(stbox, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeogpoint, geography)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeogpoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION overlaps_bbox(tgeogpoint, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'overlaps_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = geography, RIGHTARG = tgeogpoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = stbox, RIGHTARG = tgeogpoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = geography,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = stbox,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR && (
	PROCEDURE = overlaps_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = tgeogpoint,
	COMMUTATOR = &&,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************
 * Same
 *****************************************************************************/

CREATE FUNCTION same_bbox(geometry, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(stbox, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeompoint, geometry)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeompoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeompoint, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = geometry, RIGHTARG = tgeompoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = stbox, RIGHTARG = tgeompoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeompoint, RIGHTARG = geometry,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeompoint, RIGHTARG = stbox,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeompoint, RIGHTARG = tgeompoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/

CREATE FUNCTION same_bbox(geography, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(stbox, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeogpoint, geography)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeogpoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION same_bbox(tgeogpoint, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'same_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = geography, RIGHTARG = tgeogpoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = stbox, RIGHTARG = tgeogpoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = geography,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = stbox,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR ~= (
	PROCEDURE = same_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = tgeogpoint,
	COMMUTATOR = ~=,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************
 * Adjacent
 *****************************************************************************/

CREATE FUNCTION adjacent_bbox(geometry, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(stbox, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeompoint, geometry)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeompoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeompoint, tgeompoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = geometry, RIGHTARG = tgeompoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = stbox, RIGHTARG = tgeompoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeompoint, RIGHTARG = geometry,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeompoint, RIGHTARG = stbox,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeompoint, RIGHTARG = tgeompoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/

CREATE FUNCTION adjacent_bbox(geography, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_geo_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(stbox, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_stbox_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeogpoint, geography)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_geo'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeogpoint, stbox)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_stbox'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION adjacent_bbox(tgeogpoint, tgeogpoint)
	RETURNS boolean
	AS 'MODULE_PATHNAME', 'adjacent_bbox_tpoint_tpoint'
	LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = geography, RIGHTARG = tgeogpoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = stbox, RIGHTARG = tgeogpoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = geography,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = stbox,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);
CREATE OPERATOR -|- (
	PROCEDURE = adjacent_bbox,
	LEFTARG = tgeogpoint, RIGHTARG = tgeogpoint,
	COMMUTATOR = -|-,
	RESTRICT = tpoint_sel, JOIN = tpoint_joinsel
);

/*****************************************************************************/
