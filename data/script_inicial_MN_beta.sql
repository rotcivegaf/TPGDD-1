USE [GD1C2014]

IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'MERCADONEGRO')
DROP SCHEMA [MERCADONEGRO]
GO

CREATE SCHEMA MERCADONEGRO AUTHORIZATION gd
GO

---------------------------------------------Tablas iniciales-------------------------------------------

CREATE TABLE MERCADONEGRO.Rubros 
(
	ID_Rubro	NUMERIC(18,0) IDENTITY,
	Descripcion NVARCHAR(255) NOT NULL,
	
	UNIQUE		(Descripcion),
	PRIMARY KEY (ID_Rubro)
)

CREATE TABLE MERCADONEGRO.Funcionalidades
(
	ID_Funcionalidad NUMERIC(18,0) IDENTITY,
	Nombre			 NVARCHAR(255) NOT NULL,
	
	UNIQUE		(Nombre),
	PRIMARY KEY (ID_Funcionalidad)
)

CREATE TABLE MERCADONEGRO.Preguntas
(
	ID_Pregunta		NUMERIC(18,0) IDENTITY,
	Pregunta		NVARCHAR(255) NOT NULL,
	Respuesta		NVARCHAR(255) NULL,
	Fecha_Respuesta DATETIME	  NULL,
	
	PRIMARY KEY ( ID_Pregunta )
)

CREATE TABLE MERCADONEGRO.Calificaciones
(
	Cod_Calificacion NUMERIC(18,0) IDENTITY,  
	Puntaje			 TINYINT	   NULL,
	Descripcion		 NVARCHAR(255) NULL,
	
	PRIMARY KEY ( Cod_Calificacion )
)

CREATE TABLE MERCADONEGRO.Visibilidades
(
	Cod_Visibilidad   NUMERIC(18,0) IDENTITY (0,1),
	Descripcion		  NVARCHAR(255) NOT NULL,
	Costo_Publicacion NUMERIC(18,2) NOT NULL,
	Porcentaje_Venta  NUMERIC(18,2) NOT NULL,
	
	UNIQUE		(Descripcion),
	PRIMARY KEY ( Cod_Visibilidad )
)

CREATE TABLE MERCADONEGRO.Publicaciones
(
	Cod_Publicacion    NUMERIC(18,0) IDENTITY,
	Cod_Visibilidad    NUMERIC(18,0) NOT NULL, 
	ID_Vendedor		   NUMERIC(18,0) NOT NULL,
	Descripcion		   NVARCHAR(255) NOT NULL,
	Stock			   NUMERIC(18,0) NOT NULL,
	Fecha_Vencimiento  DATETIME		 NOT NULL,
	Fecha_Inicial	   DATETIME		 NOT NULL,
	Precio			   NUMERIC(18,2) NOT NULL,
	Estado_Publicacion TINYINT		 NOT NULL,
	Tipo_Publicacion   TINYINT		 NOT NULL,
	Permisos_Preguntas BIT			 NOT NULL,
	Stock_Inicial	   NUMERIC(18,0) NOT NULL,
	
	PRIMARY KEY (Cod_Publicacion),
	FOREIGN KEY (Cod_Visibilidad) REFERENCES MERCADONEGRO.Visibilidades(Cod_Visibilidad)
)

CREATE TABLE MERCADONEGRO.Items
(
	ID_Item			 NUMERIC(18,0) IDENTITY, 
	Cantidad_Vendida NUMERIC(18,0) NOT NULL,
	Descripcion		 NVARCHAR(255) NOT NULL, /* UNIQUE???. PARA MI NO (NAZA) */
	Precio_Unitario  NUMERIC(18,2) NOT NULL,
	
	UNIQUE		(Descripcion),
	PRIMARY KEY (ID_Item)
)

