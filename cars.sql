USE cars;

-----------------------------------------------------------
-- 0. Preparação: Ajustar tipos de dados numéricos
-----------------------------------------------------------

ALTER TABLE sales
MODIFY COLUMN price DECIMAL(12,2);

ALTER TABLE sales
MODIFY COLUMN mileage DECIMAL(10,2);


-----------------------------------------------------------
-- 1. Análise Geral
-----------------------------------------------------------

-- 1.1 Número total de carros
SELECT 
	Count(*)
FROM sales;

-- 1.2 Preço mediano geral
SELECT price as preco_mediana
FROM(
	SELECT price,
           CUME_DIST() OVER (ORDER BY price) AS cd
    FROM sales
) as sub
WHERE cd >= 0.5
ORDER BY price
limit 1;

-- 1.3 kilometragem mediano
SELECT mileage as km_mediana
FROM(
	SELECT mileage,
           CUME_DIST() OVER (ORDER BY mileage) AS cd
    FROM sales
) as sub
WHERE cd >= 0.5
ORDER BY mileage
limit 1;

-- 1.4 Lista Fabricantes
SELECT 
	Distinct manufacturer
FROM sales;

-----------------------------------------------------------
-- 2. Análise por Fabricante
-----------------------------------------------------------

-- 2.1 Top 5 maiores fabricantes
WITH total as(
	SELECT
		manufacturer,
        COUNT(*) as total_carros
	FROM sales
    GROUP BY manufacturer
)
SELECT 
	manufacturer,
    total_carros,
    RANK() OVER(ORDER BY total_carros DESC) as posicao
FROM total
ORDER BY posicao;


-- 2.2 Preço médio e mediano por fabricante
WITH preco AS (
    SELECT 
    manufacturer,
    price,
	CUME_DIST() OVER (PARTITION BY manufacturer ORDER BY price) AS cd
    FROM sales
)
SELECT 
	manufacturer,
	ROUND(AVG(price),0) AS preco_medio,
	ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END),0) AS preco_mediano
FROM preco
GROUP BY manufacturer
ORDER BY preco_medio;

-- 2.3 Kilometragem média e mediana por fabricante
WITH km_ranked AS (
    SELECT
        manufacturer,
        mileage,
        CUME_DIST() OVER (PARTITION BY manufacturer ORDER BY mileage) AS cum_dist
    FROM sales
)
SELECT
    manufacturer,
    ROUND(AVG(mileage),0) AS km_medio,
    ROUND(MIN(CASE WHEN cum_dist >= 0.5 THEN mileage END),0) AS km_mediano
FROM km_ranked
GROUP BY manufacturer
ORDER BY manufacturer;

-- 2.4 modelos mais comum por fabricante
WITH dados AS (
    SELECT
        manufacturer,
        model,
        price,
        COUNT(*) AS total_carros
    FROM sales
    GROUP BY manufacturer, model
),
ranked as(
	SELECT
		manufacturer,
        model,
        total_carros,
        price,
        RANK() OVER(PARTITION BY manufacturer ORDER BY total_carros DESC) as posicao
	FROM dados
)
SELECT 
	manufacturer,
    model,
    total_carros,
    posicao
FROM ranked
GROUP BY manufacturer, model
ORDER BY manufacturer, posicao;

-----------------------------------------------------------
-- 3. PreçoS por Características (Motor, Combustível, Ano)
-----------------------------------------------------------

-- 3.1 Motor (engine_size) - preço médio e mediano
WITH dados AS (
    SELECT
        engine_size,
        price,
        CUME_DIST() OVER (PARTITION BY engine_size ORDER BY price) AS cd
    FROM sales
)
SELECT
    engine_size,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM dados
GROUP BY engine_size
ORDER BY engine_size;

-- Por fabricante

WITH dados AS (
    SELECT
		manufacturer,
        engine_size,
        price,
        CUME_DIST() OVER (PARTITION BY engine_size ORDER BY price) AS cd
    FROM sales
)
SELECT
	manufacturer,
    engine_size,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM dados
GROUP BY manufacturer, engine_size
ORDER BY engine_size;

-----------------------------------------------
-- Fabricantes mais populares como Ford e VW possuem carros com motores somente até 2.0 e Marcas de Luxo como BMW e Porsche com motores a partir de 2.0
-- Ao olharmos para o preço mediano, não grandes diferenças de valores em relação aos fabricantes
-- Já em relação ao preço médio(AVG) vemos a diferença de preço partindo do mais barato ao mais caro(VW, FORD, TOYOTA) até 2.0
-- (BMW, TOYOTA, PORSCHE) para motores após 2.0
-----------------------------------------------

-- 3.2 Combustível (fuel_type) - preço médio e mediano
WITH dados as(
	SELECT	
		fuel_type,
        price,
        CUME_DIST() OVER (PARTITION BY fuel_type ORDER BY price) AS cd
	FROM sales
)
SELECT
    fuel_type,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM dados
GROUP BY fuel_type
ORDER BY fuel_type;

-- Por fabricante
WITH dados AS (
    SELECT
		manufacturer,
        fuel_type,
        price,
        CUME_DIST() OVER (PARTITION BY fuel_type ORDER BY price) AS cd
    FROM sales
)
SELECT
	manufacturer,
    fuel_type,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM dados
GROUP BY manufacturer, fuel_type
ORDER BY fuel_type;

--------------------------------
-- Carros híbridos com valores um pouco mais elevados
-- Fabricantes possuem as mesmas faixas de valores
--------------------------------

----------------------------------------------------------
-- 4. Custo-Benefício (Preço x KM e Preço x Idade)
-----------------------------------------------------------

