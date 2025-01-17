-------------------------------------------------------------------------------
--
-- This MobilityDB code is provided under The PostgreSQL License.
--
-- Copyright (c) 2016-2021, Université libre de Bruxelles and MobilityDB
-- contributors
--
-- MobilityDB includes portions of PostGIS version 3 source code released
-- under the GNU General Public License (GPLv2 or later).
-- Copyright (c) 2001-2021, PostGIS contributors
--
-- Permission to use, copy, modify, and distribute this software and its
-- documentation for any purpose, without fee, and without a written 
-- agreement is hereby granted, provided that the above copyright notice and
-- this paragraph and the following two paragraphs appear in all copies.
--
-- IN NO EVENT SHALL UNIVERSITE LIBRE DE BRUXELLES BE LIABLE TO ANY PARTY FOR
-- DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
-- LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
-- EVEN IF UNIVERSITE LIBRE DE BRUXELLES HAS BEEN ADVISED OF THE POSSIBILITY 
-- OF SUCH DAMAGE.
--
-- UNIVERSITE LIBRE DE BRUXELLES SPECIFICALLY DISCLAIMS ANY WARRANTIES, 
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
-- AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON
-- AN "AS IS" BASIS, AND UNIVERSITE LIBRE DE BRUXELLES HAS NO OBLIGATIONS TO 
-- PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Tests of operators that do not involved indexes for time types.
-- File TimeOps.c
-------------------------------------------------------------------------------

SELECT timestamptz '2000-01-01' + timestamptz '2000-01-01';
SELECT timestamptz '2000-01-01' + timestamptz '2000-01-02';
SELECT timestamptz '2000-01-01' + timestampset '{2000-01-02, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-05' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-06' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' + period '[2000-01-02, 2000-01-03]';
SELECT timestamptz '2000-01-01' + period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' + period '(2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-02' + period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' + period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' + period '[2000-01-01, 2000-01-03)';
SELECT timestamptz '2000-01-05' + period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' + periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-01' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-03' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' + periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-05]}';
SELECT timestamptz '2000-01-05' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-06' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' + timestamptz '2000-01-01';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' + timestampset '{2000-01-03, 2000-01-05, 2000-01-07}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' + period '[2000-01-01, 2000-01-03]';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' + periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT period '[2000-01-01, 2000-01-03]' + timestamptz '2000-01-01';
SELECT period '[2000-01-01, 2000-01-03]' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '(2000-01-01, 2000-01-03]' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03)' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03]' + period '[2000-01-01, 2000-01-03]';
SELECT period '[2000-01-01, 2000-01-03]' + period '(2000-01-03, 2000-01-05]';
SELECT period '[2000-01-01, 2000-01-03]' + periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' + timestamptz '2000-01-01';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' + timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' + period '[2000-01-01, 2000-01-03]';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' + periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';


SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-01,2000-01-02]';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-05,2000-01-06]';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-09,2000-01-10]';

SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-01,2000-01-03)';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-05,2000-01-07)';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '(2000-01-08,2000-01-10]';

SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-01,2000-01-03]';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-05,2000-01-07]';
SELECT periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}' + period '[2000-01-08,2000-01-10]';

SELECT periodset '{[2000-01-01,2000-01-02],[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-03,2000-01-06]';
SELECT periodset '{[2000-01-01,2000-01-02],[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-04,2000-01-06]';
SELECT periodset '{[2000-01-01,2000-01-02],[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-03,2000-01-05]';

SELECT periodset '{[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-01,2000-01-09]';
SELECT periodset '{[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-01,2000-01-06]';
SELECT periodset '{[2000-01-04,2000-01-05],[2000-01-07,2000-01-08]}' + period '[2000-01-06,2000-01-09]';

SELECT periodset '{[2000-01-01,2000-01-02],[2000-01-05,2000-01-06]}' + periodset '{[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}';
SELECT periodset '{[2000-01-01,2000-01-02],[2000-01-05,2000-01-06]}' + periodset '{[2000-01-01,2000-01-02],[2000-01-03,2000-01-04],[2000-01-07,2000-01-08]}';
SELECT periodset '{[2000-01-01, 2000-01-02],[2000-01-03, 2000-01-04], [2000-01-06, 2000-01-07]}' + periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}' + periodset '{[2000-01-01, 2000-01-02],[2000-01-03, 2000-01-04], [2000-01-06, 2000-01-07]}';