CREATE TABLE MERCADONEGRO.Facturaciones
(
	ID_Facturacion    NUMERIC(18,0) IDENTITY,
	Cod_Publicacion	  NUMERIC(18,0) NOT NULL,
	ID_Item			  NUMERIC(18,0) NOT NULL,
	Forma_Pago		  NVARCHAR(255) NOT NULL,
	Total_Facturacion NUMERIC(18,2) NOT NULL,
	
	PRIMARY KEY (ID_Facturacion),
	FOREIGN KEY (Cod_Publicacion) REFERENCES MERCADONEGRO.Publicaciones(Cod_Publicacion),
	FOREIGN KEY (ID_Item)		  REFERENCES MERCADONEGRO.Items(ID_Item),
)


CREATE TABLE MERCADONEGRO.Pregunta_Publicacion
(
	Cod_Publicacion NUMERIC(18,0),
	ID_Pregunta		NUMERIC(18,0),
	
	PRIMARY KEY (Cod_Publicacion,ID_Pregunta),
	FOREIGN KEY (Cod_Publicacion) REFERENCES MERCADONEGRO.Publicaciones(Cod_Publicacion),
	FOREIGN KEY (ID_Pregunta)     REFERENCES MERCADONEGRO.Preguntas(ID_Pregunta)
)

CREATE TABLE MERCADONEGRO.Rubro_Publicacion
(
	Cod_Publicacion NUMERIC(18,0),
	ID_Rubro		NUMERIC(18,0),
	
	PRIMARY KEY (Cod_Publicacion, ID_Rubro),
	FOREIGN KEY (Cod_Publicacion) REFERENCES MERCADONEGRO.Publicaciones(Cod_Publicacion),
	FOREIGN KEY (ID_Rubro)		  REFERENCES MERCADONEGRO.Rubros(ID_Rubro)
)

CREATE TABLE MERCADONEGRO.Usuarios
(
	ID_User				 NUMERIC(18,0) IDENTITY(1,1),
	Username			 NVARCHAR(255)	   NOT NULL,
	Password			 NVARCHAR(255)	   NOT NULL,
	Intentos_Login		 TINYINT DEFAULT 0 NOT NULL, 
	Habilitado			 BIT DEFAULT 1	   NOT NULL,
	Primera_Vez			 BIT DEFAULT 1     NOT NULL,
	Cant_Publi_Gratuitas TINYINT		   NULL,
	Reputacion			 FLOAT			   NULL, /*Solo vendedores*/
	Ventas_Sin_Rendir	 TINYINT		   NULL, /*Solo vendedores*/
	
	UNIQUE (Username),
	PRIMARY KEY(ID_User)
)


CREATE TABLE MERCADONEGRO.Empresas
(
	ID_User		    NUMERIC(18,0),
	Razon_Social	NVARCHAR(255) NOT NULL,
	CUIT			NVARCHAR(50)  NOT NULL,
	Telefono		NUMERIC(18,0) NULL, 
	Direccion		NVARCHAR(255) NOT NULL,
	Codigo_Postal	NVARCHAR(50)  NOT NULL,
	Ciudad			NVARCHAR(50)  NULL,
	Mail			NVARCHAR(50)  NOT NULL,
	Nombre_Contacto NVARCHAR(50)  NULL,
	Fecha_Creacion  DATETIME	  NOT NULL,

	UNIQUE		(Razon_Social), /* aca separ� la razon y el cuit porque no pueden repetirse en ningun momento */
	UNIQUE		(CUIT),
	PRIMARY KEY (ID_User),
	FOREIGN KEY (ID_User) REFERENCES MERCADONEGRO.Usuarios(ID_User)
)

