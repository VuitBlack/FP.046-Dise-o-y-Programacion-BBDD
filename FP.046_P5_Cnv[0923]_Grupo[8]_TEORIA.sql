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

-- 1. Explica qué es un procedimiento almacenado y en qué se diferencia 
-- de una función UDF y de un disparador. 
delimiter //
create procedure Obtener_Socios_Activos()
begin
    select *
    from socio
    where activo = 1;
end //
delimiter ;

CALL Obtener_Socios_Activos();
-- drop procedure Obtener_Socios_Activos;

-- 3. ¿Qué tipos de parámetros puede tener un Procedimiento Almacenado?¿Cuál es la diferencia entre ellos?
-- procedimiento llamado Socios_por_CodigoPostal tiene el parámetro de entrada (IN) c_postal 
create procedure Socios_por_CodigoPostal(in c_postal char(5))
-- drop procedure Socios_por_CodigoPostal;

-- procedimiento llamado Contar_Socios_Activos tiene el parámetro de entrada (IN), 
-- y el de salida (OUT) total, con usigned decimos que sera un entero no negativo.
create procedure Contar_Socios_Activos(in activo int, out total int unsigned)

-- 4. ¿Cómo invocamos a un Procedimiento Almacenado para ejecutarlo?
call Socios_por_CodigoPostal(28047);

-- 5. ¿Con qué sentencia se elimina una Procedimiento Almacenado?
drop procedure Contar_Socios_Activos;

-- 6. Explicar e ilustrar con un ejemplo (para cada instrucción): Cómo se utilizan las instrucciones 
-- condicionales IF y CASE dentro de un Procedimiento Almacenado.
-- IF
delimiter //
create procedure Obtener_Socios_Activos(in s_activo tinyint)
begin
    if s_activo = 1 then select * from socio where activo = 1;
    else select * from socio where activo = 0;
    end if;
end //
delimiter ;

CALL Obtener_Socios_Activos(0);
drop procedure Obtener_Socios_Activos;

-- CASE
delimiter //
create procedure Obtener_Socios_BCN_MADRID(in s_BCN_MAD tinyint)
begin
    case (s_BCN_MAD = 0 or s_BCN_MAD != 1 or s_BCN_MAD != 2)
		when s_BCN_MAD = 1 
			then select * from socio where codigo_postal like '08%';
		when s_BCN_MAD = 2 
			then select * from socio where codigo_postal like '28%';
		else select * from socio where codigo_postal like '08%' or codigo_postal like '28%';
    end case;
end //
delimiter ;

call Obtener_Socios_BCN_MADRID(0);
drop procedure Obtener_Socios_BCN_MADRID;

-- 7. Explicar e ilustrar con un ejemplo (para cada instrucción): Cómo se utilizan los bucles:
--  LOOP, REPEAT y WHILE dentro de un Procedimiento Almacenado.
-- LOOP
delimiter //
create procedure itera_hasta_10(p1 INT)
BEGIN
  label1: LOOP
    SET p1 = p1+1;
		IF p1 < 10 
			THEN ITERATE label1;
		END IF;
	LEAVE label1;
  END LOOP label1;
  SET @x = p1;
END //
delimiter ;

call itera_hasta_10(1);
SELECT @x AS valor_de_x;
drop procedure itera_hasta_10;

-- REPEAT
delimiter //
create procedure dorepeat(p1 INT)
begin
	set @x_1 = 0;
    label2: repeat
		set @x_1 = @x_1+1;
	until @x_1 > p1 end repeat label2;
end //
delimiter ;

call dorepeat(1000);
select @x_1 as valor_x_1;
drop procedure dorepeat;

-- WHILE
delimiter //
create procedure dowhile(p1 INT)
begin
 set @x_2 = p1;
    label3: while p1 > 0 do
		set p1 = p1-1;
        set @x_2 = p1;
	end while label3;
end //
delimiter ;

call dowhile(500);
select @x_2 as valor_x_2;
drop procedure dowhile;

-- 8. Handlers durante la ejecución de procedimientos almacenados.

delimiter //
create procedure add_socio_handler(in id int, in name varchar(10))
begin
	declare not_null int default 0;
    begin
		declare exit handler for 1364 set not_null=1;
        declare exit handler for 1048 set not_null=1; 
		insert into socio(id_socio,nombre) values(id,name);
		select 'Inserción de socio correcta';
	end;
    if not_null=1 then
		select	'Inserción NO correcta,campos nulos o faltan campos obligatrios';
	end if;
end //
delimiter ;

call add_socio_handler(null,null);


drop procedure add_socio_handler;

-- 9,10,11 CURSORES.
create temporary table Socios_BCN(id_Socio INT, Nombre varchar(30), Codigo_Postal varchar(5));
delimiter //
create procedure Obtener_Socio_Prov()
begin
	declare done INT default false;
    declare idSocio INT;
    declare nombreSocio varchar(30);
    declare cpSocio varchar(5);
    declare cursor_1 cursor for select id_socio, nombre, codigo_postal from socio where codigo_postal like '08%';
    declare continue handler for NOT FOUND set done = true;
    open cursor_1;
    
    bucle_1: LOOP
    fetch cursor_1 INTO idSocio, nombreSocio, cpSocio;
		if done=true then leave bucle_1;
			else insert INTO Socios_BCN values (idSocio, nombreSocio, cpSocio);
        end if;
	set done=false;
    end LOOP;
    close cursor_1;
    select * from Socios_BCN;
end //
delimiter ;

call Obtener_Socio_Prov();

drop procedure Obtener_Socio_Prov;
drop temporary table Socios_BCN;

-- Transacciones en Procedimientos Almacenados
-- 13. Ilustrar un ejemplo, con un trozo de código, donde se incluya una transacción en un Procedimiento Almacenado.
delimiter //
create procedure update_titulacion_handler(in id_Mon int, in id_Tit int)
begin
	declare cantidad int;
    declare exito boolean default true; 
    declare continue handler for SQLEXCEPTION set exito = false;
    start transaction;		
        update titulacion set id_monitor = id_Mon where id_titulacion = id_Tit;
        select row_count() into cantidad;
        if cantidad >0 or exito = true then
        select 'Actualización CORRECTA' as 'Estado';
            commit;
        else
            select 'Actualización INCORRECTA' AS 'Estado';
            rollback;
        end if;
end //
delimiter ;

call update_titulacion_handler(30,4);

drop procedure update_titulacion_handler;

show variables like 'sql_mode';

SET sql_mode = 'TRADITIONAL';

-- EVENTOS
-- Ejemplo completo de evento.
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
    delete from Cumple_Socios;
    open cursor_1;
		bucle_1: LOOP
			fetch cursor_1 INTO idSocio, nombreSocio, fnac;
				if done=true then leave bucle_1;
					else insert INTO Cumple_Socios values (idSocio, nombreSocio, fnac);
				end if;
			set done=false;
		end LOOP;
    close cursor_1;
end //
delimiter ;

set global event_scheduler = on;

create event Lista_Socios_Cumple
on schedule every 24 hour starts '2023-12-15 00:00:00'
on completion preserve
do
call Listar_Socio_Cumple();

show events;

select * from Cumple_Socios;

drop procedure Listar_Socio_Cumple;
drop table Cumple_Socios;
drop event Lista_Socios_Cumple;
