/*****************************************************************************
 *
 * tpoint_posops.c
 *	  Relative position operators for temporal geometry points.
 *
 * The following operators are defined for the spatial dimension:
 * - left, overleft, right, overright, below, overbelow, above, overabove,
 *   front, overfront, back, overback
 * There are no equivalent operators for the temporal geography points since
 * PostGIS does not currently provide such functionality for geography.
 * The following operators for the time dimension:
 * - before, overbefore, after, overafter
 * for both temporal geometry and geography points are "inherited" from the
 * basic temporal types. In this file they are defined when one of the
 * arguments is a stbox.
 *
 * Portions Copyright (c) 2020, Esteban Zimanyi, Arthur Lesuisse,
 * 		Universite Libre de Bruxelles
 * Portions Copyright (c) 1996-2020, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 *****************************************************************************/

#include "tpoint_posops.h"

#include <assert.h>

#include "postgis.h"
#include "tpoint.h"
#include "tpoint_spatialfuncs.h"
#include "tpoint_boxops.h"

/*****************************************************************************
 * Generic functions 
 *****************************************************************************/

/**
 * Generic position function for a temporal point and a spatiotemporal box
 *
 * @param[in] func Function
 * @param[in] temp Temporal value
 * @param[in] box Spatiotemporal box
 * @param[in] hasz True when the values must have Z coordinates
 * @param[in] invert True when the function is called with inverted arguments
 */
bool
posop_tpoint_stbox1(bool (*func)(const STBOX *, const STBOX *),
	Temporal *temp, STBOX *box, bool hasz, bool invert)
{
	ensure_same_geodetic_tpoint_stbox(temp, box);
	ensure_same_srid_tpoint_stbox(temp, box);
	if (hasz)
	{
		ensure_has_Z_tpoint(temp);
		ensure_has_Z_stbox(box);
	}
	else
		ensure_same_spatial_dimensionality_tpoint_stbox(temp, box);
	STBOX box1;
	memset(&box1, 0, sizeof(STBOX));
	temporal_bbox(&box1, temp);
	bool result = invert ? func(box, &box1) : func(&box1, box);
	return result;
}

/**
 * Generic position function for a temporal point and a spatiotemporal box
 *
 * @param[in] fcinfo Catalog information about the external function
 * @param[in] hasz True when the values must have Z coordinates
 * @param[in] func Function
 */
Datum
posop_stbox_tpoint(FunctionCallInfo fcinfo, bool hasz,
	bool (*func)(const STBOX *, const STBOX *))
{
	STBOX *box = PG_GETARG_STBOX_P(0);
	Temporal *temp = PG_GETARG_TEMPORAL(1);
	bool result = posop_tpoint_stbox1(func, temp, box, hasz, true);
	PG_FREE_IF_COPY(temp, 1);
	PG_RETURN_BOOL(result);
}

/**
 * Generic position function for a temporal point and a spatiotemporal box
 *
 * @param[in] fcinfo Catalog information about the external function
 * @param[in] hasz True when the values must have Z coordinates
 * @param[in] func Function
 */
Datum
posop_tpoint_stbox(FunctionCallInfo fcinfo, bool hasz,
	bool (*func)(const STBOX *, const STBOX *))
{
	Temporal *temp = PG_GETARG_TEMPORAL(0);
	STBOX *box = PG_GETARG_STBOX_P(1);
	bool result = posop_tpoint_stbox1(func, temp, box, hasz, false);
	PG_FREE_IF_COPY(temp, 0);
	PG_RETURN_BOOL(result);
}

/**
 * Generic position function for a temporal point and a spatiotemporal box
 * regarding the temporal dimension
 *
 * @param[in] fcinfo Catalog information about the external function
 * @param[in] func Function
 */