CREATE TABLE MERCADONEGRO.Clientes
(
	ID_User			 NUMERIC(18,0),
	Tipo_Doc		 NVARCHAR(50)  NOT NULL,
	Num_Doc			 NUMERIC(18,0) NOT NULL,
	Nombre			 NVARCHAR(255) NOT NULL,
	Apellido		 NVARCHAR(255) NOT NULL,
	Mail			 NVARCHAR(255) NOT NULL,
	Telefono		 NUMERIC(18,0) NULL,
	Direccion		 NVARCHAR(255) NOT NULL,
	Codigo_Postal	 NVARCHAR(50)  NOT NULL,
	Fecha_Nacimiento DATETIME	   NOT NULL,
	--CUIL			 NVARCHAR(50)  NULL,
	
	--UNIQUE (Telefono),
	UNIQUE (Tipo_Doc,Num_Doc),
	
	PRIMARY KEY (ID_User),
	FOREIGN KEY (ID_User) REFERENCES MERCADONEGRO.Usuarios(ID_User)
)

CREATE UNIQUE NONCLUSTERED INDEX idx_telefono_notnull
ON MERCADONEGRO.Clientes(Telefono)
WHERE Telefono IS NOT NULL;

CREATE TABLE MERCADONEGRO.Roles
(
	ID_Rol	   NUMERIC(18,0) IDENTITY(0,1),
	Nombre	   NVARCHAR(255) NOT NULL,
	Habilitado BIT			 NOT NULL
	
	UNIQUE		(Nombre),
	PRIMARY KEY (ID_Rol)
)

CREATE TABLE MERCADONEGRO.Funcionalidad_Rol 
( 
	ID_Funcionalidad NUMERIC(18,0) NOT NULL, 
	ID_Rol			 NUMERIC(18,0) NOT NULL, 
	
	PRIMARY KEY (ID_Funcionalidad, ID_Rol), 
	FOREIGN KEY (ID_Funcionalidad) REFERENCES MERCADONEGRO.Funcionalidades(ID_Funcionalidad), 
	FOREIGN KEY (ID_Rol)		   REFERENCES MERCADONEGRO.Roles(ID_Rol)
) 
	
	
CREATE TABLE MERCADONEGRO.Roles_Usuarios 
( 
	ID_User NUMERIC(18,0) NOT NULL,
	ID_Rol  NUMERIC(18,0) NOT NULL,
	
	PRIMARY KEY (ID_User, ID_Rol), 
	FOREIGN KEY (ID_User) REFERENCES MERCADONEGRO.Usuarios(ID_User), 
	FOREIGN KEY (ID_Rol)  REFERENCES MERCADONEGRO.Roles(ID_Rol) 
	
)

CREATE TABLE MERCADONEGRO.Apto_Calificar
(
	Tipo_Operacion NVARCHAR(255),
	
	PRIMARY KEY (Tipo_Operacion)

)

CREATE TABLE MERCADONEGRO.Operaciones
(
	ID_Operacion		NUMERIC(18,0) IDENTITY,
	ID_Vendedor			NUMERIC(18,0) NOT NULL,
	ID_Comprador		NUMERIC(18,0) NOT NULL,
	Cod_Publicacion		NUMERIC(18,0) NOT NULL,
	Tipo_Operacion		NVARCHAR(255) NOT NULL,
	Fecha_Operacion		DATETIME	  NOT NULL,
	Operacion_Facturada BIT DEFAULT 0 NOT NULL, 
	
	PRIMARY KEY (ID_Operacion),
	FOREIGN KEY (ID_Vendedor)	  REFERENCES MERCADONEGRO.Usuarios(ID_User),
	FOREIGN KEY (ID_Comprador)	  REFERENCES MERCADONEGRO.Usuarios(ID_User),
	FOREIGN KEY (Cod_Publicacion) REFERENCES MERCADONEGRO.Publicaciones(Cod_Publicacion),
	FOREIGN KEY (Tipo_Operacion)  REFERENCES MERCADONEGRO.Apto_Calificar(Tipo_Operacion)
)

-----------------------------------------------Funciones, Stored Procedures y Triggers------------------------------------------------
GO
/* FUNCION AGREGAR FUNCIONALIDAD X ROL*/

