DELIMITER //
CREATE TRIGGER T_SUP_PLAN
BEFORE DELETE
ON plan
FOR EACH ROW

BEGIN
	SIGNAL SQLSTATE '45000' SET message_text = 'Está prohibido eliminar un plan';
	SIGNAL SQLSTATE '45000' SET message_text = 'Por favor, contacte con su administrador.';
END //

DELIMITER ;

DELETE from plan where cuota_mensual = 20.00;

# SELECT * FROM ICX0_P3_8.plan;

# DROP TRIGGER T_SUP_PLAN;

ALTER TABLE plan
ADD cuota_con_iva DECIMAL(10,2) 
GENERATED ALWAYS AS (cuota_mensual*1.21) STORED
NOT NULL after cuota_mensual;

SELECT * FROM ICX0_P3_8.plan;

DELIMITER //
CREATE TRIGGER T_registro_socio_update
AFTER UPDATE
ON socio
FOR EACH ROW

BEGIN
    INSERT INTO socio_updates (updates)
    value (concat('Se modifico el socio con ID: ',NEW.id_socio,', con nombre y apellidos: ',NEW.nombre,' ',NEW.apellido1));
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER T_BEFORE_INSERT_cuota_con_iva
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
    SET NEW.cuota_con_iva = NEW.cuota_mensual * 1.21;
END //

DELIMITER ;

insert into plan (plan, tipo, matricula, cuota_mensual, descripcion)
VALUES ('12H', 'P', 30.00, 20.00, 'Acceso limitado 12h; de 6h a 18h');

SELECT * FROM ICX0_P3_8.plan;

DELIMITER //
CREATE TRIGGER T_registro_socio_update
AFTER UPDATE
ON socio
FOR EACH ROW

BEGIN
    INSERT INTO socio_updates (updates)
    value (concat('Se modifico el socio con ID: ',NEW.id_socio,', con nombre y apellidos: ',NEW.nombre,' ',NEW.apellido1));
END //

DELIMITER ;

UPDATE socio SET codigo_postal=99999 WHERE id_socio=2;

SELECT * FROM ICX0_P3_8.socio_updates;

DELIMITER //
CREATE TRIGGER T_AFTER_INSERT_plan
AFTER INSERT
ON plan
FOR EACH ROW

BEGIN
	insert into plan_historico (plan, tipo, cuota_mensual)
VALUES ('6 VIP', 'P', 25.00);
END //

DELIMITER ;

insert into plan (plan, tipo, matricula, cuota_mensual, descripcion)
VALUES ('6 VIP', 'P', 10.00, 25.00, 'Acceso limitado 12h, de 6h a 18h');


DELIMITER //
CREATE TRIGGER T_BEFORE_UPDATE_plan
BEFORE UPDATE
ON plan
FOR EACH ROW

BEGIN
	DECLARE errorMessage VARCHAR(255);
    SET errorMessage = CONCAT('La cuota mensual NO puede ser inferior a 15.00€');
    IF new.cuota_mensual<15.00 
		THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = errorMessage;
    END IF;
END //

DELIMITER ;

UPDATE plan SET cuota_mensual=10.00 WHERE id_plan=10;

DELIMITER //
CREATE TRIGGER T_BEFORE_DELETE_instalacion
BEFORE DELETE
ON instalacion
FOR EACH ROW

BEGIN
	INSERT INTO instalacion_historico(id_instalacion, zona, denominacion, metros_cuadrados)
    VALUES (OLD.id_instalacion, OLD.zona, OLD.denominacion, OLD.metros_cuadrados);
END //

DELIMITER ;

DELETE FROM `ICX0_P3_8`.`instalacion` WHERE (`id_instalacion` = '17');

INSERT INTO `ICX0_P3_8`.`instalacion` (`id_instalacion`, `zona`, `denominacion`, `metros_cuadrados`, `aforo`) VALUES ('17', 'C', 'PRUEBAS', '1000.00', '100');

SELECT * FROM ICX0_P3_8.aforo_maximo;
DELIMITER //
CREATE TRIGGER T_AFTER_DELETE_instalacion
AFTER DELETE
ON instalacion
FOR EACH ROW

BEGIN
	UPDATE aforo_maximo
    SET aforo_maximo = aforo_maximo - OLD.aforo;
END //

DELIMITER ;

DELETE FROM `ICX0_P3_8`.`instalacion` WHERE (`id_instalacion` = '17');

SELECT * FROM ICX0_P3_8.aforo_maximo;

# INSERT INTO `ICX0_P3_8`.`instalacion` (`id_instalacion`, `zona`, `denominacion`, `metros_cuadrados`, `aforo`) VALUES ('17', 'C', 'PRUEBAS', '1000.00', '100');
 

 # DROP TRIGGER T_AFTER_DELETE_instalacion;


