------------------------MIGRACION-----------------------------

/* MIGRANDO TABLA DE CALIFICACIONES */

PRINT 'MIGRANDO TABLA DE CALIFICACIONES';

SET IDENTITY_INSERT MERCADONEGRO.Calificaciones ON

INSERT INTO MERCADONEGRO.Calificaciones (Cod_Calificacion,Puntaje,Descripcion)
	SELECT 
			Calificacion_Codigo,
			Calificacion_Cant_Estrellas,
			Calificacion_Descripcion
	FROM gd_esquema.Maestra
	WHERE Calificacion_Codigo IS NOT NULL
	
SET IDENTITY_INSERT MERCADONEGRO.Calificaciones OFF



/* MIGRANDO TABLA DE VISIBILIDADES */

 

PRINT 'MIGRANDO TABLA DE VISIBILIDADES';

INSERT INTO MERCADONEGRO.Visibilidades(Descripcion, Costo_Publicacion, Porcentaje_Venta) 
/* NO PUSE EL CODIGO DE LA VISIBILIDAD DE LA TABLA MAESTRA */

	SELECT  DISTINCT 
					 Publicacion_Visibilidad_Desc,
					 Publicacion_Visibilidad_Precio,
					 Publicacion_Visibilidad_Porcentaje			
					 
	FROM gd_esquema.Maestra
	WHERE Publicacion_Visibilidad_Cod IS NOT NULL
	ORDER BY Publicacion_Visibilidad_Precio DESC
	


--------------------------Vistas-----------------------------


CREATE TABLE #UsuariosTemp
(
	iduser NUMERIC(18,0) IDENTITY(1,1),
	username NVARCHAR(255) NOT NULL,
	pass NVARCHAR(255) NOT NULL,
	rol int
	PRIMARY KEY (iduser)
	
)

--select * from #UsuariosTemp


INSERT INTO  #UsuariosTemp 
	SELECT DISTINCT	
	
		Publ_Cli_Apeliido+Publ_Cli_Nombre    AS username,
		CONVERT(nvarchar(255), Publ_Cli_Dni) AS pass,
		1									 AS rol
		
	FROM gd_esquema.Maestra
	WHERE Publ_Cli_Dni IS NOT NULL
	
	UNION 
	
	SELECT DISTINCT 
	
		'RazonSocialNro'+ SUBSTRING(Publ_Empresa_Razon_Social,17,2) AS username,
		CONVERT(nvarchar(255), Publ_Empresa_Cuit)				    AS pass,
		2															AS rol
		
	FROM gd_esquema.Maestra
	WHERE Publ_Empresa_Cuit IS NOT NULL
	
	

SET IDENTITY_INSERT MERCADONEGRO.Usuarios ON

INSERT INTO MERCADONEGRO.Usuarios(ID_User,Username,Password,Cant_Publi_Gratuitas,Reputacion,Ventas_Sin_Rendir)
	SELECT iduser,username,pass,0,0,0
	FROM #UsuariosTemp
	
SET IDENTITY_INSERT MERCADONEGRO.Usuarios OFF
--select * from MERCADONEGRO.Usuarios order by ID_User	






/* MIGRANDO Roles_Usuario*/	

PRINT 'MIGRANDO TABLA ROLES_USUARIOS'

INSERT INTO MERCADONEGRO.Roles_Usuarios (ID_User,ID_Rol)

	SELECT #UsuariosTemp.iduser,
		   CASE WHEN #UsuariosTemp.rol = 0 --Admin
				THEN (0)
				WHEN #UsuariosTemp.rol = 1 --Cliente
				THEN (1)
				WHEN #UsuariosTemp.rol = 2 -- Empresa
				THEN (2)
		   END
	FROM #UsuariosTemp
--SELECT * FROM MERCADONEGRO.Roles_Usuarios
	
/* MIGRANDO TABLA CLIENTES */
--select * from MERCADONEGRO.Clientes
PRINT 'MIGRANDO TABLA CLIENTES'