CREATE PROCEDURE MERCADONEGRO.AgregarFuncionalidad(@rol nvarchar(255), @func nvarchar(255)) AS
BEGIN
	INSERT INTO MERCADONEGRO.Funcionalidad_Rol (ID_Rol, ID_Funcionalidad)
		VALUES ((SELECT ID_Rol FROM MERCADONEGRO.Roles WHERE Nombre = @rol),
		        (SELECT ID_Funcionalidad FROM MERCADONEGRO.Funcionalidades WHERE Nombre = @func))
END
GO

CREATE PROCEDURE MERCADONEGRO.AgregarRol(@iduser numeric(18,0), @idrol numeric(18,0)) AS
BEGIN
	INSERT INTO MERCADONEGRO.Roles_Usuarios (ID_User,ID_Rol)
		VALUES ((SELECT ID_User FROM MERCADONEGRO.Usuarios WHERE ID_User = @iduser),
				(SELECT ID_Rol FROM MERCADONEGRO.Roles WHERE ID_Rol = @idrol))
END 
GO
/*
CREATE PROCEDURE MERCADONEGRO.InsertarCliente(@tipoDoc nvarchar(50),
											  @numDoc numeric(18,0), @nombre nvarchar(255),
											  @apellido nvarchar(255), @mail nvarchar(255),
											  @direccion nvarchar(255), @codPostal nvarchar(50),
											  @fechaNacimiento datetime)
BEGIN
	INSERT INTO MERCADONEGRO.Cliente(ID_User, Tipo_Doc, Num_Doc, Nombre, Apellido, Mail, Direccion,
									 Codigo_Postal, Fecha_Nacimiento) 
			VALUES((SELECT ID_User FROM MERCADONEGRO.usuarios WHERE Num_Doc = @numDoc),
					(SELECT */
					
----------------------------------------------------Datos Iniciales-----------------------------------------------

PRINT 'Creando valores por defecto...'

-- ///// Agregar las que sean necesarias /////
/* FUNCIONALIDADES */
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('AdministrarClientes');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('AdministrarEmpresas');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('AdministrarRoles');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('AdministrarRubros');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('AdministrarVisibilidades');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('GenerarPublicacion');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('EditarPublicacion');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('GestionarPreguntas');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('ComprarOfertar');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('Calificar');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('HistorialOperaciones');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('Facturar');
INSERT INTO MERCADONEGRO.Funcionalidades (Nombre) VALUES ('ListadoEstadistico');

/* ROLES */
INSERT INTO MERCADONEGRO.Roles (Nombre, Habilitado) VALUES ('Administrador General', 1);
INSERT INTO MERCADONEGRO.Roles (Nombre, Habilitado) VALUES ('Cliente', 1);
INSERT INTO MERCADONEGRO.Roles (Nombre, Habilitado) VALUES ('Empresa', 1);


PRINT 'Agregando func ADMIN'
-------------------/* Asignacion de Funcionalidades */-------------------
/* ADMIN */ 
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'AdministrarRoles';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'AdministrarClientes';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'AdministrarEmpresas';	
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'AdministrarRubros';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'AdministrarVisibilidades';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'GenerarPublicacion';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'EditarPublicacion';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'GestionarPreguntas';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'ComprarOfertar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'Calificar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'HistorialOperaciones';	
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'Facturar';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Administrador General', @func = 'ListadoEstadistico';				
		
/* Cliente */
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'GenerarPublicacion';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'EditarPublicacion';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'ComprarOfertar';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'Calificar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'HistorialOperaciones';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'Facturar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Cliente', @func = 'ListadoEstadistico';
		
/* Empresas */
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'GenerarPublicacion';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'EditarPublicacion';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'ComprarOfertar';		
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'Calificar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'HistorialOperaciones';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'Facturar';
EXEC MERCADONEGRO.AgregarFuncionalidad
	@rol = 'Empresa', @func = 'ListadoEstadistico';
		

