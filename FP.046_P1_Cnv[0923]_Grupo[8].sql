select 
  TABLE_NAME as Nombre_Tabla, 
  COLUMN_NAME as columna, 
  REFERENCED_TABLE_NAME as Nombre_tabla_referencia, 
  REFERENCED_COLUMN_NAME as columna_tabla_referencia
from 
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
where 
  CONSTRAINT_SCHEMA = 'ICX0_P3_8'
  and REFERENCED_TABLE_NAME is not null;

-- Obtengo 8 filas con las claves foráneas

  # Nombre_Tabla  columna     Nombre_tabla_referencia columna_tabla_referencia  Nombre_de_restricción
-- corporativo    id_socio    socio         id_socio          socio_corporativo
-- corporativo    nif       empresa         nif             socio_empresa
-- historico    id_socio    socio         id_socio          historico_socio
-- horario      id_actividad  actividad       id_actividad        actividad_horario
-- horario      id_instalacion  instalacion       id_instalacion        actividad_instalacion
-- principal    idsocio     socio         id_socio          socio_principal
-- seguimiento    id_socio    socio         id_socio          seguimiento_socio
-- socio      id_plan     plan          id_plan           socio_plan

-- Una vez obtenidas las claves foráneas pasamos a su eliminación una por una

-- 10. Eliminar todas las claves foráneas existentes entre las tablas de la Base de Datos.
use ICX0_P3_8;
alter table corporativo drop constraint socio_corporativo;
alter table corporativo drop constraint socio_empresa;
alter table historico drop constraint historico_socio;
alter table horario drop constraint actividad_horario;
alter table horario drop constraint actividad_instalacion;
alter table principal drop constraint socio_principal;
alter table seguimiento drop constraint seguimiento_socio;
alter table socio drop constraint socio_plan;

-- Confirmo que las foreign keys se han eliminado correctamente

select 
  TABLE_NAME as Nombre_Tabla, 
  COLUMN_NAME as columna, 
  REFERENCED_TABLE_NAME as Nombre_tabla_referencia, 
  REFERENCED_COLUMN_NAME as columna_tabla_referencia
from 
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
where 
  CONSTRAINT_SCHEMA = 'ICX0_P3_8'
  and REFERENCED_TABLE_NAME is not null;

--  0 row(s) returned

-- 11. Realizar las modificaciones pertinentes en la Base de Datos para que la misma 
-- se ajuste a los nuevos requisitos. Recordar apuntar cada una de las instrucciones 
-- requeridas en la plantilla de la actividad de forma que los cambios se puedan replicar fácilmente.

-- 11a.

-- Crear la tabla monitor

