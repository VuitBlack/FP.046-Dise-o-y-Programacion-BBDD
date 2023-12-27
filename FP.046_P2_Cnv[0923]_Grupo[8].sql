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

-- ALGUNAS ACTUALIZACIONES PREVIAS PARA QUE SE PUEDAN MOSTRAR CORRECTAMENTE LAS CONSULTAS
-- TODOS ESTOS ACTUALIZACIONES YA ESTÁN APLICADAS EN NUESTRO SERVIDOR DE AWS

/*
-- Primero insertaré 5 monitores nuevos ya que los 26 existentes ya tienen 
-- horarios asignados y me irán bien para hacer las pruebas.


insert into monitor (id_monitor, doc_identificacion, nombre, apellido1, apellido2, telefono_fijo, telefono_movil, titulacion)
values
(27, 'Documento33', 'Andrés', 'Pérez', 'Martínez', '881254321', '616777888', 'si'),
(28, 'Documento34', 'Elena', 'López', 'Sánchez', '555666555', '123123123', 'no'),
(29, 'Documento35', 'José', 'García', 'Rodríguez', '887654321', '444555444', 'si'),
(30, 'Documento36', 'Laura', 'Gómez', 'González', '333444333', '666999666', 'no'),
(31, 'Documento37', 'David', 'Martínez', 'Smith', '594555555', '771237777', 'si');

-- Vamos a actualizar algunos socios para hayan sido recomendados por otros, así obtener más registros en la consulta
-- de selección. Antes crearé un disparador para que, en este caso cuando se actualice socio, 
-- se inserten los registros en la tabla descuentos.

DELIMITER //
	drop trigger if exists socio_recomendado_update //
	create trigger socio_recomendado_update
		after update 
        on socio
		for each row
	begin
    declare cuota DECIMAL(10,2);    
    IF (new.recomendado_por IS NOT NULL AND (new.id_plan != 7) AND (new.id_plan != 8)) then     
      select plan.cuota_mensual into cuota from plan where plan.id_plan = (select socio.id_plan from socio where socio.id_socio = new.recomendado_por);            
      insert into descuentos values (new.id_socio, new.recomendado_por, curdate(), cuota *0.75);
        END IF;
	end //
DELIMITER ;

update socio set recomendado_por = 3 where id_socio = 4;
update socio set recomendado_por = 4 where id_socio = 5;
update socio set recomendado_por = 7 where id_socio = 8;
update socio set recomendado_por = 12 where id_socio = 14;

-- luego quito el trigger ya que solo es para este ejercicio

drop trigger if exists socio_recomendado_update;

-- En el producto anterior no se crearon registros nuevos en la tabla actividad, solo se añadieron los campos
-- tipo y precio_sesion.
-- Para este ejercicio voy a actualizar los registros de esta tabla, todos los registros con id_actividad pares
-- serán actualizados a actividades extras con un precio aleatorio entre 40 y 60
-- Esto lo hago para obtener registros en consultas de la tabla actividades con extras
-- También actualizo la tabla inscripciones con los precios reales del valor de cada inscripción

update actividad set tipo = "extra" , precio_sesion = LEAST(FLOOR(RAND() * (13 + 1)) * 5 + 40, 60)
	where mod(id_actividad , 2) = 0;

update inscripciones
	join actividad on inscripciones.id_actividad = actividad.id_actividad
    set inscripciones.importe = actividad.precio_sesion;

-- Actualizo las inscripciones con el precio correcto según la actividad

-- COMO HE COMENTADO ESTAS ACTUALIZACIONES YA ESTÁN APLICADAS EN NUESTRA BBDD DEL SERVIDRO AWS
*/

-- Resolver con Combinaciones Externas

-- Toda esta seccíón la he solucionado con join de tipo left, right o full, aunque mysql
-- no acepta full join, ya que estos son los que se definen exactamente como combinaciones externas.

-- 14. Mostrar aquellos socios que no se han inscrito en ninguna actividad.
-- 	El listado deberá mostrar los siguientes campos:
-- 	idSocio, Nombre, Apellido1, Fecha de Alta.