Datum
posop_stbox_tpoint_tdim(FunctionCallInfo fcinfo, 
	bool (*func)(const STBOX *, const STBOX *))
{
	STBOX *box = PG_GETARG_STBOX_P(0);
	Temporal *temp = PG_GETARG_TEMPORAL(1);
	ensure_has_T_stbox(box);
	STBOX box1;
	memset(&box1, 0, sizeof(STBOX));
	temporal_bbox(&box1, temp);
	bool result = func(box, &box1);
	PG_RETURN_BOOL(result);
}

/**
 * Generic position function for a temporal point and a spatiotemporal box
 * regarding the temporal dimension
 *
 * @param[in] fcinfo Catalog information about the external function
 * @param[in] func Function
 */
Datum
posop_tpoint_stbox_tdim(FunctionCallInfo fcinfo, 
	bool (*func)(const STBOX *, const STBOX *))
{
	Temporal *temp = PG_GETARG_TEMPORAL(0);
	STBOX *box = PG_GETARG_STBOX_P(1);
	ensure_has_T_stbox(box);
	STBOX box1;
	memset(&box1, 0, sizeof(STBOX));
	temporal_bbox(&box1, temp);
	bool result = func(&box1, box);
	PG_FREE_IF_COPY(temp, 0);
	PG_RETURN_BOOL(result);
}


/*****************************************************************************/
/* geom op Temporal */

PG_FUNCTION_INFO_V1(left_geom_tpoint);
/**
 * Returns true if the geometry is strictly to the left of the temporal point
 */
PGDLLEXPORT Datum
left_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &left_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overleft_geom_tpoint);
/**
 * Returns true if the geometry does not extend to the right of the temporal point
 */
PGDLLEXPORT Datum
overleft_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &overleft_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(right_geom_tpoint);
/**
 * Returns true if the geometry is strictly to the right of the temporal point
 */
PGDLLEXPORT Datum
right_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &right_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overright_geom_tpoint);
/**
 * Returns true if the geometry does not extend to the left of the temporal point
 */
PGDLLEXPORT Datum
overright_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &overright_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(below_geom_tpoint);
/**
 * Returns true if the geometry is strictly below the temporal point
 */
PGDLLEXPORT Datum
below_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &below_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbelow_geom_tpoint);
/**
 * Returns true if the geometry does not extend above the temporal point
 */
PGDLLEXPORT Datum
overbelow_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &overbelow_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(above_geom_tpoint);
/**
 * Returns true if the geometry is strictly above the temporal point
 */
PGDLLEXPORT Datum
above_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &above_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overabove_geom_tpoint);
/**
 * Returns true if the geometry does not extend below the temporal point
 */
PGDLLEXPORT Datum
overabove_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, false, &overabove_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(front_geom_tpoint);
/**
 * Returns true if the geometry is strictly in front of the temporal point
 */
PGDLLEXPORT Datum
front_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, true, &front_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overfront_geom_tpoint);
/**
 * Returns true if the geometry does not extend to the back of the temporal point
 */
PGDLLEXPORT Datum
overfront_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, true, &overfront_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(back_geom_tpoint);
/**
 * Returns true if the geometry is strictly back of the temporal point
 */
PGDLLEXPORT Datum
back_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, true, &back_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overback_geom_tpoint);
/**
 * Returns true if the geometry does not extend to the front of the temporal point
 */
PGDLLEXPORT Datum
overback_geom_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_geo_tpoint(fcinfo, true, &overback_stbox_stbox_internal);
}

/*****************************************************************************/
/* Temporal op geom */

PG_FUNCTION_INFO_V1(left_tpoint_geom);
/**
 * Returns true if the temporal point is strictly to the left of the geometry
 */
PGDLLEXPORT Datum
left_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &left_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overleft_tpoint_geom);
/**
 * Returns true if the temporal point does not extend to the right of the geometry
 */
PGDLLEXPORT Datum
overleft_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &overleft_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(right_tpoint_geom);
/**
 * Returns true if the temporal point is strictly to the right of the geometry
 */
PGDLLEXPORT Datum
right_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &right_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overright_tpoint_geom);
/**
 * Returns true if the temporal point does not extend to the left of the geometry
 */
