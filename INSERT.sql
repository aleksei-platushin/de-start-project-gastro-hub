/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/
INSERT INTO cafe.restaurants (restaurant_uuid, name, type, menu) 
SELECT DISTINCT ON (m.cafe_name)
  GEN_RANDOM_UUID(), 
  m.cafe_name, 
  CAST(s.type AS cafe.restaurant_type), 
  m.menu 
FROM raw_data.menu m 
JOIN raw_data.sales s USING (cafe_name)
ORDER BY m.cafe_name;

INSERT INTO cafe.managers (manager_uuid, name, phone)
SELECT DISTINCT ON (s.manager)
  GEN_RANDOM_UUID(),
	s.manager,
	s.manager_phone
FROM raw_data.sales s
ORDER BY s.manager;
  
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT r.restaurant_uuid,
  mg.manager_uuid,
  MIN(s.report_date) AS start_date,
  MAX(s.report_date) end_date
FROM cafe.restaurants r
JOIN raw_data.menu m ON r.name = m.cafe_name
JOIN raw_data.sales s ON m.cafe_name = s.cafe_name 
JOIN cafe.managers mg on s.manager = mg.name
GROUP BY r.restaurant_uuid, mg.manager_uuid;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT s.report_date, 
  r.restaurant_uuid,
  s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.name;
