-- PLANTILLA DE ENTREGA DE LA PARTE PRÁCTICA DE LAS ACTIVIDADES
-- --------------------------------------------------------------
-- Actividad: AA4(P4)
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

-- BUENAS PRÁCTICAS EN CONSULTAS
-- 1. Sustituir los operadores OR en lo posible en las cláusulas WHERE y HAVING por el operador IN.
select s.id_socio, s.nombre, concat(s.apellido1, space (2) , s.apellido2) as apellidos, s.fecha_nacimiento, s.email
from ICX0_P3_8.socio s
where year(s.fecha_nacimiento) in (1972,1977,2000)
order by s.fecha_nacimiento;

-- 2. Realizar búsquedas binarias sobre Índices FULLTEXT para sustituir caracteres comodín.
alter table ICX0_P3_8.socio add FULLTEXT(apellido1, codigo_postal);

select * 
from socio
where match(apellido1,codigo_postal) against('+K* -46*' IN boolean mode);
 
-- 3. Tener un equilibrio en el número de índices (Índices faltantes o indexación excesiva)
 
-- 4. Preparar VISTAS o utilizar tablas temporales para sustituir demasiados JOINS en una consulta.
 
-- 5. Todas las tablas deben tener una clave primaria y según el tipo de búsquedas que se hagan un índice agrupado.
create index idx_monitor_nombre_titulacion on monitor (nombre asc, titulacion desc);

-- SENTENCIAS EXPLAIN Y OPTIMIZE TABLE
-- 6. Explicar cómo se utiliza la sentencia EXPLAIN. Se usa la consulta 10 del PRODUCTO_3
EXPLAIN select p.plan,
sum(if(s2.sexo = 'M', 1, 0)) as Mujeres,
sum(if(s2.sexo = 'H', 1, 0)) as Hombres
from socio s1
join socio s2
on s1.recomendado_por = s2.id_socio
join plan p
on s2.id_plan = p.id_plan 
where p.tipo = 'P'
group by s2.id_plan;
show warnings;


-- 7. ¿Para qué se usan las columnas key y type y cuáles son los posibles valores de esta última columna?

-- se usa la tabla de salida del ejemplo anterior.

-- 8. ¿Cómo se interpretan los valores de la columna type y qué acciones podrían tomarse para optimizar la consulta?

-- se usa la tabla de salida del ejemplo anterior.

-- 9. ¿Cuál es la sintaxis de OPTIMIZE TABLE?
-- mostramos el estado de la tabla socio, el campo data_free muestra el espacio que podemos liberar de la tabla socio.
show table status like "socio";
-- con esta consulta obtenemos el espacio que podemos liberar data_free de todas la tablas
select table_name, data_length, data_free
from information_schema.tables
where table_schema='test'
order by data_free DESC;
-- Optimización de la tabla socio y monitor.
optimize table socio, monitor;

-- Creación de índices 
-- 10. ¿Qué sentencia SQL permite la creación de Índices? Indicar la sintaxis. 
create index idx_zona on instalacion(zona);

-- 11. ¿Con qué sentencia se elimina un índice? 
drop index idx_zona on instalacion;

-- 12. ¿Para qué se utilizan los diferentes tipos de índice en MySQL (PRIMARY | UNIQUE | FULLTEXT | SPATIAL)? 
create unique index idx_dni on socio(documento_identidad);
create fulltext index idx_nombre_apellidos on socio(nombre, apellido1);

-- 13. Explica las características de los tipos de estructuras en las cuales se pueden 
-- crear índices (B-TREE y HASH) y cuándo es mejor usar una u otra. 
-- B-TREE hacemos un índice sobre la columna codigo_postal
create index idx_codigo_postal on socio(codigo_postal);
-- nos permite acelerar búsquedas en consultas sobre el código postal
select * 
from socio
where codigo_postal=48005;
-- nos permite ordenar por codigo postal
select *
from socio 
order by codigo_postal;

-- HASH hacemo un índice sobre la columna email
create index idx_email using hash on socio(email);
-- nos permite acelerar las búsquedas sobre el email exacto del socio
select * 
from socio
WHERE email='juan@example.com';
-- NO NOS SIRVE para consultas que usen condiciones de desigualdad o rango.
select * 
from socio 
where email like '%gmail.com';

-- 14. ¿Cómo se crea un índice sobre varios campos y cuál sería su utilidad? 
create index idx_nombre_apellido on socio(nombre asc, apellido1 desc);

-- 15. MySQL ofrece búsqueda FULLTEXT. ¿Qué condiciones deben darse para poder ejecutar este tipo de búsquedas?

-- En este ejercicio se usa el ejemplo creado en el ejercicio 2

-- 16. ¿Qué es una búsqueda BOOLEAN FULLTEXT y por qué es mucho más rápida que utilizar el operador LIKE?
select id_socio, nombre, apellido1, apellido2, sexo, codigo_postal
from socio
where match(apellido1, codigo_postal) against('+C* -38*' in boolean mode);

-- 17 ¿Es posible realizar búsquedas FULLTEXT contra varias columnas de una tabla?
select id_socio, nombre, apellido1, apellido2, sexo, codigo_postal 
from socio
where match(nombre, apellido1, codigo_postal) against('+DAV* -R* +38*' in boolean mode);

-- 18. ¿Cuáles son los pasos del proceso para crear un Prepared Statement en MySQL?
set @table = 'socio';
set @s1 = concat('select id_socio,nombre, apellido1,apellido2, email, 
codigo_postal, gasto_socio_total from ', @table, ' where codigo_postal>48030');

prepare stmt_1 from @s1;
execute stmt_1;
deallocate prepare stmt_1;

-- 21. ¿Qué es un rol y cómo se crea un rol?
create role if not exists 'app_developer', 'app_reader', 'app_writter';

-- 22. ¿Cómo se asignan usuarios a un rol?
-- Assignamos los privilegios a los roles creados anteriormente.
grant all on ICX0_P3_8.* to 'app_developer';
grant select on ICX0_P3_8.* to 'app_reader';
grant insert, update, delete on ICX0_P3_8.* to 'app_writter';

-- Creamos la cuenta de administrador, una cuenta de lectura y una cuenta de escritura.
create user 'developer_1'@'localhost' identified by 'dev1pass';
create user 'read_user_1'@'localhost' identified by 'r_user1pass';
create user 'read-writte_user1'@'localhost' identified by 'rw_user1pass';

-- Asignamos a cada cuenta de usuario los privilegios.
GRANT 'app_developer' TO 'developer_1'@'localhost';
GRANT 'app_reader' TO 'read_user_1'@'localhost';
GRANT 'app_reader', 'app_writter' TO 'read-writte_user1'@'localhost';

-- 23. ¿Cómo retirar usuarios de un rol?
revoke 'app_writter' from 'read-writte_user1'@'localhost';

/* estas sentencias son para comprobar la asignación de permisos
show grants for 'read-writte_user1'@'localhost';
select USER, host from mysql.user;
drop user 'read-writte_user1'@'localhost';
*/

-- 24. ¿Cómo eliminar un rol y qué se requiere antes de hacerlo?
drop role 'app_developer', 'app_reader', 'app_writter';

























