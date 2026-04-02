-- =========================================
-- Bowler Stats from Ball-by-Ball Data
-- =========================================
-- Derives economy, wickets, strike rate directly from raw data

-- SELECT 
    ab.bowler,

    SUM(ab."runs.total") AS runs_with_extra,

    SUM(ab."runs.total")
    - SUM(CASE WHEN ab."extras.byes" IS NOT NULL THEN ab."extras.byes" ELSE 0 END)
    - SUM(CASE WHEN ab."extras.legbyes" IS NOT NULL THEN ab."extras.legbyes" ELSE 0 END)
    AS runs,

    COUNT(*) AS balls_with_extra,

    COUNT(*)
    - COUNT(CASE WHEN ab."extras.wides" IS NOT NULL THEN 1 END)
    - COUNT(CASE WHEN ab."extras.noballs" IS NOT NULL THEN 1 END)
    AS balls,

    COUNT(
        CASE 
            WHEN ab."kind" IS NOT NULL
             AND ab."kind" NOT LIKE 'run out'
             AND ab."kind" NOT LIKE 'retired out'
             AND ab."kind" NOT LIKE 'retired hurt'
            THEN 1
        END
    ) AS wickets,

    COUNT(CASE WHEN ab."extras.wides" IS NOT NULL THEN 1 END) AS wides,
    COUNT(CASE WHEN ab."extras.noballs" IS NOT NULL THEN 1 END) AS nobs,

    COUNT(CASE WHEN ab."runs.batter" = 4 THEN 1 END) AS fours_given,
    COUNT(CASE WHEN ab."runs.batter" = 6 THEN 1 END) AS sixs_given

FROM all_balls ab

WHERE stage = 'middle'

GROUP BY ab.bowler

ORDER BY wickets DESC

LIMIT 20;


-- =========================================
-- Required Run Rate (RRR) Calculation
-- =========================================
-- Calculates RRR at ball level using cumulative score and remaining overs


-- /* Adding team score, runs in over, overs in decimal (to calculate run rate) */
WITH a AS (
    SELECT 
        ab."index",
        ab.match_id,
        ab."team",
        ab."over",

        SUM(ab."runs.total") OVER (
            PARTITION BY ab.match_id, ab.team
            ORDER BY ab."index"
            ROWS UNBOUNDED PRECEDING
        ) AS team_score,

        SUM(ab."runs.total") OVER (
            PARTITION BY ab.match_id, ab.team, ab."over"
            ORDER BY ab."index"
        ) AS runs_in_over,

        (
            COUNT(
                CASE 
                    WHEN ab."extras.wides" IS NULL 
                     AND ab."extras.noballs" IS NULL 
                    THEN 1 
                END
            ) OVER (
                PARTITION BY ab.match_id, ab.team
                ORDER BY ab."index"
                ROWS UNBOUNDED PRECEDING
            )
        ) / 6.0 AS over_in_decimals

    FROM all_balls ab
    ORDER BY ab."index"
),

/* Adding run rate and team total */

b AS (
    SELECT 
        *,
        a.team_score / NULLIF(a.over_in_decimals, 0) AS runrate,
        MAX(a.team_score) OVER (
            PARTITION BY a.match_id, a.team
        ) AS team_total
    FROM a
    ORDER BY a."index"
),

/* Adding target */

c AS (
    SELECT 
        *,
        (FIRST_VALUE(b.team_total) OVER (PARTITION BY b.match_id)) + 1 AS target
    FROM b
),

/* Adding required run rate */

d AS (
    SELECT 
        *,
        (c.target - c.team_score) / 
        NULLIF((20 - c.over_in_decimals), 0) AS req_runrate
    FROM c
)

SELECT * 
FROM d;



