DELIMITER $$
DROP PROCEDURE IF EXISTS IF_Expresiones $$
CREATE PROCEDURE IF_Expresiones()
BEGIN
    DECLARE edad_socio TINYINT UNSIGNED DEFAULT 14;
    CASE forma_pago 
        WHEN edad_socio <= 18 THEN
			SELECT 'Niño';
        WHEN edad_socio <= 30 THEN
			SELECT 'Joven';
		WHEN edad_socio <= 50 THEN
			SELECT 'Adulto';
        ELSE
			SELECT 'Senior';
    END CASE;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS IF_Condicional $$
CREATE PROCEDURE IF_Condicional()
BEGIN
    DECLARE forma_pago ENUM('metalico','tarjeta','domicilacion');
    SET forma_pago = 'tarjeta';
    CASE forma_pago 
        WHEN 'metalico' THEN
			SELECT 'Forma de pago elegida: Metalico';
        WHEN 'tarjeta' THEN
			SELECT 'Forma de pago elegida: Tarjeta';
		WHEN 'domicilacion' THEN
			SELECT 'Forma de pago elegida: Domicilacion';
        ELSE
			SELECT 'Forma de pago incorrecta';
    END CASE;
END $$
DELIMITER ;


SELECT nombre, apellido1, apellido2,
coalesce(tarjeta_acceso, 'Sin Tarjeta') AS tarjeta_acceso,
coalesce(enfermedades, 'No facilitadas')AS enfermedades
FROM ICX0_P3_8.socio;


SELECT nombre, apellido1, codigo_postal, 
	IF(codigo_postal >= 28000 && codigo_postal <=28999, 'Madrileño', 'No Madrileño') AS ORIGEN
    FROM ICX0_P3_8.socio;

SELECT nombre, apellido1, 
	IFNULL(tarjeta_acceso, 'NO dipone') AS tarjeta_acceso 
	FROM ICX0_P3_8.socio;


SELECT nombre, apellido1, 
	NULLIF(sexo, 'H') AS sexo 
	FROM ICX0_P3_8.socio;



DELIMITER $$

CREATE FUNCTION nombre_funcion(parametro_1 tipo, parametro_2 tipo, ...)
RETURNS tipo_retorno
BEGIN
    -- Cuerpo de la función (instrucciones SQL)
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fahrenheit_to_celsius(fahrenheit DOUBLE)
RETURNS DOUBLE
BEGIN
    DECLARE celsius DOUBLE;
    SET celsius = (fahrenheit - 32) * 5 / 9;
    RETURN celsius;
END $$

DELIMITER ;




#INVOCACION DE LA FUNCION


SELECT fahrenheit_to_celsius(75) AS celsius;



#Creamos dos variables una con SET y otra con SELECT
SET @numero_ID_1 = 5;
SELECT 10 INTO @numero_ID_2;

#Usamos las variables de usuario para acceder al id_socio y nombre
SELECT id_socio, nombre FROM ICX0_P3_8.socio WHERE id_socio=@numero_ID_1;
SELECT id_socio, nombre FROM ICX0_P3_8.socio WHERE id_socio=@numero_ID_2;



SELECT nombre, @variable_1 := id_socio AS resultado FROM ICX0_P3_8.socio;


SELECT id_socio, nombre FROM ICX0_P3_8.socio WHERE id_socio=@numero_ID_1;

SELECT id_socio, id_plan, (@cariable_suma_ids := id_socio + id_plan) AS suma
FROM ICX0_P3_8.socio;



SET @gasto_medio = 0.00;

-- Calcular el promedio gasto de los socio activos y almacenar en la variable
SELECT AVG(gasto_socio_total) INTO @gasto_medio
FROM ICX0_P3_8.socio
WHERE activo = 1;

-- Mostrar el valor de la variable
SELECT @gasto_medio AS Promedio_de_gasto;







