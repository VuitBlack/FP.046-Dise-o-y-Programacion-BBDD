-- PLANTILLA DE ENTREGA DE LA PARTE PRÁCTICA DE LAS ACTIVIDADES
-- --------------------------------------------------------------
-- Actividad: AA5(P5)
--
-- Grupo: Cnv0923_Grupo08: DBaseisData
-- 
-- Integrantes: 
-- 1. Esteban Toledo Barrios
-- 2. Salliani Paredes Rodriguez
-- 3. Sven Sebastian Arbiol Schippels
-- 4. Ricardo Sandoval Pérez
--
-- Database: ICX0_P3_8
-- --------------------------------------------------------------
-- INSERTAMOS HORARIOS CORRESPONDIENTES A ESTA SEMANA PARA PODER HACER EL PUNTO 2
-- ESTOS REGISTROS YA ESTÁN AÑADIDOS EN LA BBDD DE AWS
/*
INSERT INTO horario (id_actividad, id_instalacion, participantes, fecha, hora, id_monitor, monitor, observaciones)
VALUES
-- ------------------------------LUNES-----------------------------------------------------
	(1, 13, 15, '2023-12-25', '17:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
	(6, 4, 15, '2023-12-25', '18:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
    (11, 18, 10, '2023-12-25', '16:00:00', 27, 'Andrés', 'Clase de Natación adultos'),
    (14, 13, 18, '2023-12-25', '09:00:00', 28, 'Elena', 'Ejercicos de Pilates para alinieación'),
    (7, 3, 22, '2023-12-25', '20:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-25', '10:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos'),
-- ------------------------------MARTES------------------------------------------------------
	(1, 13, 15, '2023-12-26', '18:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
	(6, 4, 15, '2023-12-26', '19:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
    (11, 18, 10, '2023-12-26', '17:00:00', 27, 'Andrés', 'Clase de Natación adultos'),
    (14, 13, 18, '2023-12-26', '10:00:00', 28, 'Elena', 'Ejercicos de Pilates para alinieación'),
    (7, 3, 22, '2023-12-26', '20:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-26', '11:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos'),
-- -----------------------------MIERCOLES--------------------------------------------------    
	(1, 13, 15, '2023-12-27', '19:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
    (6, 4, 15, '2023-12-27', '20:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
	(11, 18, 10, '2023-12-27', '17:00:00', 27, 'Andrés', 'Clase de Natación adultos'),
    (14, 13, 18, '2023-12-27', '11:00:00', 28, 'Elena', 'Ejercicos de Pilates para alinieación'),
    (7, 3, 22, '2023-12-27', '18:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-27', '12:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos'),
-- -----------------------------JUEVES----------------------------------------------------
	(1, 13, 15, '2023-12-28', '20:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
    (6, 4, 15, '2023-12-28', '17:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
    (14, 13, 18, '2023-12-28', '10:00:00', 27, 'Andrés', 'Ejercicos de Pilates para alinieación'),
    (7, 3, 22, '2023-12-28', '18:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-28', '19:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos'),
-- -----------------------------VIERNES----------------------------------------------------   
	(1, 13, 15, '2023-12-29', '18:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
	(6, 4, 15, '2023-12-29', '19:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
    (14, 13, 18, '2023-12-29', '12:00:00', 27, 'Andrés', 'Ejercicos de Pilates para alinieación'),
    (7, 3, 22, '2023-12-29', '20:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-29', '17:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos'),
-- ------------------------SABADO--MAÑANA------------------------------------------	
    (1, 13, 15, '2023-12-30', '10:00:00', 20, 'Laura', 'Combinacion de Yoga y Acrobacias'),
    (6, 4, 15, '2023-12-30', '09:00:00', 22, 'María', 'Rutina de ejercicios con pesas'),
	(14, 13, 18, '2023-12-30', '11:00:00', 27, 'Andrés', 'Ejercicos de Pilates para alinieación'),
	(7, 3, 22, '2023-12-30', '12:00:00', 23, 'Antonio', 'Clase de Spinning'),
    (21, 2, 30, '2023-12-30', '13:00:00', 29, 'José', 'Clase de Zumba, ritmos latinos y ejercicios aróbicos');
    
-- Borramos el socio 101 que fue creado en AA1 y le falta información necesaria para el ejercicio.
delete from socio where socio.id_socio = 101;   
*/
--  1. Crear manualmente (CREATE TABLE) una tabla denominada horario_semanal.Agregar los campos del enunciado.
create table if not exists horario_semanal (
mes varchar(15) not null,
anyo int not null,
semana varchar(15) not null, 
hora time not null,
sala varchar(45) not null,
monitor varchar(20) not null,
lunes varchar(40), 
martes varchar(40), 
miercoles varchar(40),
jueves varchar(40),
viernes varchar(40),
sabado varchar(40), 
domingo varchar(40)
-- PRIMARY KEY ()
) engine=InnoDB default charset=utf8mb4;


