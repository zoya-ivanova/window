/* Базы данных и SQL (семинары)
Урок 5. SQL – оконные функции*/
DROP TABLE IF EXISTS cars;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name_marka VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT * FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
CREATE VIEW InexpensivelyCars AS 
SELECT * FROM cars 
WHERE cost < 25000;

SELECT * FROM InexpensivelyCars;

-- 2. Изменить в существующем представлении порог для стоимости: 
-- пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)

ALTER VIEW InexpensivelyCars AS 
SELECT * FROM cars 
WHERE cost < 30000
ORDER BY cost;

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично)
CREATE VIEW skaud AS 
SELECT name_marka as `Марка авто`, cost as `Цена`
FROM cars 
WHERE name_marka = "Skoda" OR name_marka = "Audi";

SELECT * FROM skaud;

-- Доп задания:
-- 1* Получить ранжированный список автомобилей по цене в порядке возрастания
SELECT
ROW_NUMBER() OVER(ORDER BY cost) `№ п/п`,
cost as `Цена`, name_marka as `Марка авто`
FROM cars; 

-- 2* Получить топ-3 самых дорогих автомобилей, а также их общую стоимость  
SELECT
name_marka as `Самые дорогие авто`, 
MAX(cost)
OVER (PARTITION BY name_marka) as max_cost
FROM
(SELECT
ROW_NUMBER() OVER(ORDER BY cost),
cost, name_marka 
FROM cars) AS `num_list`
ORDER BY cost DESC
LIMIT 3;
-- это получили ТОП-3, как получить их сумму не могу сообразить

-- 4* Получить список автомобилей, у которых цена меньше следующей цены (т.е. у которых произойдет снижение цены)
-- 5*Получить список автомобилей, отсортированный по возрастанию цены, 
-- и добавить столбец со значением разницы между текущей ценой и ценой следующего автомобиля
SELECT 
id, name_marka, cost,
LAG(cost) OVER w `lag`, -- обращается к данным из предыдущей строки окна
LEAD(cost) OVER w `lead`, -- к данным из следующей строки
FIRST_VALUE(cost) OVER w `first`, -- получить первое значение в окне
LAST_VALUE(cost) OVER w `last` -- получить первое и последнее значение в окне
FROM cars
WINDOW w AS (PARTITION BY cost); 