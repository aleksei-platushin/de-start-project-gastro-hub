/*добавьте сюда запрос для решения задания 5*/
WITH pizza_restaurants AS (
  SELECT 
    r.name AS restaurant_name,
    'Пицца' AS dish_type,
    pizza.key AS pizza_type,
    -- Приводим текст к числовому типу для корректной сортировки цен
    pizza.value::numeric AS price
FROM cafe.restaurants r
CROSS JOIN LATERAL jsonb_each_text(r.menu -> 'Пицца') AS pizza
),
ranked_pizzas AS (
  SELECT
    restaurant_name,
    dish_type,
    pizza_type,
    price,
    -- Нумеруем пиццы внутри каждого ресторана от самых дорогих к самым дешевым
    ROW_NUMBER() OVER (
        PARTITION BY restaurant_name 
        ORDER BY price DESC
    ) AS rank_num
  FROM pizza_restaurants
)
SELECT
  restaurant_name,
  dish_type,
  pizza_type,
  price
FROM ranked_pizzas
-- Выбираем самую дорогую пиццу для каждого ресторана
WHERE rank_num = 1
ORDER BY price DESC;