PGDLLEXPORT Datum
overright_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &overright_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(below_tpoint_geom);
/**
 * Returns true if the temporal point is strictly below the geometry
 */
PGDLLEXPORT Datum
below_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &below_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbelow_tpoint_geom);
/**
 * Returns true if the temporal point does not extend above the geometry
 */
PGDLLEXPORT Datum
overbelow_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &overbelow_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(above_tpoint_geom);
/**
 * Returns true if the temporal point is strictly above the geometry
 */
PGDLLEXPORT Datum
above_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &above_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overabove_tpoint_geom);
/**
 * Returns true if the temporal point does not extend below the geometry
 */
PGDLLEXPORT Datum
overabove_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, false, &overabove_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(front_tpoint_geom);
/**
 * Returns true if the temporal point is strictly in front of the geometry
 */
PGDLLEXPORT Datum
front_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, true,&front_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overfront_tpoint_geom);
/**
 * Returns true if the temporal point does not extend to the back of the geometry
 */
PGDLLEXPORT Datum
overfront_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, true,&overfront_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(back_tpoint_geom);
/**
 * Returns true if the temporal point is strictly back of the geometry
 */
PGDLLEXPORT Datum
back_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, true,&back_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overback_tpoint_geom);
/**
 * Returns true if the temporal point does not extend to the front of the geometry
 */
PGDLLEXPORT Datum
overback_tpoint_geom(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_geo(fcinfo, true,&overback_stbox_stbox_internal);
}

/*****************************************************************************/
/* stbox op Temporal */

