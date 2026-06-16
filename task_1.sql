/*добавьте сюда запрос для решения задания 1*/
CREATE VIEW cafe.v_top_3_restaurants_by_type AS
  -- Шаг 1: Рассчитываем средний чек для каждого заведения за весь период
  WITH restaurant_avg_checks AS (
    SELECT 
      restaurant_uuid,
      AVG(avg_check) AS global_avg_check
    FROM cafe.sales
    GROUP BY restaurant_uuid
  ),
  -- Шаг 2: Ранжируем заведения внутри каждой категории по убыванию среднего чека
  ranked_restaurants AS (
    SELECT 
      r.name AS restaurant_name,
      r.type AS restaurant_type,
      ROUND(c.global_avg_check, 2) AS average_check,
      ROW_NUMBER() OVER (
        PARTITION BY r.type 
        ORDER BY c.global_avg_check DESC
      ) AS rank_num
    FROM restaurant_avg_checks c
    JOIN cafe.restaurants r ON c.restaurant_uuid = r.restaurant_uuid
  )
  -- Шаг 3: Выбираем топ-3 заведения для каждого типа и округляем финальный результат
  SELECT
    restaurant_name,
    restaurant_type,
    average_check
  FROM ranked_restaurants
  WHERE rank_num <= 3;