select socio.id_socio, socio.nombre, socio.apellido1, socio.fecha_alta
	from socio
    left join inscripciones
    on socio.id_socio = inscripciones.id_socio
    where inscripciones.id_socio is null;

-- 15. Mostrar aquellos monitores sin horas asignadas.
-- 	El listado deberá mostrar los siguientes campos:
-- 	id, nombre, apellidos, titulación(es), teléfono fijo, teléfono móvil.

select m.id_monitor, m.nombre, concat (m.apellido1, space (1), m.apellido2) as apellidos, m.titulacion, m.telefono_fijo, m.telefono_movil
	from monitor as m
    left join horario as h
    on m.id_monitor = h.id_monitor
    where h.id_monitor is null;

-- Esta consulta obtiene estos últimos monitores añadidos a la BBDD sin horarios asignados.

-- 16. Mostrar una lista con todos los monitores tengan o no horas asignadas

-- Opcion 1

select m.id_monitor, m.nombre, concat (m.apellido1, space (1), m.apellido2) as apellidos
	from monitor as m
    left join horario as h
    on m.id_monitor = h.id_monitor
    group by m.id_monitor;

-- Opcion 2

select m.id_monitor, m.nombre, concat (m.apellido1, space (1), m.apellido2) as apellidos
	from monitor as m
    right join horario as h
    on m.id_monitor = h.id_monitor
union
select m.id_monitor, m.nombre, concat (m.apellido1, space (1), m.apellido2) as apellidos
	from monitor as m
    left join horario as h
    on m.id_monitor = h.id_monitor
    where h.id_monitor is null;

-- Como mysql no admite full join se puede hacer, utilizando combinaciones externas, usando union para
-- obtener un mismo resultado

-- 17. Mostrar una lista de socios que han sido recomendados el id, nombre y apellido de quien lo ha recomendado.

-- Opción 1

select s1.id_socio, s1.nombre, s1.apellido1,  s2.id_socio, s2.nombre, s2.apellido1
	from socio s1
	right join socio s2
    on s1.id_socio = s2.recomendado_por
    where s1.id_socio is not null;
    
-- Opción 2 con un campo descriptivo   
  
select s1.id_socio, s1.nombre, s1.apellido1," ha recomendado a " as "",  s2.id_socio, s2.nombre, s2.apellido1
	from socio s1
	right join socio s2
    on s1.id_socio = s2.recomendado_por
    where s1.id_socio is not null;

-- Resolver con Subconsultas

-- 18. Mostrar el idSocio, nombre, apellido1, apellido2 y la fecha de alta del socio corporativo más antiguo del gimnasio.

select s.id_socio, s.nombre, s.apellido1, s.apellido2, s.fecha_alta from socio s where s.id_socio = 
	(select socio.id_socio
	from socio
    join corporativo
    on socio.id_socio = corporativo.id_socio
    order by socio.fecha_alta asc limit 1);

-- 19. Indicar la sala (instalación) con el horario más reciente ocupado.

select * from instalacion	
    where instalacion.id_instalacion = (SELECT horario.id_instalacion FROM horario order by fecha desc, hora desc limit 1);

-- 20. Indicar cuál es la sala con el aforo más pequeño.

select * from instalacion 
	where aforo = (select min(aforo) from instalacion);

-- Resolver con Consultas de UNION

-- 21. Crear una consulta de UNION producto de la combinación de las siguientes cuatro consultas:
-- 	Altas del mes: idSocio, Concepto="Matrícula", Mes, Año, Matrícula
-- 	Para aquellos socios que se han dado de alta en el mes y año especificado
-- 	Cuotas: idSocio, Concepto="Cuota Mensual", Mes, Año, CuotaMensual
-- 	Descuento: idSocio, Concepto="Descuento", MesDcto, AñoDcto, Importe
-- 	De la tabla Decuento
-- 	Actividades Extra: idSocio, Concepto="Extra", Mes, Año, precioSesión
-- 	De la tabla Actividades