SELECT periodset '{[2000-01-05, 2000-01-07], [2000-01-08, 2000-01-09], [2000-01-10, 2000-01-12]}' + periodset '{[2000-01-06, 2000-01-11]}';

-------------------------------------------------------------------------------

-- temporal_minus should be used otherwise it calls the PostgreSQL - between
-- timestamps that yields an interval
SELECT temporal_minus(timestamptz '2000-01-01', timestamptz '2000-01-01');
SELECT temporal_minus(timestamptz '2000-01-01', timestamptz '2000-01-02');
SELECT timestamptz '2000-01-01' - timestampset '{2000-01-02, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-05' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-06' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' - period '[2000-01-02, 2000-01-03]';
SELECT timestamptz '2000-01-01' - period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' - period '(2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-02' - period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' - period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' - period '[2000-01-01, 2000-01-03)';
SELECT timestamptz '2000-01-05' - period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' - periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-01' - periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-03' - periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' - periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' - periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-05]}';
SELECT timestamptz '2000-01-05' - periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-06' - periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT timestampset '{2000-01-01}' - timestamptz '2000-01-01';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - timestamptz '2000-01-01';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - timestamptz '2000-01-02';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - timestampset '{2000-01-03, 2000-01-05, 2000-01-07}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - period '[2000-01-01, 2000-01-03]';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - period '[2000-01-01, 2000-01-05]';
SELECT timestampset '{2000-01-01, 2000-01-04}' - periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-06]}';
SELECT timestampset '{2000-01-01, 2000-01-04}' - periodset '{[2000-01-02, 2000-01-03]}';
SELECT timestampset '{2000-01-01, 2000-01-03}' - periodset '{(2000-01-01, 2000-01-04)}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' - periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT period '[2000-01-01, 2000-01-01]' - timestamptz '2000-01-01';
SELECT period '[2000-01-01, 2000-01-03]' - timestamptz '2000-01-01';
SELECT period '[2000-01-01, 2000-01-01]' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03]' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '(2000-01-01, 2000-01-03]' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03)' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03]' - timestampset '{2000-01-02, 2000-01-04}';
SELECT period '[2000-01-01, 2000-01-03]' - period '[2000-01-01, 2000-01-03]';
SELECT period '[2000-01-01, 2000-01-03]' - period '(2000-01-03, 2000-01-05]';
SELECT period '[2000-01-01, 2000-01-03]' - periodset '{[2000-01-01, 2000-01-02],[2000-01-04, 2000-01-05]}';
SELECT period '[2000-01-01, 2000-01-03]' - periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';


SELECT period '[2000-01-02, 2000-01-04]' - timestamptz '2000-01-01';
SELECT period '[2000-01-02, 2000-01-04]' - timestamptz '2000-01-02';
SELECT period '[2000-01-02, 2000-01-04]' - timestamptz '2000-01-03';
SELECT period '[2000-01-02, 2000-01-04]' - timestamptz '2000-01-04';
SELECT period '[2000-01-02, 2000-01-04]' - timestamptz '2000-01-05';
SELECT period '(2000-01-02, 2000-01-04)' - timestamptz '2000-01-01';
SELECT period '(2000-01-02, 2000-01-04)' - timestamptz '2000-01-02';
SELECT period '(2000-01-02, 2000-01-04)' - timestamptz '2000-01-03';
SELECT period '(2000-01-02, 2000-01-04)' - timestamptz '2000-01-04';
SELECT period '(2000-01-02, 2000-01-04)' - timestamptz '2000-01-05';