INSERT INTO MERCADONEGRO.Clientes (ID_User,
								   Tipo_Doc,
								   Num_Doc,
								   Nombre,
								   Apellido,
								   Mail,
								   Direccion,
								   Codigo_Postal,
								   Fecha_Nacimiento)

	SELECT DISTINCT	#UsuariosTemp.iduser,
					'DU',
					gd_esquema.Maestra.Publ_Cli_Dni,		
					gd_esquema.Maestra.Publ_Cli_Nombre,	
					gd_esquema.Maestra.Publ_Cli_Apeliido,  
					gd_esquema.Maestra.Publ_Cli_Mail,
					gd_esquema.Maestra.Publ_Cli_Dom_Calle 
									   + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Cli_Nro_Calle)
									   + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Cli_Piso)
									   + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Cli_Depto),
					gd_esquema.Maestra.Publ_Cli_Cod_Postal,
					gd_esquema.Maestra.Publ_Cli_Fecha_Nac 
			
	FROM #UsuariosTemp, gd_esquema.Maestra
	WHERE Publ_Cli_Dni IS NOT NULL AND (#UsuariosTemp.username = gd_esquema.Maestra.Publ_Cli_Apeliido+gd_esquema.Maestra.Publ_Cli_Nombre)

--select * from MERCADONEGRO.Empresas

PRINT 'MIGRANDO TABLA EMPRESAS'


INSERT INTO MERCADONEGRO.Empresas (ID_User,
								   Razon_Social,
								   CUIT,
								   Direccion,
								   Codigo_Postal,
								   Mail,
								   Fecha_Creacion)

	SELECT DISTINCT	#UsuariosTemp.iduser,
					gd_esquema.Maestra.Publ_Empresa_Razon_Social,
					gd_esquema.Maestra.Publ_Empresa_Cuit,
					gd_esquema.Maestra.Publ_Empresa_Dom_Calle 
										   + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Empresa_Nro_Calle)
									       + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Empresa_Piso)
										   + ' ' + CONVERT(nvarchar(255),gd_esquema.Maestra.Publ_Empresa_Depto),
					gd_esquema.Maestra.Publ_Empresa_Cod_Postal,
					gd_esquema.Maestra.Publ_Empresa_Mail,
					gd_esquema.Maestra.Publ_Empresa_Fecha_Creacion 
			
	FROM #UsuariosTemp,gd_esquema.Maestra
	WHERE Publ_Empresa_Cuit  IS NOT NULL AND (#UsuariosTemp.username = 'RazonSocialNro'+ RIGHT(Publ_Empresa_Razon_Social,2))

/* MIGRANDO TABLA PUBLICACIONES */

PRINT 'MIGRANDO TABLA PUBLICACIONES'

-------------DE LOS CLIENTES------------

SET IDENTITY_INSERT MERCADONEGRO.Publicaciones ON

INSERT INTO MERCADONEGRO.Publicaciones(Cod_Publicacion,
										Cod_Visibilidad,
										ID_Vendedor,
										Descripcion,
										Stock,
										Fecha_Inicial,
										Fecha_Vencimiento,
										Precio,
										Estado_Publicacion,
										Tipo_Publicacion,
										Permisos_Preguntas,
										Stock_Inicial)
										
	SELECT DISTINCT Publicacion_Cod, 
					Publicacion_Visibilidad_Cod - 10002,
					Publ_Cli_Apeliido + Publ_Cli_Nombre,
					Publicacion_Descripcion,
					Publicacion_Stock,
					Publicacion_Fecha,
					Publicacion_Fecha_Venc,
					Publicacion_Precio, 
					CASE Publicacion_Estado
						WHEN 'Publicada' THEN 0
						END, 
					CASE Publicacion_Tipo
						WHEN 'Compra Inmediata' THEN 0
						WHEN 'Subasta' THEN 1
						END, 
					0, --Permiso de preguntas (cambiar esto si es necesario)
					Publicacion_Stock
	FROM	gd_esquema.Maestra
	WHERE	Publicacion_Cod IS NOT NULL AND Publ_Cli_Dni IS NOT NULL
	
SET IDENTITY_INSERT MERCADONEGRO.Publicaciones OFF

-----------------------------DROPS-----------------------------
DROP TABLE #UsuariosTemp

