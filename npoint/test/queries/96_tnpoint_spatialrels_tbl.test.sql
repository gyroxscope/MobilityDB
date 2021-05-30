﻿-------------------------------------------------------------------------------
set parallel_tuple_cost=0;
set parallel_setup_cost=0;
set force_parallel_mode=regress;
-------------------------------------------------------------------------------
-- Geometry rel tnpoint
 -------------------------------------------------------------------------------

SELECT count(*) FROM tbl_geom_point t1, tbl_tnpoint t2 WHERE contains(ST_SetSRID(t1.g, 5676), t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_geom_point t1, tbl_tnpoint t2 WHERE disjoint(ST_SetSRID(t1.g, 5676), t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_geom_point t1, tbl_tnpoint t2 WHERE intersects(ST_SetSRID(t1.g, 5676), t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_geom_point t1, tbl_tnpoint t2 WHERE touches(ST_SetSRID(t1.g, 5676), t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_geom_point t1, tbl_tnpoint t2 WHERE dwithin(ST_SetSRID(t1.g, 5676), t2.temp, 0.01) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';

-------------------------------------------------------------------------------
-- npoint rel tnpoint
 -------------------------------------------------------------------------------

SELECT count(*) FROM tbl_npoint t1, tbl_tnpoint t2 WHERE disjoint(t1.np, t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_npoint t1, tbl_tnpoint t2 WHERE intersects(t1.np, t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_npoint t1, tbl_tnpoint t2 WHERE touches(t1.np, t2.temp) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_npoint t1, tbl_tnpoint t2 WHERE dwithin(t1.np, t2.temp, 0.01) AND t1.k < 10 AND t2.k%4 = 0 AND tempSubtype(temp) != 'SequenceSet';

-------------------------------------------------------------------------------
-- tnpoint rel <type>
 -------------------------------------------------------------------------------

SELECT count(*) FROM tbl_tnpoint t1, tbl_geom_point t2 WHERE disjoint(t1.temp, ST_SetSRID(t2.g, 5676)) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_geom_point t2 WHERE intersects(t1.temp, ST_SetSRID(t2.g, 5676)) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_geom_point t2 WHERE touches(t1.temp, ST_SetSRID(t2.g, 5676)) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_geom_point t2 WHERE dwithin(t1.temp, ST_SetSRID(t2.g, 5676), 0.01) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';

SELECT count(*) FROM tbl_tnpoint t1, tbl_npoint t2 WHERE disjoint(t1.temp, t2.np) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_npoint t2 WHERE intersects(t1.temp, t2.np) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_npoint t2 WHERE touches(t1.temp, t2.np) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';
SELECT count(*) FROM tbl_tnpoint t1, tbl_npoint t2 WHERE dwithin(t1.temp, t2.np, 0.01) AND t1.k%4 = 0 AND t2.k < 10 AND tempSubtype(temp) != 'SequenceSet';

SELECT count(*) FROM tbl_tnpoint t1, tbl_tnpoint t2 WHERE dwithin(t1.temp, t2.temp, 0.01) AND t1.k%4 = 0 AND t2.k%4 = 0 AND tempSubtype(t1.temp) != 'SequenceSet';

-------------------------------------------------------------------------------
set parallel_tuple_cost=100;
set parallel_setup_cost=100;
set force_parallel_mode=off;
-------------------------------------------------------------------------------