SET @year_especificado = 2022;
SET @month_especificado = 2;
select socio.id_socio, "Matrícula" as Concepto, month(socio.fecha_alta) as Mes, year(socio.fecha_alta) as Año, plan.matricula as Importe
 from socio 
 join plan
 on socio.id_plan = plan.id_plan 
 where year(socio.fecha_alta) = @year_especificado and month(socio.fecha_alta) = @month_especificado  
 union
  select socio.id_socio, "Cuota Mensual" as Concepto, month(socio.fecha_alta) as Mes, year(socio.fecha_alta) as Año, plan.cuota_mensual as Importe
  from socio 
  join plan
  on socio.id_plan = plan.id_plan
  where year(socio.fecha_alta) = @year_especificado and month(socio.fecha_alta) = @month_especificado
  union
   select descuentos.id_socio, "Descuento" as Concepto, month(descuentos.fecha_descuento) as Mes, year(descuentos.fecha_descuento) as Año, concat(descuentos.importe, ", importe con descuento aplicado")  as Importe
   from descuentos
   join socio
   on descuentos.id_socio = socio.id_socio
   union
    select inscripciones.id_socio, "Extra" as Concepto, month(inscripciones.fecha_Sesion) as Mes, year(inscripciones.fecha_Sesion) as Año, actividad.precio_sesion
	from actividad
    join inscripciones
    on actividad.id_actividad = inscripciones.id_actividad
    where actividad.tipo = "Extra";

-- 22. Crear una consulta de UNION producto de la combinación de las siguientes dos consultas:
--  NIF, NombreEmpresa, Teléfono, EMail
--  DNI, Nombre+Apellidos Socio, Teléfono, EMail. Sólo socios principales

select empresa.nif, empresa.empresa as Nombre, empresa.telefono, empresa.email
	from empresa
union    
 select socio.documento_identidad, concat(socio.nombre, space (1) , socio.apellido1, space (1) , socio.apellido2) as Nombre, socio.telefono_contacto, socio.email
	from socio
    where socio.id_plan between 1 and 6;

-- No muestro los nombres de los socios porque pide NombreEmpresa y no Nombre+Empresa como en el punto de los socios principales,
-- interpreto que quiere mostrar los nombres de las empresas y no de los socios corporativos.

-- Resolver con Vistas

-- 23. Utilizando la consulta de UNION del punto anterior más la tabla de Socios, crear una vista que agregue los campos 
--  idSocio, nombre Completo, Plan y NIF (en caso de ser un socio corporativo). 
--  Grabar la vista con el nombre Facturación

create or replace view Facturacion as
select socio.id_socio, socio.documento_identidad, concat(socio.nombre, space (1) , socio.apellido1, space (1) , socio.apellido2) as Nombre, 
socio.telefono_contacto, socio.email, plan.tipo as Tipo_plan, corporativo.nif, empresa.empresa
	from socio
    join plan
    on socio.id_plan = plan.id_plan
   	join corporativo
    on socio.id_socio = corporativo.id_socio
    join empresa
    on corporativo.nif = empresa.nif
    where plan.tipo = "C"
union
select socio.id_socio, socio.documento_identidad, concat(socio.nombre, space (1) , socio.apellido1, space (1) , socio.apellido2) as Nombre, 
socio.telefono_contacto, socio.email, plan.tipo as Tipo_plan, corporativo.nif, empresa.empresa
	from socio
    join plan
    on socio.id_plan = plan.id_plan
   	left join corporativo
    on socio.id_socio = corporativo.id_socio
    left join empresa
    on corporativo.nif = empresa.nif
    where plan.tipo = "P";

select * from Facturacion;

-- 24. Crear una vista a partir de la tabla HORARIOS que muestre 
-- el día de la semana (Lunes-Domingo), fecha, hora y nombre de la actividad

set lc_time_names = 'es_ES';
create or replace view HORARIOS as
select dayname(horario.fecha) as "Dia semana", horario.fecha, horario.hora, actividad.actividad
	from horario
    join actividad
    where horario.id_actividad = actividad.id_actividad order by horario.fecha desc, horario.hora desc;
  
select * from HORARIOS;