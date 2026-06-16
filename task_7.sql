/*добавьте сюда запросы для решения задания 6*/
BEGIN;

-- Блокируем изменения таблицы (SHARE), но оставляем ее доступной для чтения (SELECT)
LOCK TABLE cafe.managers IN SHARE MODE NOWAIT;

-- Добавляем колонку для хранения массива телефонов
ALTER TABLE cafe.managers 
ADD COLUMN phone_list text[] DEFAULT '{}'::text[] NOT NULL;

-- Генерируем новые номера по алфавиту начиная со 100
WITH phone_extension AS (
  SELECT 
    m.manager_uuid,
    m.name,
    100 + (ROW_NUMBER() OVER (ORDER BY m.name ASC) - 1) AS calculated_extension
  FROM cafe.managers m
)
-- Сохраняем в массив новый номер на первую позицию, а старый на вторую
UPDATE cafe.managers m
SET 
  phone_list = ARRAY['8-800-2500-' || pe.calculated_extension, m.phone]::text[]
FROM phone_extension pe
WHERE m.manager_uuid = pe.manager_uuid;

-- Удаляем старую одиночную колонку с телефоном
ALTER TABLE cafe.managers 
DROP COLUMN phone;

COMMIT;

/* ПОЯСНЕНИЕ ВЫБОРА БЛОКИРОВКИ: Использован режим SHARE MODE, так как он разрешает
параллельное чтение данных (SELECT), но полностью блокирует любые попытки изменения
таблицы (INSERT, UPDATE, DELETE) другими сессиями. Это гарантирует, что во время
работы скрипта алфавитный список менеджеров зафиксирован, и никто не сможет вклиниться
и нарушить расчет последовательности ROW_NUMBER(). Опция NOWAIT добавлена для того,
чтобы скрипт мгновенно завершился с ошибкой, если таблица уже занята другой тяжелой
операцией, вместо долгого ожидания в очереди.
*/
