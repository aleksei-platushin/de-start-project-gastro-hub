/*добавьте сюда запрос для решения задания 3*/
WITH manager_timeline AS (
  SELECT
    restaurant_uuid,
    manager_uuid,
    -- Получаем ID предыдущего менеджера для этого же ресторана
    LAG(manager_uuid) OVER (
      PARTITION BY restaurant_uuid 
      ORDER BY start_date ASC
    ) AS previous_manager_uuid
  FROM cafe.restaurant_manager_work_dates
)
SELECT 
  r.name AS restaurant_name,
  COUNT(*) AS number_of_changes
FROM cafe.restaurants r
JOIN manager_timeline mt USING (restaurant_uuid)
-- Игнорируем самого первого менеджера, так как это первое назначение, а не замена
WHERE mt.previous_manager_uuid IS NOT NULL
-- Считаем только те строки, где ID нового менеджера не совпадает с предыдущим
  AND mt.previous_manager_uuid != mt.manager_uuid  
GROUP BY r.name
ORDER BY number_of_changes DESC
LIMIT 3;
