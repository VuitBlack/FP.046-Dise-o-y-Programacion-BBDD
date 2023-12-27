-- PLANTILLA DE ENTREGA DE LA PARTE PRÁCTICA DE LAS ACTIVIDADES
-- --------------------------------------------------------------
-- Actividad: AA3(P3)
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

-- 9. Mostrar aquellos socios que cumplen años en el mes en curso. El listado deberá mostrar los siguientes campos: 
-- idSocio, Nombre, Apellido1, Email, FechaNacimiento, Cumpleaños (sí/no) Ordenado por Día de nacimiento.

select id_socio, Nombre, Apellido1, Email, fecha_nacimiento,
if(month(fecha_nacimiento) = month(curdate()), 'Sí', 'No') as Cumpleanos
from socio
where month(fecha_nacimiento)=month(curdate())
order by day(fecha_nacimiento);

-- El campo "Cumpleanos" de esta consulta nunca tendra un dato "No" ya que en la cláusula "Where" limita que solo se muestre SI.
-- Hemos creado la consulta siguiente como opción B, comentada, eliminando la cláusula "Where" por si 
-- se quiere mostrar el dato "No" en los socios que no cumplen años en el mes actual.

/*
-- Opcion B
select id_socio, Nombre, Apellido1, Email, fecha_nacimiento,
if(month(fecha_nacimiento) = month(curdate()), 'Sí', 'No') as Cumpleanos
from socio
order by day(fecha_nacimiento);

*/

-- 10. Contar cuántos socios mujeres y hombres han recomendado a otros socios, agrupados por PLAN.
-- El plan debe ser tipo 'P' (socios principales) La salida de la consulta deberá ser la siguiente. Utilizar la función IF y agrupar.

select p.plan,
sum(if(s2.sexo = 'M', 1, 0)) as Mujeres,
sum(if(s2.sexo = 'H', 1, 0)) as Hombres
from socio s1
join socio s2
on s1.recomendado_por = s2.id_socio
join plan p
on s2.id_plan = p.id_plan 
where p.tipo = 'P'
group by s2.id_plan;

-- TO DO queda mejorar para que salgan los planes que no tienen socios

-- 11. Mostrar una lista de monitores donde se especifique si imparten una o más de una actividad. 
-- Utilizar la función CASE y agrupar.

select m.id_monitor, m.nombre, concat(m.apellido1, space (1) , m.apellido2) as Apellidos,
case
	when count(distinct h.id_actividad) = 1 then 'Una actividad'
	when count(distinct h.id_actividad) > 1 then 'Más de una actividad'
	else 'Ninguna actividad'
end as actividades
from horario h
join monitor m
where h.id_monitor = m.id_monitor 
group by m.id_monitor
order by m.id_monitor;

-- 12. Inventar una consulta que haga uso de una de las siguientes funciones: COALESCE, IFNULL, NULLIF.
-- Explicar su objetivo en los comentarios de la plantilla .sql

-- COALESCE
-- Ejemplo: En la tabla socio de nuestro gimnasio, mostrar en los campos tarjeta_acceso y enfermedades: “Sin Tarjeta” y “No facilitadas” 
-- respectivamente si los valores son NULL.

select nombre, concat(apellido1, space(1), apellido2) as apellidos,
coalesce(tarjeta_acceso, 'Sin Tarjeta') as tarjeta_acceso,
coalesce(enfermedades, 'No facilitadas')as enfermedades
from socio;

-- IFNULL
-- Ejemplo: hacer una consulta en la tabla socio que muestre nombre, apellido_1 y
-- tarjeta_acceso, si el campo tarjeta_acceso es nulo usar IFNULL para mostrar 'No disponible'

select nombre, apellido1, 
	ifnull(tarjeta_acceso, 'NO dipone') as tarjeta_acceso 
	from socio;

-- NULLIF
-- Ejemplo: Hacer una consulta en la tabla socio que muestre nombre, apellido_1 y
-- sexo, si el campo sexo es hombre y tiene un valor H usar NULLIF para aplicar valor nulo.

select nombre, apellido1, 
	nullif(sexo, 'H') AS sexo 
	from socio;

-- 13. Crear una función UDF llamada Nombre Resumido que reciba como parámetros un nombre y un apellido 
-- y retorne un nombre en formato (Inicial de Nombre + "." + Apellido en mayúsculas. Ejemplo: L. LANAU).
-- Probar la función en dos consultas, una contra la tabla de monitores y otra contra la tabla de socios. 
-- Ambas consultas deberán mostrar el id del Socio o Monitor (según sea el caso), el Nombre Resumido además 
-- de sus nombres y apellidos y estar ordenadas por este campo.

delimiter //
	drop function if exists Nombre_Resumido //
	create function Nombre_Resumido (nombre varchar(30), apellido varchar(30))
		returns varchar(255) deterministic
	begin
		declare nomResum varchar(255);
			set nomResum = concat(substring(nombre, 1, 1), '.', space(1), apellido);
		return nomResum;
	end //
delimiter ;
-- Consulta sobre Socio
select id_socio, Nombre_Resumido(nombre, apellido1) as Nombre_Resumido, nombre, concat(apellido1, space(1), apellido2) as apellidos
from socio
order by Nombre_Resumido;
-- Consulta sobre Monitor
select id_monitor, Nombre_Resumido(nombre, apellido1) as Nombre_Resumido, nombre, concat(apellido1, space(1), apellido2) as apellidos
from monitor
order by Nombre_Resumido;