----------------- /*AGREGANDO USUARIOS INICIALES*/ ------------------------
SET IDENTITY_INSERT MERCADONEGRO.Usuarios ON
INSERT INTO MERCADONEGRO.Usuarios(ID_User,Username,Password,Intentos_Login,Habilitado,Primera_Vez,Cant_Publi_Gratuitas,Reputacion,Ventas_Sin_Rendir) 
	VALUES (0,'admin','w23e',0,1,0,0,0,0);--TODO ver si ultimas tres columnas podrian ir NULL
SET IDENTITY_INSERT MERCADONEGRO.Usuarios OFF

EXEC MERCADONEGRO.AgregarRol
	@iduser = 0, @idrol = 0;
			


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
GO
/* MIGRANDO TABLA PUBLICACIONES */

PRINT 'MIGRANDO TABLA PUBLICACIONES'
GO
--------------------VISTA DE CLIENTES Y EMPRESAS---------------

CREATE VIEW MERCADONEGRO.Vista_Publicaciones AS SELECT DISTINCT
		MERCADONEGRO.Usuarios.ID_User AS ID_User, 
		Publicacion_Cod, 
		Publicacion_Visibilidad_Cod - 10002 AS Cod_Visibilidad,
		Publicacion_Descripcion,
		Publicacion_Stock,
		Publicacion_Fecha,
		Publicacion_Fecha_Venc,
		Publicacion_Precio, 
		CASE Publicacion_Estado
			WHEN 'Publicada' 
			THEN 0
		END AS Estado_Publicacion, 
			CASE Publicacion_Tipo
				WHEN 'Compra Inmediata' 
				THEN 1 
				WHEN 'Subasta' 
				THEN 0
		END AS Tipo_Publicacion, 
		1 AS Permisos_Preguntas--Permiso de preguntas (cambiar esto si es necesario)
					
	FROM	gd_esquema.Maestra, MERCADONEGRO.Usuarios
	WHERE	Publ_Cli_Dni IS NOT NULL AND MERCADONEGRO.Usuarios.Password = CONVERT(NVARCHAR(255), gd_esquema.Maestra.Publ_Cli_Dni)
	
	UNION
	
	SELECT DISTINCT
		MERCADONEGRO.Usuarios.ID_User AS ID_User, 
		Publicacion_Cod, 
		Publicacion_Visibilidad_Cod - 10002 AS Cod_Visibilidad,
		Publicacion_Descripcion,
		Publicacion_Stock,
		Publicacion_Fecha,
		Publicacion_Fecha_Venc,
		Publicacion_Precio, 
		CASE Publicacion_Estado
			WHEN 'Publicada' 
			THEN 0
		END AS Estado_Publicacion, 
			CASE Publicacion_Tipo
				WHEN 'Compra Inmediata' 
				THEN 1 
				WHEN 'Subasta' 
				THEN 0
		END AS Tipo_Publicacion, 
		1 AS Permisos_Preguntas--Permiso de preguntas (cambiar esto si es necesario)
					
	FROM	gd_esquema.Maestra, MERCADONEGRO.Usuarios
	WHERE	Publ_Empresa_Cuit IS NOT NULL AND MERCADONEGRO.Usuarios.Password = gd_esquema.Maestra.Publ_Empresa_Cuit
	
GO	


--------------------INSERTANDO EN PUBLICACIONES---------------

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
										
	SELECT Publicacion_Cod, Cod_Visibilidad, ID_User, Publicacion_Descripcion, Publicacion_Stock, Publicacion_Fecha, Publicacion_Fecha_Venc,
			 Publicacion_Precio, Estado_Publicacion, Tipo_Publicacion, Permisos_Preguntas,Publicacion_Stock
									
	FROM	MERCADONEGRO.Vista_Publicaciones

	
SET IDENTITY_INSERT MERCADONEGRO.Publicaciones OFF



-----------------------------DROPS-----------------------------
DROP TABLE #UsuariosTemp

DROP VIEW MERCADONEGRO.Vista_Publicaciones