PG_FUNCTION_INFO_V1(left_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly to the left of the temporal point
 */
PGDLLEXPORT Datum
left_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &left_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overleft_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend to the right of the temporal point
 */
PGDLLEXPORT Datum
overleft_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &overleft_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(right_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly to the right of the temporal point
 */
PGDLLEXPORT Datum
right_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &right_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overright_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend to the left of the temporal point
 */
PGDLLEXPORT Datum
overright_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &overright_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(below_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly below the temporal point
 */
PGDLLEXPORT Datum
below_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &below_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbelow_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend above the temporal point
 */
PGDLLEXPORT Datum
overbelow_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &overbelow_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(above_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly above the temporal point
 */
PGDLLEXPORT Datum
above_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &above_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overabove_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend below the temporal point
 */
PGDLLEXPORT Datum
overabove_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, false, &overabove_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(front_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly in front of the temporal point
 */
PGDLLEXPORT Datum
front_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, true, &front_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overfront_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend to the back of the temporal point
 */
PGDLLEXPORT Datum
overfront_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, true, &overfront_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(back_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly back of the temporal point
 */
PGDLLEXPORT Datum
back_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, true, &back_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overback_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend to the front of the temporal point
 */
PGDLLEXPORT Datum
overback_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint(fcinfo, true, &overback_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(before_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly before the temporal point
 */
PGDLLEXPORT Datum
before_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint_tdim(fcinfo, &before_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbefore_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend after the temporal point
 */
PGDLLEXPORT Datum
overbefore_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint_tdim(fcinfo, &overbefore_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(after_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box is strictly after the temporal point
 */
PGDLLEXPORT Datum
after_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint_tdim(fcinfo, &after_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overafter_stbox_tpoint);
/**
 * Returns true if the spatiotemporal box does not extend before the temporal point
 */
PGDLLEXPORT Datum
overafter_stbox_tpoint(PG_FUNCTION_ARGS)
{
	return posop_stbox_tpoint_tdim(fcinfo, &overafter_stbox_stbox_internal);
}

/*****************************************************************************/
/* Temporal op stbox */

PG_FUNCTION_INFO_V1(left_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly to the left of the spatiotemporal box
 */
PGDLLEXPORT Datum
left_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &left_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overleft_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend to the right of the spatiotemporal box
 */
PGDLLEXPORT Datum
overleft_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &overleft_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(right_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly to the right of the spatiotemporal box
 */
PGDLLEXPORT Datum
right_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &right_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overright_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend to the left of the spatiotemporal box
 */
PGDLLEXPORT Datum
overright_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &overright_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(below_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly below the spatiotemporal box
 */
PGDLLEXPORT Datum
below_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &below_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbelow_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend above the spatiotemporal box
 */
PGDLLEXPORT Datum
overbelow_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &overbelow_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(above_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly above the spatiotemporal box
 */
PGDLLEXPORT Datum
above_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &above_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overabove_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend below the spatiotemporal box
 */
PGDLLEXPORT Datum
overabove_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, false, &overabove_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(front_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly in front of the spatiotemporal box 
 */
PGDLLEXPORT Datum
front_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, true, &front_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overfront_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend to the back of the spatiotemporal box 
 */
PGDLLEXPORT Datum
overfront_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, true, &overfront_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(back_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly back of the spatiotemporal box 
 */
PGDLLEXPORT Datum
back_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, true, &back_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overback_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend to the front of the spatiotemporal box 
 */
PGDLLEXPORT Datum
overback_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox(fcinfo, true, &overback_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(before_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly before the spatiotemporal box  
 */
PGDLLEXPORT Datum
before_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox_tdim(fcinfo, &before_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbefore_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend after the spatiotemporal box  
 */
PGDLLEXPORT Datum
overbefore_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox_tdim(fcinfo, &overbefore_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(after_tpoint_stbox);
/**
 * Returns true if the temporal point is strictly after the spatiotemporal box  
 */
PGDLLEXPORT Datum
after_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox_tdim(fcinfo, &after_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overafter_tpoint_stbox);
/**
 * Returns true if the temporal point does not extend before the spatiotemporal box  
 */
PGDLLEXPORT Datum
overafter_tpoint_stbox(PG_FUNCTION_ARGS)
{
	return posop_tpoint_stbox_tdim(fcinfo, &overafter_stbox_stbox_internal);
}

/*****************************************************************************/
/* Temporal op Temporal */

PG_FUNCTION_INFO_V1(left_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly to the left of the second one
 */
PGDLLEXPORT Datum
left_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &left_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overleft_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend to the right of the second one
 */
PGDLLEXPORT Datum
overleft_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overleft_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(right_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly to the right of the second one
 */
PGDLLEXPORT Datum
right_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &right_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overright_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend to the left of the second one
 */
PGDLLEXPORT Datum
overright_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overright_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(below_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly below the second one
 */
PGDLLEXPORT Datum
below_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &below_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbelow_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend above the second one
 */
PGDLLEXPORT Datum
overbelow_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overbelow_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(above_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly above the second one
 */
PGDLLEXPORT Datum
above_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &above_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overabove_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend below the second one
 */
PGDLLEXPORT Datum
overabove_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overabove_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(front_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly in front of the second one
 */
PGDLLEXPORT Datum
front_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, true,&front_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overfront_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend to the back of the second one
 */
PGDLLEXPORT Datum
overfront_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, true,&overfront_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(back_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly back of the second one
 */
PGDLLEXPORT Datum
back_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, true,&back_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overback_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend to the front of the second one
 */
PGDLLEXPORT Datum
overback_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, true,&overback_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(before_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly before the second one
 */
PGDLLEXPORT Datum
before_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &before_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overbefore_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend after the second one
 */
PGDLLEXPORT Datum
overbefore_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overbefore_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(after_tpoint_tpoint);
/**
 * Returns true if the first temporal point is strictly after the second one
 */
PGDLLEXPORT Datum
after_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &after_stbox_stbox_internal);
}

PG_FUNCTION_INFO_V1(overafter_tpoint_tpoint);
/**
 * Returns true if the first temporal point does not extend before the second one
 */
PGDLLEXPORT Datum
overafter_tpoint_tpoint(PG_FUNCTION_ARGS)
{
	return boxop_tpoint_tpoint(fcinfo, false, &overafter_stbox_stbox_internal);
}

/*****************************************************************************/