-- 2. Crear un procedimiento almacenado que realice lo siguiente:
	-- Vaciar la tabla horario_semanal.
    -- Crear el horario para la semana en curso.Llenar los campos.
-- Después de la consulta que hicimos y de varias pruebas, encontramos dos posibles soluciones para
-- realizar este ejercicio. Estos son los dos posibles procedimientos para obtener los mismos resultado:

-- 1er. Ejemplo de procedimiento:
-- eliminar el procedimiento si existe
drop procedure if exists fill_horario_semanal;
-- creación del procedimiento
delimiter //
create procedure fill_horario_semanal()
begin
    -- controlar el idioma de las fechas
	set lc_time_names = 'es_ES';
	# Elimino los datos que haya en la tabla.
	truncate table horario_semanal;
    -- insertamos los datos en la tabla horario_semanal.
    insert into horario_semanal (mes, anyo, semana, hora, sala, monitor, lunes, martes, miercoles, jueves, viernes, sabado, domingo)
    select monthname(h.fecha) mes, year(h.fecha) año,
	if (weekday(h.fecha) != 0, concat(dayofmonth(h.fecha) - weekday(h.fecha), ' al ',  dayofmonth(h.fecha) - weekday(h.fecha) + 6) , concat(dayofmonth(h.fecha), ' al ', dayofmonth(h.fecha) +6) ) as semana,
	h.hora hora, ins.denominacion sala, concat(substring(mon.nombre, 1, 1), '.', space(1), ifnull(mon.apellido1, '')) monitor,
	if(dayname(h.fecha) = 'lunes', act.actividad, '') lunes,
	if(dayname(h.fecha) = 'martes', act.actividad, '') martes,
	if(dayname(h.fecha) = 'miercoles', act.actividad, '') miercoles,
	if(dayname(h.fecha) = 'jueves', act.actividad, '') jueves,
	if(dayname(h.fecha) = 'viernes', act.actividad, '') viernes,
	if(dayname(h.fecha) = 'sabado', act.actividad, '') sabado,
	if(dayname(h.fecha) = 'domingo', act.actividad, '') domingo
	from horario as h 
	join actividad as act on h.id_actividad = act.id_actividad
	join instalacion as ins on h.id_instalacion = ins.id_instalacion
	join monitor as mon on h.id_monitor = mon.id_monitor
	where weekofyear(h.fecha) = weekofyear(current_date)
	order by  hora;
end //
delimiter ;
-- Llamar al procedimiento
call fill_horario_semanal();
-- Obtener los datos de la tabla ordenados por hora para una correcta visualización
SELECT * FROM horario_semanal order by hora;

