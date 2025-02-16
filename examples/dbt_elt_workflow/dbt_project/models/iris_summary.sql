-- models/iris_summary.sql
{{ config(materialized='table') }}

WITH avg_measurements AS (
    SELECT
        species,
        AVG(sepal_length) AS avg_sepal_length,
        AVG(sepal_width) AS avg_sepal_width,
        AVG(petal_length) AS avg_petal_length,
        AVG(petal_width) AS avg_petal_width
    FROM {{ ref('iris') }}  -- Reference the seed data
    GROUP BY species
)
SELECT * FROM avg_measurements