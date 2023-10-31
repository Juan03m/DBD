Punto 1 
Cliente(idCliente, nombre, apellido, DNI, telefono, direccion)
Factura (nroTicket, total, fecha, hora,idCliente (fk))
Detalle(nroTicket, idProducto, cantidad, preciounitario)
Producto(idProducto, descripcion, precio, nombreP, stock)


1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por
DNI

SELECT c.nombre,c.apellido,c.DNI,c.telefono,c.direccion

FROM CLIENTE c

WHERE c.nombre LIKE "Pe%"


2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras
solamente durante 2017.

SELECT c.nombre,c.apellido,c.DNI,c.telefono

FROM Cliente c NATURAL JOIN Factura f

WHERE f.fecha BETWEEN 1/1/2017 and 31/12/2017








3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con
DNI:45789456, pero que no fueron vendidos a clientes de apellido ‘Garcia’.


SELECT p.nombre,p.descripcion,p.precio,p.stock

FROM Producto p NATURAL JOIN Detalle d  // productos vendidos
INNER JOIN Factura f ON (d.nroTicket=f.nroTicket)
INNER JOIN Cliente c ON (f.idCliente=c.idCliente)
WHERE (c.dni=45789456)
EXCEPT
(SELECT
FROM Producto p NATURAL JOIN Detalle d  // productos vendidos
INNER JOIN Factura f ON (d.nroTicket=f.nroTicket)
INNER JOIN Cliente c ON (f.idCliente=c.idCliente)
WHERE (c.apellido="Garcia"))






4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que
tengan teléfono con característica: 221 (La característica está al comienzo del teléfono).
Ordenar por nombre.

SELECT p.nombreP,p.descripcion,p.precio,p.stock

FROM Producto p INNER JOIN Detalle d ON (p.idProducto=d.idProducto)

EXCEPT (
    SELECT p.nombreP,p.descripcion,p.precio,p.stock

    FROM Producto p INNER JOIN Detalle d ON (p.idProducto=d.idProducto)
    INNER JOIN Factura f ON (f.nroTicket=d.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente=c.idCliente)
    WHERE (c.telefono LIKE "221%")

)

ORDER BY p.nombreP






5. Listar para cada producto: nombre, descripción, precio y cuantas veces fué vendido.
Tenga en cuenta que puede no haberse vendido nunca el producto.

SELECT p.nombreP,p.descripcion,p.precio,SUM(d.cantidad)

FROM Producto p LEFT  JOIN Detalle d ON (p.idProducto=d.idProducto)

Group By idProducto p.nombre,p.descripcion,p.precio


6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los
productos con nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre
‘prod3’.


SELECT c.nombre,c.apellido,c.DNI,c.telefono,c.direccion

FROM Producto p INNER JOIN Detalle d ON (p.idProducto=d.idProducto)
INNER JOIN Factura f ON (f.nroTicket=d.nroTicket)
INNER JOIN Cliente c ON (f.idCliente=c.idCliente)
WHERE p.nombre="prod1" or  p.nombre="prod2"
EXCEPT
(
    SELECT c.nombre,c.apellido,c.DNI,c.telefono,c.direccion
    FROM Producto p INNER JOIN Detalle d ON (p.idProducto=d.idProducto)
INNER JOIN Factura f ON (f.nroTicket=d.nroTicket)
INNER JOIN Cliente c ON (f.idCliente=c.idCliente)
WHERE p.nombre="prod3"
)




7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2019.

SELECT f.nroTicket, total, fecha, hora, DNI
FROM Producto p 
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (d.nroTicket = f.nroTicket) 
INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
WHERE (nombreP = "prod38") OR (fecha BETWEEN "01/01/2019" AND "31/12/2019")



8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’,
DNI:40578999, teléfono:221-4400789, dirección:’11 entre 500 y 501 nro:2587’ y el id de
cliente: 500002. Se supone que el idCliente 500002 no existe.

INSERT INTO CLIENTE(idCliente,nombre,apellido,DNI,telefono,direccion)
VALUES ("Jorge Luis","Castor","40578999","221-4400789","11 entre 500 y 501 nro:2587")  // entiendo que el id en autoincremental y no se agrrega 



9. Listar nroTicket, total, fecha, hora para las facturas del cliente  ́Jorge Pérez ́ donde no
haya comprado el producto  ́Z ́.
SELECT nroTicket, total, fecha, hora

FROM Cliente c INNER JOIN Factura ON (c.idCliente=f.idCliente)
INNER JOIN Detalle d ON (f.nroTicket=d.nroTicket)
INNER JOIN Producto p ON (p.idProducto=d.idProducto)
EXCEPT (
    SELECT nroTicket, total, fecha, hora
    FROM Cliente c INNER JOIN Factura ON (c.idCliente=f.idCliente)
INNER JOIN Detalle d ON (f.nroTicket=d.nroTicket)
INNER JOIN Producto p ON (p.idProducto=d.idProducto)
WHERE p.nombreP="Z"
)






10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en
cuenta todas sus facturas, supere $10.000.000.

SELECT c.DNI, c.apellido, c.nombre SUM (f.total) as suma
FROM Factura f  INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
GROUP BY c.DNI, c.apellido, c.nombre    
HAVING suma>10000

 Cual esta bien?

SELECT c.DNI, c.apellido, c.nombre
FROM Factura f 
INNER JOIN Cliente c ON (f.idCliente =  c.idCliente)
GROUP BY c.DNI, c.apellido, c.nombre
HAVING SUM (f.total) > 10000000

  


Ejercicio 2 

AGENCIA (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE (DNI, nombre, apellido, teléfono, dirección)
VIAJE( FECHA,HORA,DNI(fk), cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje



1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de
‘La Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y
luego por teléfono.

SELECT a.razón social, a.dirección,a.teléfono

FROM AGENCIA a INNER JOIN VIAJE v ON (a.razon_social=v.razon_social)
INNER JOIN Cliente cl ON (v.dni=cl.dni)
WHERE c.apellido="roma" and a.razon_social IN (
    SELECT vi.razon_social
    FROM CIUDAD c INNER JOIN Viaje vi ON (c.CODIGOPOSTAL=vi.cpOrigen)
    WHERE c.nombre="La Plata"
)



2. Listar fecha, hora, datos personales del cliente, ciudad origen y destino de viajes realizados
en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.

SELECT v.fecha,v.hora,c.nombre,c.dni,c.apellido
FROM Cliente c INNER JOIN Viaje v ON (c.dni=v.dni)
WHERE v.fecha BETWEEN 1/1/2019 and 31/12/2019 and v.descripcion LIKE "%demorado%"



3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección
de mail que termine con ‘@jmail.com’.

4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’
5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.
6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.
7. Modificar el cliente con DNI: 38495444 actualizando el teléfono a: 221-4400897.
8. Listar razon_social, dirección y teléfono de la/s agencias que tengan mayor cantidad de
viajes realizados.
9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes.
10. Borrar al cliente con DNI 40325692.

