-- Just for FUN practice
-- PATTERN

/*
WITH RECURSIVE CTE_Pattern AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM CTE_Pattern
    WHERE n < 5
)
SELECT REPEAT('*', n) AS Pattern
FROM CTE_Pattern;


WITH CTE_Pattern AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 2
    FROM CTE_Pattern
    WHERE n < 10
)
SELECT REPLICATE('*', n) AS Pattern
FROM CTE_Pattern
OPTION (MAXRECURSION 100);
*/

WITH CTE_Pattern AS
(
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM CTE_Pattern
    WHERE n < 5
)
SELECT
    REPLICATE(' ', 5 - n) +
    REPLICATE('*', 2 * n - 1) AS Pattern
FROM CTE_Pattern
OPTION (MAXRECURSION 100);

-- SQAURE

WITH CTE_Pattern AS
(
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM CTE_Pattern
    WHERE n < 5
)
SELECT
    REPLICATE('*  ', 5) AS Pattern
FROM CTE_Pattern
OPTION (MAXRECURSION 100);