SELECT periodset '{[2000-01-01, 2000-01-01]}' - timestamptz '2000-01-01';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' - timestamptz '2000-01-01';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-06],[2000-01-07, 2000-01-08]}' - timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-02],[2000-01-03, 2000-01-04]}' - timestampset '{2000-01-01, 2000-01-02}';
SELECT periodset '{[2000-01-01, 2000-01-02],[2000-01-04, 2000-01-05]}' - timestampset '{2000-01-03, 2000-01-06}';
SELECT periodset '{[2000-01-01, 2000-01-01],[2000-01-02, 2000-01-02]}' - timestampset '{2000-01-01, 2000-01-02, 2000-01-03}';
SELECT periodset '{[2000-01-02, 2000-01-04],[2000-01-06, 2000-01-06]}' - timestampset '{2000-01-01, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-02),[2000-01-03, 2000-01-04)}' - timestampset '{2000-01-02, 2000-01-04, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-02),[2000-01-03, 2000-01-04]}' - timestampset '{2000-01-02, 2000-01-04, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' - period '[2000-01-01, 2000-01-03]';
SELECT periodset '{[2000-01-01, 2000-01-03]}' - period '[2000-01-01, 2000-01-03]';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' - periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' - periodset '{[2000-01-04, 2000-01-05]}';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' - periodset '{[2000-01-01, 2000-01-03]}';

-------------------------------------------------------------------------------

SELECT timestamptz '2000-01-01' * timestamptz '2000-01-01';
SELECT timestamptz '2000-01-01' * timestamptz '2000-01-02';
SELECT timestamptz '2000-01-01' * timestampset '{2000-01-02, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-05' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-06' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestamptz '2000-01-01' * period '[2000-01-02, 2000-01-03]';
SELECT timestamptz '2000-01-01' * period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' * period '(2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-02' * period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' * period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-03' * period '[2000-01-01, 2000-01-03)';
SELECT timestamptz '2000-01-05' * period '[2000-01-01, 2000-01-03]';
SELECT timestamptz '2000-01-01' * periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-01' * periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-03' * periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' * periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-04' * periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-05]}';
SELECT timestamptz '2000-01-05' * periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestamptz '2000-01-06' * periodset '{[2000-01-02, 2000-01-03],[2000-01-04, 2000-01-05]}';

SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' * timestamptz '2000-01-01';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' * timestampset '{2000-01-03, 2000-01-05, 2000-01-07}';
SELECT timestampset '{2000-01-01, 2000-01-03}' * timestampset '{2000-01-02, 2000-01-04}';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' * period '[2000-01-01, 2000-01-03]';
SELECT timestampset '{2000-01-01, 2000-01-03, 2000-01-05}' * periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT timestampset '{2000-01-01, 2000-01-04, 2000-01-07}' * periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-06]}';
SELECT timestampset '{2000-01-01,2000-01-03}' * periodset '{[2000-01-01,2000-01-02],[2000-01-04,2000-01-05]}';
SELECT timestampset '{2000-01-01, 2000-01-04, 2000-01-07}' * periodset '{[2000-01-02, 2000-01-03],[2000-01-05, 2000-01-06]}';
SELECT timestampset '{2000-01-03, 2000-01-06}' * periodset '{[2000-01-01, 2000-01-02],[2000-01-04, 2000-01-05]}';
SELECT timestampset '{2000-01-01, 2000-01-04}' * periodset '{(2000-01-01, 2000-01-03]}';

SELECT period '[2000-01-01, 2000-01-03]' * timestamptz '2000-01-01';
SELECT period '[2000-01-01, 2000-01-03]' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '(2000-01-01, 2000-01-03]' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03)' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT period '[2000-01-01, 2000-01-03]' * period '[2000-01-01, 2000-01-03]';
SELECT period '[2000-01-01, 2000-01-03]' * period '(2000-01-03, 2000-01-05]';
SELECT period '[2000-01-01, 2000-01-03]' * periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT period '[2000-01-03, 2000-01-04]' * periodset '{[2000-01-01, 2000-01-02],[2000-01-05, 2000-01-06]}';

SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' * timestamptz '2000-01-01';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' * timestampset '{2000-01-01, 2000-01-03, 2000-01-05}';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' * period '[2000-01-01, 2000-01-03]';
SELECT periodset '{[2000-01-01, 2000-01-02],[2000-01-03, 2000-01-04]}' * period '[2000-01-01, 2000-01-04]';
SELECT periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}' * periodset '{[2000-01-01, 2000-01-03],[2000-01-04, 2000-01-05]}';
SELECT periodset '{[2000-01-03, 2000-01-04],[2000-01-07, 2000-01-08]}' * periodset '{[2000-01-01, 2000-01-02],[2000-01-05, 2000-01-06]}';

-------------------------------------------------------------------------------