-- 4.1 Faixa de idade(Ano Atual - Ano fabricação) - preço médio e mediano
WITH dados as(
	SELECT
		CASE
        WHEN (YEAR(CURDATE()) - year) BETWEEN 0 AND 10 THEN '0-10 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 11 AND 20 THEN '11-20 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 21 AND 30 THEN '21-30 anos'
        ELSE '31+ anos'
    END AS faixa_idade,
        price
	FROM sales
),
mediana as(
	SELECT
		faixa_idade,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_idade ORDER BY price) AS cd
	FROM dados
)
SELECT
    faixa_idade,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY faixa_idade
ORDER BY faixa_idade;

-- Por fabricante
WITH dados as(
	SELECT
		manufacturer,
		CASE
        WHEN (YEAR(CURDATE()) - year) BETWEEN 0 AND 10 THEN '0-10 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 11 AND 20 THEN '11-20 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 21 AND 30 THEN '21-30 anos'
        ELSE '31+ anos'
    END AS faixa_idade,
        price
	FROM sales
),
mediana as(
	SELECT
		manufacturer,
		faixa_idade,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_idade ORDER BY price) AS cd
	FROM dados
)
SELECT
	manufacturer,
    faixa_idade,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY manufacturer, faixa_idade
ORDER BY faixa_idade;

-- Por modelos
WITH dados as(
	SELECT
		manufacturer,
        model,
		CASE
        WHEN (YEAR(CURDATE()) - year) BETWEEN 0 AND 10 THEN '0-10 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 11 AND 20 THEN '11-20 anos'
        WHEN (YEAR(CURDATE()) - year) BETWEEN 21 AND 30 THEN '21-30 anos'
        ELSE '31+ anos'
    END AS faixa_idade,
        price
	FROM sales
),
mediana as(
	SELECT
		manufacturer,
        model,
		faixa_idade,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_idade ORDER BY price) AS cd
	FROM dados
)
SELECT
	manufacturer,
    model,
    faixa_idade,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY manufacturer, model, faixa_idade
ORDER BY manufacturer, faixa_idade;
--------------------------
-- Preços medianos estáveis independente da Marca
-- Quedas bruscas nos preços de -10 anos para +10 de mercado, com quedas de +10 para +20
-- Olhando para AVG BMW, Porsche sempre com valores mais altos(Marcas de Luxo)
--------------------------
--------------------------
-- Para BWM 
-- 0-10(modelos X3 OU Z4)
-- +10(qualquer modelo terá a mesma faixa de preço)
--------------------------
-- Para FORD
-- Para as mesmas faixas de anos no mercado os diferentes modelos apresentam valores similares
--------------------------
-- Para Porsche
-- -10 anos de uso melhor modelo custo benefício é 718 Cayman
-- Modelo 911 apresenta queda brusca de preço sendo benéfico comprá-lo com +10 de uso
--------------------------
-- Para Toyota
-- Modelo Yaris melhor custo benefício
--------------------------
-- Para VW
-- Golf com melhor custo benefício
--------------------------

-- 4.2 Preço médio/mediano por faixa de quilometragem
-- Geral
WITH dados as(
	SELECT
		CASE
			WHEN mileage BETWEEN 0 AND 20000 THEN '0-20k'
			WHEN mileage BETWEEN 20001 AND 50000 THEN '20k-50k'
			WHEN mileage BETWEEN 50001 AND 100000 THEN '50k-100k'
			WHEN mileage BETWEEN 100001 AND 150000 THEN '100k-150k'
			WHEN mileage > 150000 THEN '150k+'
		END AS faixa_km,
        price
	FROM sales
),
mediana as(
	SELECT
		faixa_km,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_km ORDER BY price) AS cd
	FROM dados
)
SELECT
    faixa_km,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY faixa_km
ORDER BY preco_mediano;

-- Por Fabricante
WITH dados as(
	SELECT
		manufacturer,
		CASE
			WHEN mileage BETWEEN 0 AND 20000 THEN '0-20k'
			WHEN mileage BETWEEN 20001 AND 50000 THEN '20k-50k'
			WHEN mileage BETWEEN 50001 AND 100000 THEN '50k-100k'
			WHEN mileage BETWEEN 100001 AND 150000 THEN '100k-150k'
			WHEN mileage > 150000 THEN '150k+'
		END AS faixa_km,
        price
	FROM sales
),
mediana as(
	SELECT
		manufacturer,
		faixa_km,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_km ORDER BY price) AS cd
	FROM dados
)
SELECT
	manufacturer,
    faixa_km,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY manufacturer, faixa_km
ORDER BY faixa_km;

-- Por modelo
WITH dados as(
	SELECT
		manufacturer,
		model,
		CASE
			WHEN mileage BETWEEN 0 AND 20000 THEN '0-20k'
			WHEN mileage BETWEEN 20001 AND 50000 THEN '20k-50k'
			WHEN mileage BETWEEN 50001 AND 100000 THEN '50k-100k'
			WHEN mileage BETWEEN 100001 AND 150000 THEN '100k-150k'
			WHEN mileage > 150000 THEN '150k+'
		END AS faixa_km,
        price
	FROM sales
),
mediana as(
	SELECT
		manufacturer,
		model,
		faixa_km,
        price,
		CUME_DIST() OVER (PARTITION BY faixa_km ORDER BY price) AS cd
	FROM dados
)
SELECT
	manufacturer,
	model,
    faixa_km,
    ROUND(AVG(price), 0) AS preco_medio,
    ROUND(MIN(CASE WHEN cd >= 0.5 THEN price END), 0) AS preco_mediano
FROM mediana
GROUP BY manufacturer, model, faixa_km
ORDER BY manufacturer, faixa_km;