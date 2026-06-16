/*добавьте сюда запрос для решения задания 2*/
-- Создаем материализованное представление в схеме cafe
CREATE MATERIALIZED VIEW cafe.v_avg_bill_change_over_years AS
WITH temp_table AS (
  SELECT
    EXTRACT(YEAR FROM s.date) AS year,
    r.name,
    r.type,
    -- Получаем средний чек за текущий год
    ROUND(AVG(s.avg_check), 2) AS avg_bill_current_year,
    -- Получаем средний чек за прошлый год с помощью LAG
    LAG(ROUND(AVG(s.avg_check), 2), 1) OVER (
      PARTITION BY r.name
      ORDER BY EXTRACT(YEAR FROM s.date) ASC
    ) AS avg_bill_previous_year
  FROM cafe.restaurants r
  JOIN cafe.sales s USING (restaurant_uuid)
  GROUP BY year, r.name, r.type
)
SELECT 
  year,
  name,
  type,
  avg_bill_current_year,
  avg_bill_previous_year,
  -- Рассчитываем процентное изменение чека год к году. NULLIF защищает от деления на ноль.
  ROUND(((avg_bill_current_year - avg_bill_previous_year) / 
  NULLIF(avg_bill_previous_year, 0)) * 100,  2) AS percentage_change
FROM temp_table
-- Отсекаем стартовый год (2023), так как для него нет данных за предыдущий период (динамика равна NULL)
WHERE year != 2023
ORDER BY name, year ASC;
