/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/
CREATE SCHEMA IF NOT EXISTS cafe;

CREATE TYPE cafe.restaurant_type AS ENUM
('coffee_shop', 'restaurant', 'bar', 'pizzeria');

CREATE TABLE IF NOT EXISTS cafe.restaurants (
restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
name VARCHAR NOT NULL,
type cafe.restaurant_type NOT NULL,
menu jsonb NOT NULL
);

CREATE TABLE IF NOT EXISTS cafe.managers (
manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
name VARCHAR NOT NULL,
phone VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates (
restaurant_uuid UUID REFERENCES cafe.restaurants (restaurant_uuid) ON DELETE CASCADE,
manager_uuid UUID REFERENCES cafe.managers (manager_uuid) ON DELETE CASCADE,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
PRIMARY KEY (restaurant_uuid, manager_uuid, start_date)
);

CREATE TABLE IF NOT EXISTS cafe.sales (
date DATE NOT NULL,
restaurant_uuid UUID REFERENCES cafe.restaurants (restaurant_uuid) ON DELETE CASCADE,
avg_check NUMERIC(6,2) NOT NULL,
PRIMARY KEY (date, restaurant_uuid)
);