-- 14. Crear una función UDF llamada Pases cortesía. Se regalarán 3 pases de cortesía a aquellas empresas 
-- que tengan más de 10 empleados afiliados al gimnasio.
-- Hacer la consulta pertinente para probar la función.

delimiter //
drop function if exists Pases_Cortesia //
create function Pases_Cortesia (nifCheck varchar(15))
returns varchar(50) deterministic
begin
	declare tipoRegalo varchar(50);
	declare cantAfiliados int;
		select count(*) 
			into cantAfiliados 
			from corporativo 
			left join empresa on corporativo.nif = empresa.nif
		where corporativo.nif = nifCheck;
		if cantAfiliados > 10 then 
			set tipoRegalo = 'Regalo de 3 pases de cortesia';
		else 
			set tipoRegalo = 'No hay regalos';
        end if;
return tipoRegalo;
end //
delimiter ;

select empresa.empresa, Pases_Cortesia(empresa.nif) as regalos from empresa;

-- 15. Crear una función UDF llamada Kit Cortesía. Se regalarán un kit de cortesía 
-- a aquellos socios que cumplan años durante el mes (que recibirá la función por parámetro) 
-- según los siguientes criterios:

-- Planes premium: (3 y 4) Una entrada para dos personas para Parque acuático (de abril a noviembre) 
-- o Pista de Esquí (de diciembre a marzo).
-- Resto de planes: Botella de agua + toalla.
-- Hacer la consulta pertinente para probar la función.

delimiter //
drop function if exists Kit_Cortesia //
create function Kit_Cortesia (mesRecibido int, numSocio int)
returns varchar(80) deterministic
begin
	declare tipoRegalo varchar(80);	
	declare numPlan int;
    declare mesAniversario int;
    select id_plan into numPlan from socio where id_socio = numSocio;
    select month(fecha_nacimiento) into mesAniversario from socio where id_socio = numSocio;	
		if mesAniversario = mesRecibido then
			case 
				when numPlan = 3 or numPlan = 4 then
					if (mesRecibido >= 4 and mesRecibido <= 11) then
						set tipoRegalo = 'Regalo una entrada para dos personas para Parque acuatico';
					else
						set tipoRegalo = 'Regalo una entrada para dos personas para Pista de Esqui';
                    end if;
				else
					set tipoRegalo = 'Regalo de una Botella de agua + toalla';
			end case;
		else
			set tipoRegalo = 'No hay regalo para ti';
		end if;
return tipoRegalo;
end //
delimiter ;

-- Poner dentro de la función el mes que se quiere comprobar el aniversario
select nombre, concat(apellido1, space(1), apellido2) as apellidos, fecha_nacimiento , id_plan, Kit_Cortesia(6, socio.id_socio) as regalo
from socio
order by regalo desc;

-- 16. Crear una función UDF llamada Grasa Corporal que recibirá un parámetro de entrada en referencia al porcentaje de grasa corporal y lo traducirá de la siguiente manera:
-- 		HOMBRES: Baja (0.04 a 0.09), Saludable (0.1 a 0.19), Sobrepeso (0.2 a 0.24), Obesidad (>0.24) 
-- 		MUJERES: Baja (0.09 a 0.16), Saludable (0.17 a 0.29), Sobrepeso (0.3 a 0.34), Obesidad (>0.34)
-- Probar la función con una consulta contra la tabla de seguimiento, donde se encuentra un campo llamado 'porcentaje_grasa_corporal'. 
-- La salida de la consulta deberá tener el id del Socio, su nombre y apellido, el porcentaje de grasa corporal, el resultado de la función Grasa Corporal
-- y estar ordenada por id_socio, año y semana.




-- Variables de @usuario
-- 17. Hacer una vista llamada cumpleanhos con la lista de cumpleañeros del mes. 
-- La consulta de la vista, deberá tener los siguientes campos: id_socio, nombre, apellido1, id_plan, plan, tipo, fecha_nacimiento

create or replace view cumpleanhos AS
select id_socio, nombre, apellido1, socio.id_plan, plan.plan, tipo, fecha_nacimiento
from socio
join plan
on socio.id_plan = plan.id_plan
where month(fecha_nacimiento) = month(CURDATE());
-- Consulta de prueba de la vista cumpleanhos
-- SELECT * FROM cumpleanhos;

 -- 18. Crear dos variables de usuario. Una denominada @codigo_plan y la otra @mes_actual. 
 -- Asignar un valor a la variable @codigo_plan entre los planes que tiene el gimnasio. Asignar el valor del mes en curso a la variable @mes_actual
 
 -- Si se corrige el Script en diciembre cambiar el @codigo_plan a 6 porque no hay ningún mes que coincida compleaños con socios en planes.
set @codigo_plan = '7';
set @mes_actual = month(curdate());

-- Hacer una consulta basada en la vista cumpleanhos que utilice las variables de usuario para filtrar los cumpleañeros del mes que pertenezcan a un plan determinado.
select id_socio, nombre, apellido1, id_plan, plan, tipo, fecha_nacimiento
from cumpleanhos
where id_plan = @codigo_plan and month(fecha_nacimiento) = @mes_actual;
