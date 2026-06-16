/*добавьте сюда запрос для решения задания 4*/
WITH all_kinds_of_pizzas AS (
  SELECT 
    r.restaurant_uuid,
    r.name,
    -- Извлекаем все ключи (названия пицц) из JSON-объекта 'Пицца' в виде отдельных строк
    jsonb_object_keys(menu->'Пицца') AS pizza_type
  FROM cafe.restaurants r
  -- Фильтруем заведения, у которых есть категория 'Пицца' на верхнем уровне JSON
  WHERE menu ? 'Пицца'
)
SELECT
  name AS restaurant_name,
  COUNT(pizza_type) AS pizza_type_count
FROM all_kinds_of_pizzas
GROUP BY restaurant_uuid, name
ORDER BY pizza_type_count DESC
LIMIT 3;