-- 2do. Ejemplo de procedimiento:
-- eliminar el procedimiento si existe
drop procedure if exists fill_horario_semanal;
-- creación del procedimiento
delimiter //
create procedure fill_horario_semanal()
begin
	-- Declaración de variables locales
	declare done int default false;	
	declare mes varchar(15);
	declare anyo int;
	declare semana varchar(15);
	declare hora time;
	declare sala varchar(45);
	declare monitor varchar(20);
    declare actividad, dia_semana, lunes, martes, miercoles, jueves, viernes, sabado, domingo varchar(40); 
    -- declaración del cursor
	declare cursor1 cursor for
    -- Consulta para obtener los datos
		select monthname(h.fecha) mes, year(h.fecha) anyo,
			if (weekday(h.fecha) != 0, concat(dayofmonth(h.fecha) - weekday(h.fecha), ' al ',  dayofmonth(h.fecha) - weekday(h.fecha) + 6) , concat(dayofmonth(h.fecha), ' al ', dayofmonth(h.fecha) +6) ) as semana,
			h.hora hora, ins.denominacion sala, concat(substring(mon.nombre, 1, 1), '.', space(1), ifnull(mon.apellido1, '')) monitor,
		dayname(h.fecha) dia_semana, act.actividad actividad
		from horario as h 
		join actividad as act on h.id_actividad = act.id_actividad
		join instalacion as ins on h.id_instalacion = ins.id_instalacion
		join monitor as mon on h.id_monitor = mon.id_monitor
		where weekofyear(h.fecha) = weekofyear(current_date)
		order by  hora;
	-- variable para manejar el error para final del cursor
    declare continue handler for not found set done = true;
    -- controlar el idioma de las fechas
    SET lc_time_names = 'es_ES';
    -- se abre el cursor
    open cursor1;
    -- vaciamos la tabla horario_semanal
    truncate table horario_semanal;
		-- bucle por cada cursor
		loop1:loop 
			-- obtener la fila de resultados
			fetch cursor1 into mes, anyo, semana, hora, sala, monitor, dia_semana, actividad;
            -- si no hay datos sale del bucle
            if done then
				leave loop1;
			end if;
            -- insertamos los datos en la tabla horario_semanal, en los valores hacemos los filtros con condicionales
			insert into horario_semanal (mes, anyo, semana, hora, sala, monitor, lunes, martes, miercoles, jueves, viernes, sabado, domingo)
            values(mes, anyo, semana, hora, sala, monitor, 
            if(dia_semana = 'lunes', actividad,''), 
            if(dia_semana = 'martes', actividad,''), 
            if(dia_semana = 'miercoles', actividad,''), 
            if(dia_semana = 'jueves', actividad,''), 
            if(dia_semana = 'viernes', actividad,''), 
            if(dia_semana = 'sabado', actividad,''), 
            if(dia_semana = 'domingo', actividad,''));
		end loop loop1;
    -- cierre del cursor    
	close cursor1;
end //
delimiter ;
-- Llamar al procedimiento
call fill_horario_semanal();
-- Obtener los datos de la tabla ordenados por hora para una correcta visualización
SELECT * FROM horario_semanal order by hora;

-- Después de hacer algunas pruebas y analizar los tiempo de llamada de los dos procedimientos anteriores,
-- obtenemos los siguientes tiempos de respuesta en la BBDD local:
-- Primer ejemplo de procedimiento:
-- 22:08:17	call fill_horario_semanal()	33 row(s) affected	0.031 sec
-- Segundo ejemplo de procedimiento:
-- 22:10:12	call llena_tabla_semanal()	0 row(s) affected	0.156 sec

-- Según estos datos el primer procedimiento parece estar más optimizado. Aunque hay algo extraño en la respuesta
-- obtenida en el segundo ya que nos informa que no hay ningún registro afectado, se ha comprobado previamente que la
-- tabla horario_semanal estaba vacía, pero si se consulta el resultado los datos se han insertado correctamente.

-- 3. Crear un evento que ejecute cada día el procedimiento anterior a las 8 de la mañana.

-- Activar variable global de BBDD por si estuviera en off
-- set global event_scheduler = on;
drop event if exists EV_fill_horario_semanal;

create event EV_fill_horario_semanal
on schedule every 24 hour starts '2023-12-14 08:00:00'
on completion preserve
do
	call fill_horario_semanal();

show events;

-- 4. Crear manualmente una tabla denominada domiciliaciones.Agregar los campos del enunciado.
create table if not exists  domiciliaciones (
	idSocioPrincipal int not null,
	mes int not null,
	anyo int not null,
    concepto varchar(40),
	cuentaDomiciliacion varchar(20) not null,
	banco varchar(45) not null,
	importe decimal(10,2) not null
    ) engine=InnoDB default charset=utf8mb4;


-- 5. Crear un procedimiento almacenado que realice lo siguiente:
	-- Vaciar la tabla domiciliaciones.
    -- Generar las domiciliaciones del mes a los socios no corporativos que se encuentren activos. Para ello se deberá incluir en la tabla:
    -- la cuota de su mensualidad, las inscripciones a actividades extras y los descuentos por recomendaciones.

delimiter //
create procedure fill_domiciliaciones()
begin
# Elimino los datos que haya en la tabla.
	truncate table domiciliaciones;
# Añado las columnas solicitadas si no están ya creadas
    if not exists (
		select * from information_schema.columns
		where table_name ='domiciliaciones' and column_name IN ('cuota_mensual', 'actividades_extra', 'descuentos'))
	then alter table domiciliaciones add column (cuota_mensual decimal(10,2) not null, actividad_extra decimal(10,2), descuentos decimal(10,2));
    end if;