CREATE TABLE `monitor` (
	`id_monitor` INT NOT NULL AUTO_INCREMENT,
	`doc_identificacion` varchar(15) NOT NULL UNIQUE,
	`nombre` varchar(45) NOT NULL,
	`apellido1` varchar(25),
	`apellido2` varchar(25),
	`telefono_fijo` INT  UNIQUE,
	`telefono_movil` INT NOT NULL UNIQUE,
	`titulacion` enum("si", "no") not null,
	PRIMARY KEY (`id_monitor`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear la tabla titulacion

CREATE TABLE `titulacion` (
  `id_titulacion` int NOT NULL AUTO_INCREMENT,
  `titulo_principal` varchar(150) NOT NULL,
  `especializacion` varchar(150) NOT NULL,
  `fecha_titulacion` date NOT NULL,
  `id_monitor` int,
  PRIMARY KEY (`id_titulacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Instalaciones, no tengo claro que hacer, podremos hacer el enum de las zonas, aceptamos opción de Ricardo

ALTER TABLE instalacion 
    DROP COLUMN id_instalacion;
ALTER TABLE instalacion
  ADD COLUMN id_instalacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY AFTER zona,
  MODIFY COLUMN zona ENUM('A','B','C','D','E') AFTER id_instalacion;
  
-- He creado los monitores que ya había en horario para no perderlos


INSERT INTO monitor (id_monitor, doc_identificacion, nombre, apellido1, apellido2, telefono_fijo, telefono_movil, titulacion)
VALUES
(1, 'Documento2', 'C. Powell', 'Williams', 'Jones', 987634321, 123456789, 'no'),
(2, 'Documento3', 'E. Cuquerelles', 'Brown', 'Davis', 555455555, 777773777, 'no'),
(3, 'Documento4', 'E. Thaylor', 'Miller', 'Wilson', 111111111, 222522222, 'no'),
(4, 'Documento5', 'G. Bravo', 'Moore', 'Clark', 333333373, 444444144, 'no'),
(5, 'Documento6', 'G. Gallardo', 'Taylor', 'Anderson', 666666666, 888888888, 'no'),
(6, 'Documento7', 'H. Powell', 'Thomas', 'Martin', 999998999, 555595555, 'no'),
(7, 'Documento8', 'K. Montilla', 'Harris', 'White', 777777777, 111911111, 'no'),
(8, 'Documento9', 'L. Lanau', 'Walker', 'Hall', 888888888, 666666666, 'no'),
(9, 'Documento10', 'M. Batallé', 'Lewis', 'Allen', 222222222, 336333333, 'no'),
(10, 'Documento11', 'M. Huizi', 'Young', 'Harris', 444474444, 999999999, 'no'),
(11, 'Documento12', 'M. Kumari', 'Hall', 'Scott', 123456789, 987854321, 'no'),
(12, 'Documento13', 'M. Pineda', 'Turner', 'Lee', 987654321, 222564848, 'no'),
(13, 'Documento14', 'M. Suárez', 'Jackson', 'Robinson', 155555555, 717777777, 'no'),
(14, 'Documento15', 'M. Vásquez', 'Hill', 'Green', 11511111, 222232222, 'no'),
(15, 'Documento16', 'S. Barboza', 'Adams', 'Wood', 333633333, 444444944, 'no'),
(16, 'Documento1', 'C. Alcalá', 'Smith', 'Johnson', 123656789, 987654321, 'no');

-- Añadir en la tabla horario los campos id_monitor y participantes

alter table 
	horario add id_monitor int not null after hora;
alter table 
	horario add participantes int not null after id_instalacion;
    
-- Actualizar la tabla horarios, los antiguos monitores ya están registrados
-- en la tabla monitores, ahora actualizo su id en la tabla horarios

update horario 
	set id_monitor = 
	(select distinct monitor.id_monitor from monitor where monitor.nombre = horario.monitor);    
    
-- 11b.
-- Agregar en el campo socio el campo Recomendado por. Los socios principales (no corporativos) que recomienden a otros socios, 

alter table socio add recomendado_por int default null;

-- tendrán un descuento del 25% de su cuota mensual en el mes de alta del socio recomendado. 
-- Para ello se desea llevar el control de los descuentos en una tabla. 
-- La tabla DESCUENTOS llevará los siguientes datos: idSocio, idSocioRecomendado, fechaDescuento, Importe.

CREATE TABLE `descuentos` (
  `id_socio_recomendado` int NOT NULL,
  `id_socio` int NOT NULL,  
  `fecha_descuento` date NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_socio_recomendado`, `id_socio`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11.c

-- Agregar a la tabla ACTIVIDADES los siguientes campos: tipo (incluida en el plan o extra) 
-- y precio sesión (en caso de que sea extra)


alter table actividad add tipo enum("en_plan", "extra") not null;
alter table actividad add precio_sesion decimal(10,2) not null;

-- 11.d
-- Se desea crear una registro de INSCRIPCIONES a las actividades extras 
-- por parte de los socios. Este registro permitirá agregar a la cuota del 
-- socio a final de mes, las horas facturadas por concepto de actividades extras. 
-- Esta tabla llevará los siguientes campos: idActividad, idSocio, fechaSesión, 
-- HoraSesión, Importe. La actividad debe estar previamente registrada en la tabla 
-- de Horarios además de estarlo en la tabla de actividades.

CREATE TABLE `inscripciones` (
  `id_actividad` int NOT NULL AUTO_INCREMENT,
  `id_socio` int NOT NULL,
  `fecha_sesion` date NOT NULL,
  `hora_sesion` time NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_actividad`,`id_socio`,`fecha_sesion`,`hora_sesion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. Volver a vincular todas las tablas de la Base de Datos agregando las 
-- cláusulas ON UPDATE y ON DELETE a cada clave foránea, 
-- justificando con un comentario cada decisión con comentarios en la plantilla.

ALTER TABLE corporativo
  ADD CONSTRAINT socio_corporativo FOREIGN KEY (id_socio) REFERENCES socio (id_socio) on delete no action on update cascade,  
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- En esta caso no action, se podría eliminar una empresa para eliminar un registro corporativo sin que afectara a los registros
-- de la tabla socio, pero no se podría eliminar directamente un resgistro corporativo.
  ADD CONSTRAINT socio_empresa FOREIGN KEY (nif) REFERENCES empresa (nif) on delete cascade on update cascade;
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- En este caso al borrar en cascada porque es necesario eliminar en coorporativo el nif y id de esa empresa, ya que no va a servir de nada.
ALTER TABLE historico
  ADD CONSTRAINT historico_socio FOREIGN KEY (id_socio) REFERENCES socio (id_socio) on update cascade on delete cascade;
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- Cuando se borra un historico de un socio no se borra el socio, pero cuando se borra un socio si se borra su histórico

-- cambiar el conjunto de caratcteres de la tabla ya que la hemos creado con la nueva utf8mb4 y horario estaba creada con utr8mb3

ALTER TABLE horario
  CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
  
CREATE INDEX idx_nombre_monitor ON monitor (nombre);    
ALTER TABLE horario
   ADD CONSTRAINT horario_nombre_monitor FOREIGN KEY (monitor) REFERENCES monitor (nombre) ON UPDATE CASCADE ON DELETE NO ACTION,
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- En todas estas he puesto no action porque no me permitía añadir los registros al final de script.
  ADD CONSTRAINT actividad_horario FOREIGN KEY (id_actividad) REFERENCES actividad (id_actividad)ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT instalacion_horario FOREIGN KEY (id_instalacion) REFERENCES instalacion (id_instalacion) on update NO ACTION on delete NO ACTION,
  ADD CONSTRAINT horario_id_monitor FOREIGN KEY (id_monitor) REFERENCES monitor (id_monitor) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE principal
  ADD CONSTRAINT socio_principal FOREIGN KEY (idsocio) REFERENCES socio (id_socio) on update cascade on delete cascade;
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- Cascade para borrar, para que se progague la eliminación.
ALTER TABLE seguimiento
  ADD CONSTRAINT seguimiento_socio FOREIGN KEY (id_socio) REFERENCES socio (id_socio)on update cascade on delete cascade;  
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico. 
-- No action a la hora de borrar para impeder que se borren registros de socios al intentar borrar un registro de seguimiento.
ALTER TABLE socio
  ADD CONSTRAINT socio_plan FOREIGN KEY (id_plan) REFERENCES plan (id_plan) on update cascade on delete no action,
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- No action para que al borrar un registro de la tabla socio no pueda eliminar un registro de la tabla plan.
  ADD CONSTRAINT socio_socio_recomendado FOREIGN KEY (recomendado_por) REFERENCES socio (id_socio) ON UPDATE CASCADE ON DELETE NO ACTION;
-- Si no se añade esta restricción se puede crear un socio donde el campo recomendado_por tenga un numero de id_socio que no exista

  -- Cuando una clave primaria está compuesta por varios campos en una tabla, 
  -- se crea una restricción de integridad única para esos campos combinados. 
  -- Esto significa que los valores en conjunto deben ser únicos en esa tabla. 
  -- Si intentas crear una clave foránea en otra tabla que haga referencia a uno o más de esos campos, 
  -- esos campos en la tabla secundaria deben ser únicos en conjunto para cumplir con la restricción de la clave foránea. 
  -- Si no lo son, no se podrá establecer una relación de clave foránea.

  -- Después de buscar respuestas en stackoverflow, primero se debería crear las foráneas y luego la primaria en
  -- la tabla horario. En este caso eliminar la clave primaria, crear las foraneas y luego volver a crear la primaria.
  -- O creando índices a estos campos que son parte de una clave primaria compuesta.
  -- O que la tabla inscripciones lleavara todos los campos de la PRIMARY KEY de la tabla horario

CREATE INDEX idx_actividad_fecha ON horario (id_actividad, fecha, hora);
CREATE INDEX idx_precio_sesion ON actividad (precio_sesion);
ALTER TABLE inscripciones
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- He tenido que desactivar las FK al insertar registros al final del script, creo que el problema es por la clave primaria de horario
-- que está compuesta por 4 campos mientras que en la tabla inscripciones solo venía con 3 campos
  ADD CONSTRAINT fk_inscripcion_fecha FOREIGN KEY (id_actividad, fecha_sesion, hora_sesion) REFERENCES horario (id_actividad,fecha, hora) ON UPDATE NO ACTION ON DELETE NO ACTION,
  ADD CONSTRAINT fk_inscripcion_importe FOREIGN KEY (importe) REFERENCES actividad (precio_sesion) ON UPDATE CASCADE ON DELETE NO ACTION,
  ADD CONSTRAINT fk_inscripcion_socio FOREIGN KEY (id_socio) REFERENCES socio (id_socio) ON UPDATE CASCADE ON DELETE NO ACTION;

-- Para probar esto el insert no funciona si no cambias precio_sesion el plan con id_plan 1 a 50

-- *******PRUEBA
-- insert into inscripciones values(1, 1, '2022-01-03', '19:00:00', 50);
-- *******

ALTER TABLE titulacion
	ADD CONSTRAINT fk_titulacion_socio FOREIGN KEY (id_monitor) REFERENCES monitor (id_monitor) ON UPDATE NO ACTION;
-- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
-- No action para que no sep puedan borrar titulaciones cuando se borra un monitor.

ALTER TABLE descuentos
	ADD CONSTRAINT fk_descuento_socio FOREIGN KEY (id_socio) REFERENCES socio (id_socio) ON UPDATE CASCADE ON DELETE CASCADE,
  -- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
  -- Borrar los descuentos cuando un socio se elimine
  ADD CONSTRAINT fk_descuento_recomendado_por FOREIGN KEY (id_socio_recomendado) REFERENCES socio (id_socio) ON UPDATE CASCADE ON DELETE CASCADE;
  -- Actualizar en cascada para que todas las tablas relacionadas tengan las últimas versiones de los datos, es lo más lógico.
  

-- 13. Revisar las tablas de la Base de Datos y generar dos restricciones de tipo check para controlar la integridad de los datos.

-- Solo permitir dos valores en el campo activo de la tabla socio, 1 o 0.
alter table socio
add constraint check_value_activo_socio check (activo = 1 or activo = 0);
-- Los precios de matricula y cuota mensual de la tabla plan nunca podrán ser negativos.
alter table plan
add constraint check_precios_positivo check ( matricula >= 0 and cuota_mensual >= 0);

-- 14. Crear dos campos autocalculados en diferentes tablas de la Base de Datos.
-- Crea un campo en la tabla socio multiplicando los meses desde que se dió de alta
-- hasta el día de hoy por el precio de su cuota mensual de su plan
alter table socio
add gasto_socio_total decimal(10,2);
update socio 
set socio.gasto_socio_total = (
select
(select cuota_mensual as cuota from plan where plan.id_plan = socio.id_plan) *
 (select timestampdiff(month, socio.fecha_alta,current_date) as meses) 
);

-- Crea un campo de gasto_total_empresa que representa el gasto total de la empresa
-- en el gimnasio sumando los gastos totales de todos sus empleados asociados
alter table empresa
add gasto_total_empresa decimal (15,2);
update empresa
set empresa.gasto_total_empresa = (
    SELECT SUM(socio.gasto_socio_total) 
    FROM corporativo 
    INNER JOIN socio ON corporativo.id_socio = socio.id_socio  
    WHERE corporativo.nif = empresa.nif
);
-- 15. Crear un disparador que al llenar en la tabla SOCIO el campo Recomendado 
-- por cree el registro pertinente en la tabla DESCUENTOS. 
-- Probar el disparador agregando dos nuevos socios recomendados. rehacer teniendo en cuenta el campo recomendado por

DELIMITER //
	drop trigger if exists socio_recomendado //
	create trigger socio_recomendado
		after insert 
        on socio
		for each row
	begin
    declare cuota DECIMAL(10,2);    
		IF (new.recomendado_por IS NOT NULL AND (new.id_plan != 7) AND (new.id_plan != 8)) then			
			select plan.cuota_mensual into cuota from plan where plan.id_plan = new.id_plan;            
			insert into descuentos values (new.recomendado_por, new.id_socio, curdate(), cuota *0.75);
        END IF;
	end //
DELIMITER ;

-- CON ESTE REGISTRO NO SE INSERTA NINGÚN DATO EN DESCUENTOS YA QUE PLAN = 7
INSERT INTO `socio` (`documento_identidad`, `nombre`, `apellido1`, `apellido2`, `sexo`, `fecha_nacimiento`, `id_plan`, 
`fecha_alta`, `activo`, `tarjeta_acceso`, `telefono_contacto`, `email`, `codigo_postal`, `enfermedades`, `observaciones`, `recomendado_por`) 
VALUES ('123456789', 'Juan', 'Pérez', 'López', 'M', '1990-01-15', 7, '2023-10-29', 1, 'TARJETA123', '555-123-456', 'juan@example.com', '12345', 
'Ninguna', 'Sin observaciones', 10);
-- CON ESTE REGISTRO SI QUE SE INSERTA NUEVO REGISTRO EN DESCUENTOS YA QUE PLAN = 1
INSERT INTO `socio` (`documento_identidad`, `nombre`, `apellido1`, `apellido2`, `sexo`, `fecha_nacimiento`, `id_plan`, 
`fecha_alta`, `activo`, `tarjeta_acceso`, `telefono_contacto`, `email`, `codigo_postal`, `enfermedades`, `observaciones`, `recomendado_por`) 
VALUES ('123456789', 'Juan', 'Pérez', 'López', 'M', '1990-01-15', 1, '2023-10-29', 1, 'TARJETA123', '555-123-456', 'juan@example.com', '12345', 
'Ninguna', 'Sin observaciones', 10);

-- 16. Diseñar un disparador que prevenga que un monitor no pueda impartir dos clases (actividades) al mismo tiempo en la tabla horario.

DELIMITER //
	drop trigger if exists anular_repeticion_hora_actividad //
	create trigger anular_repeticion_hora_actividad
		before insert 
        on horario
		for each row
	begin
        if  (select count(*) from horario where fecha = new.fecha and hora = new.hora and monitor = new.monitor) > 0 then
			signal sqlstate '45000'
			set message_text = 'Este monitor ya tiene este horario y fecha con otra activad';
		end if;
	end //
DELIMITER ;


  
INSERT INTO titulacion (id_titulacion, titulo_principal, especializacion, fecha_titulacion)
VALUES
(1, 'Entrenador de Gimnasio', 'Nutrición Deportiva', '2001-08-20'),
(2, 'Instructor de Aeróbicos', 'Acondicionamiento Físico', '2023-01-10'),
(3, 'Entrenador Personal', 'Entrenamiento de Fuerza', '2002-11-30'),
(4, 'Instructor de Yoga', 'Meditación y Relajación', '2001-03-05'),
(5, 'Entrenador de CrossFit', 'Entrenamiento Funcional', '2004-06-12'),
(6, 'Entrenador de Fitness', 'Entrenamiento de Resistencia', '2000-05-15');

/* 18 Insertar un mínimo de 10 registros en las tablas: */
-- 18.A MONITORES:

INSERT INTO monitor (doc_identificacion, nombre, apellido1, apellido2, telefono_fijo, telefono_movil, titulacion)
VALUES ('123456789A', 'Juan', 'Pérez', NULL, NULL, '666111222', 'si'),
  ('987654321B', 'Ana', 'López', NULL, NULL, '655333444', 'no'),
  ('555555555C', 'Carlos', NULL, NULL, '911222333', '677888999', 'si'),
  ('111111111D', 'Laura', 'Gómez', 'Rodríguez', '910777888', '666444555', 'no'),
  ('999999999E', 'Pedro', NULL, NULL, NULL, '688999000', 'si'),
  ('777777777F', 'María', 'Martínez', 'Fernández', NULL, '666777888', 'no'),
  ('222222222G', 'Antonio', 'García', 'Sánchez', '910333444', '677999000', 'si'),
  ('888888888H', 'Sofía', NULL, NULL, NULL, '677555666', 'no'),
  ('333333333I', 'Daniel', 'Hernández', NULL, NULL, '910444555', 'si'),
  ('666666666J', 'Isabel', 'López', 'González', NULL, '666555666', 'no');


-- 18.B INSTALACIONES:
INSERT INTO instalacion (id_instalacion, zona, denominacion, descripcion_zona, metros_cuadrados, aforo) VALUES
(NULL, 'A', 'Gimnasio de calistenia', 'Gimnasio para trabjar con el cuerpo', '30', 15),
(NULL, 'A', 'Sala CROSSFIT', 'Sala de pesas y barras', '30', 20),
(NULL, 'A', 'Piscina Profunda', 'Piscina de 5M de profundidad', '60', 20),
(NULL, 'B', 'Restaurante CHINO', 'Comida asíatica', '60', 40),
(NULL, 'B', 'Parking de Bicis', '', '20', 20),
(NULL, 'A', 'Restaurante VEGANO', '', '60', 20),
(NULL, 'D', 'Sala 1 de Masaje', 'Masaje deportivo', '8', 1),
(NULL, 'D', 'Sala 2 de Masaje', 'Masaje de relajación', '8', 1),
(NULL, 'D', 'Sala 3 de Masaje', 'Acupultura', '8', 1),
(NULL, 'D', 'Sala de Meditación', 'Medtitación', '40', 15),
(NULL, 'D', 'Sala de Mindfulsnes', 'Mindfullnes', '60', 20);


-- 18.C HORARIOS
INSERT INTO horario (id_actividad, id_instalacion, participantes, fecha, hora, id_monitor, monitor, observaciones)
VALUES
  (21, 16, 15, '2023-10-20', '18:00:00', 17, 'Juan', 'Clase de Yoga'),
  (18, 16, 15, '2023-10-20', '19:00:00',18, 'Ana', 'Entrenamiento de Tenis'),
  (3, 3, 10, '2023-11-03', '16:00:00', 19, 'Carlos', 'Clase de Natación'),
  (4, 4, 25, '2023-11-04', '11:00:00', 20, 'Laura', 'Entrenamiento de Fútbol'),
  (5, 5, 18, '2023-11-05', '10:30:00', 21, 'Pedro', 'Clase de Pilates'),
  (6, 6, 12, '2023-11-06', '17:00:00', 22, 'María', 'Entrenamiento de Baloncesto'),
  (7, 7, 22, '2023-11-07', '15:45:00', 23, 'Antonio', 'Clase de Spinning'),
  (8, 8, 14, '2023-11-08', '12:15:00', 24, 'Sofía', 'Entrenamiento de Voleibol'),
  (9, 9, 30, '2023-11-09', '08:30:00', 25, 'Daniel', 'Clase de Zumba'),
  (10, 10, 8, '2023-11-10', '19:00:00', 26, 'Isabel', 'Entrenamiento de Escalada');

-- 18.D INSCRIPCIONES:

SET FOREIGN_KEY_CHECKS=0;
INSERT INTO inscripciones (id_actividad, id_socio, fecha_sesion, hora_sesion, importe) VALUES
(25, 90, '2023-10-20', '18:00:00', 5.00),
(23, 85, '2023-10-20', '19:00:00', 12.00),
(24, 65, '2023-10-20', '18:00:00', 10.00),
(22, 85, '2023-10-20', '20:00:00', 15.00),
(17, 1, '2023-10-20', '21:00:00', 0.00),
(16, 2, '2023-10-21', '15:00:00', 0.00),
(11, 75, '2023-10-21', '16:00:00', 0.00),
(12, 91, '2023-10-21', '17:00:00', 0.00),
(5, 32, '2023-10-21', '18:00:00', 0.00),
(8, 25, '2023-10-21', '19:00:00', 0.00);

SET FOREIGN_KEY_CHECKS=1;


  
  