-- Sentencia para insertar los valores en la tabla domiciliaciones
	INSERT INTO domiciliaciones (idSocioPrincipal, mes, anyo, concepto, cuentaDomiciliacion, banco, importe, cuota_mensual, actividad_extra, descuentos)
	select distinct s.id_socio as c_socio, month(curdate()) mes, year(curdate()) anyo, p.plan concepto, prin.cuenta cuenta, prin.banco banco,
		case
			-- si el descuento aplicado es nulo por lo 0 solo se suma la cuota mensual y la suma de las inscripciones que tenga cada socio
			when coalesce(descuentos.importe, 0) = 0 then (p.cuota_mensual + coalesce((select sum(importe) from inscripciones  where id_socio = s.id_socio) , 0))
            -- si el hay descuento, este ya es la cuota mensual, entonces se le suma a este la suma de las inscripciones que tenga cada socio
			else  (descuentos.importe + coalesce((select sum(importe) from inscripciones  where id_socio = s.id_socio) , 0))
            -- el resultado será el campo importe
        end as importe,
	p.cuota_mensual, coalesce((select sum(importe) from inscripciones  where id_socio = s.id_socio) , 0) as importe_extra, coalesce(descuentos.importe, 0) as cuota_con_descuento_aplicado
	from socio as s
	join plan as p on s.id_plan = p.id_plan
	join principal as prin on s.id_socio = prin.idsocio
	left join inscripciones as ins on s.id_socio = ins.id_socio
	left join descuentos on s.id_socio = descuentos.id_socio
	where p.tipo = 'P' and s.activo = 1;
end //
delimiter ;

call fill_domiciliaciones();
select * from domiciliaciones;
-- drop procedure fill_domiciliaciones;

-- 6. Crear un evento que se ejecute el día 1 de cada mes para exportar la tabla domiciliaciones generada por el procedimiento anterior a un archivo de texto.

-- Si se desea cambiar la ruta a la que se exporta se ha de cambiar la configuración del archivo my.ini la línea que hace referencia a LOAD_FILE:
-- "secure-file-priv=C:\ProgramData\MySQL\MySQL Server 8.0\Uploads"

-- Activar variable global de BBDD por si estuviera en off
-- set global event_scheduler = on;

delimiter //
create event EV_domiciliaciones
on schedule every 1 month
starts (timestamp(current_date()) - interval (day(current_date()) - 1) day) 
on completion preserve
do
	begin
		-- Llamamos al procedimiento almacenado realizado anteriormente
		call fill_domiciliaciones();
        -- Exportamos la tabla a un archivo .TXT 
		select * from domiciliaciones into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\domiciliaciones.txt'
		fields terminated by ','
		lines terminated by '\n';
        -- Exportamos la tabla a un archivo .CSV
        select * from domiciliaciones into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\domiciliaciones.csv'
		fields terminated by ','
		lines terminated by '\n';
    end //
delimiter ;

show events;
-- drop event EV_domiciliaciones;

-- 7. Inventar un procedimiento almacenado que permita optimizar las operaciones del gimnasio.
-- PARA QUE EL PROCEDIMIENTO MUESTRE DATOS EN EL ARCHIVO GENERADO (y en la tabla creada). DEBE DE HABER SOCIOS QUE CUMPLAN AÑOS ESE DÍA.
delimiter //
create procedure Listar_Socio_Cumple()
begin
	declare done INT default false;
    declare idSocio INT;
    declare nombreSocio varchar(30);
    declare fnac date;
    declare cursor_1 cursor for select id_socio, nombre, fecha_nacimiento from socio where date_format(fecha_nacimiento, '%m-%d') = date_format(curdate(), '%m-%d');
    declare continue handler for NOT FOUND set done = true;
    create table if not exists Cumple_Socios(id_Socio INT, Nombre varchar(30), fecha_nacimiento date);
    truncate Cumple_Socios;
    open cursor_1;
		bucle_1: LOOP
			fetch cursor_1 INTO idSocio, nombreSocio, fnac;
				if done=true then leave bucle_1;
					else insert INTO Cumple_Socios values (idSocio, nombreSocio, fnac);
				end if;
			set done=false;
		end LOOP;
    close cursor_1;
    select * from Cumple_Socios into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CumpleSocios.txt'
		fields terminated by ','
		lines terminated by '\n';
end //
delimiter ;

-- Activar variable global de BBDD por si estuviera en off
-- set global event_scheduler = on;

create event EV_Lista_Socios_Cumple
on schedule every 24 hour starts '2023-12-15 00:00:00'
on completion preserve
do
call Listar_Socio_Cumple();

show events;

select * from Cumple_Socios;

-- drop procedure Listar_Socio_Cumple;
-- drop table Cumple_Socios;
-- drop event EV_Lista_Socios_Cumple;

