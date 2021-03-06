USE [master]
GO
/****** Object:  Database [ProyectoFinalTJ]    Script Date: 24/08/2017 13:55:15 ******/
CREATE DATABASE [ProyectoFinalTJ]
GO
ALTER DATABASE [ProyectoFinalTJ] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ProyectoFinalTJ].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ProyectoFinalTJ] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ProyectoFinalTJ] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProyectoFinalTJ] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProyectoFinalTJ] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ProyectoFinalTJ] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProyectoFinalTJ] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ProyectoFinalTJ] SET  MULTI_USER 
GO
ALTER DATABASE [ProyectoFinalTJ] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProyectoFinalTJ] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ProyectoFinalTJ] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ProyectoFinalTJ] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ProyectoFinalTJ] SET DELAYED_DURABILITY = DISABLED 
GO
USE [ProyectoFinalTJ]
GO
/****** Object:  UserDefinedFunction [dbo].[CantidadInventario]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CantidadInventario] (@id int)  
RETURNS int  
WITH EXECUTE AS CALLER  
AS  
BEGIN   
	declare @s int;
	set @s = (select p.existenciaTotal from productos as p where id=@id);  
     RETURN @s
END;  

GO
/****** Object:  UserDefinedFunction [dbo].[fnCleanDefaultValue]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCleanDefaultValue](@sDefaultValue varchar(4000))
RETURNS varchar(4000)
AS
BEGIN
	RETURN SubString(@sDefaultValue, 2, DataLength(@sDefaultValue)-2)
END




GO
/****** Object:  UserDefinedFunction [dbo].[fnColumnDefault]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnColumnDefault](@sTableName varchar(128), @sColumnName varchar(128))
RETURNS varchar(4000)
AS
BEGIN
	DECLARE @sDefaultValue varchar(4000)

	SELECT	@sDefaultValue = dbo.fnCleanDefaultValue(COLUMN_DEFAULT)
	FROM	INFORMATION_SCHEMA.COLUMNS
	WHERE	TABLE_NAME = @sTableName
	 AND 	COLUMN_NAME = @sColumnName

	RETURN 	@sDefaultValue

END


GO
/****** Object:  UserDefinedFunction [dbo].[fnIsColumnPrimaryKey]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE   FUNCTION [dbo].[fnIsColumnPrimaryKey](@sTableName varchar(128), @nColumnName varchar(128))
RETURNS bit
AS
BEGIN
	DECLARE @nTableID int,
		@nIndexID int,
		@i int
	
	SET 	@nTableID = OBJECT_ID(@sTableName)
	
	SELECT 	@nIndexID = indid
	FROM 	sysindexes
	WHERE 	id = @nTableID
	 AND 	indid BETWEEN 1 And 254 
	 AND 	(status & 2048) = 2048
	
	IF @nIndexID Is Null
		RETURN 0
	
	IF @nColumnName IN
		(SELECT sc.[name]
		FROM 	sysindexkeys sik
			INNER JOIN syscolumns sc ON sik.id = sc.id AND sik.colid = sc.colid
		WHERE 	sik.id = @nTableID
		 AND 	sik.indid = @nIndexID)
	 BEGIN
		RETURN 1
	 END


	RETURN 0
END








GO
/****** Object:  UserDefinedFunction [dbo].[fnTableHasPrimaryKey]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnTableHasPrimaryKey](@sTableName varchar(128))
RETURNS bit
AS
BEGIN
	DECLARE @nTableID int,
		@nIndexID int
	
	SET 	@nTableID = OBJECT_ID(@sTableName)
	
	SELECT 	@nIndexID = indid
	FROM 	sysindexes
	WHERE 	id = @nTableID
	 AND 	indid BETWEEN 1 And 254 
	 AND 	(status & 2048) = 2048
	
	IF @nIndexID IS NOT Null
		RETURN 1
	
	RETURN 0
END



GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 24/08/2017 13:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Clientes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombrePersona] [varchar](max) NULL,
	[apellidoPersona] [varchar](max) NULL,
	[nit] [varchar](max) NULL,
	[dpi] [varchar](max) NULL,
	[edad] [int] NULL,
	[numeroTelefono] [varchar](max) NULL,
	[email] [varchar](max) NULL,
	[sexo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataBodega]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataBodega](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombreBodega] [varchar](max) NULL,
	[direccionBodega] [varchar](max) NULL,
	[adminBodega] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleFactura]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleFactura](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigoFactura] [int] NULL,
	[codigoInventario] [int] NULL,
	[precio] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DetalleInOut]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleInOut](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[coidgoInOut] [int] NULL,
	[codigoProducto] [int] NULL,
	[cantidad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DetalleInOutP]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleInOutP](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[coidgoInOut] [int] NULL,
	[codigoProducto] [int] NULL,
	[cantidadP] [int] NULL,
	[inoutType] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeBodega]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeBodega](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idUsuario] [int] NULL,
	[idBodega] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[estadoFacturas]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[estadoFacturas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstado] [varchar](max) NULL,
	[descripcionEstado] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[estadoProductos]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[estadoProductos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombreEstado] [varchar](max) NULL,
	[descripcionEstado] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Factura]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Factura](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[numeroSerie] [varchar](max) NULL,
	[numeroFactura] [varchar](max) NULL,
	[nitFactura] [varchar](max) NULL,
	[nombreFactura] [varchar](max) NULL,
	[direccionFacutra] [varchar](max) NULL,
	[fechaFactura] [smalldatetime] NULL,
	[estadoFactura] [int] NULL,
	[totalFactura] [money] NULL,
	[cliente] [int] NULL,
	[vendedor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InOut]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InOut](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](max) NULL,
	[fechaInOut] [smalldatetime] NULL,
	[tipoInOut] [int] NULL,
	[cantidadInOut] [int] NULL,
	[ubicacionInOut] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Inventario]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigoProducto] [int] NULL,
	[estadoProducto] [int] NULL,
	[ubicacionProducto] [int] NULL,
	[precioVenta] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Productos]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Productos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombreProducto] [varchar](max) NULL,
	[descripcionProducto] [varchar](max) NULL,
	[costoProducto] [money] NULL,
	[existenciaTotal] [int] NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tipoInOut]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipoInOut](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombretipoInOut] [varchar](max) NULL,
	[descripciontipoInOut] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuarios](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombrePersona] [varchar](max) NULL,
	[apellidoPersona] [varchar](max) NULL,
	[nombreUsuario] [varchar](max) NULL,
	[contraUsuario] [varchar](max) NULL,
	[edad] [int] NULL,
	[numeroTelefono] [varchar](max) NULL,
	[email] [varchar](max) NULL,
	[rol] [nvarchar](128) NULL,
	[superior] [int] NULL,
	[sexo] [bit] NULL,
	[idAspNetUsers] [nvarchar](128) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fnTableColumnInfo]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       FUNCTION [dbo].[fnTableColumnInfo](@sTableName varchar(128))
RETURNS TABLE
AS
	RETURN
	SELECT	c.name AS sColumnName,
		c.colid AS nColumnID,
		dbo.fnIsColumnPrimaryKey(@sTableName, c.name) AS bPrimaryKeyColumn,
		CASE 	WHEN t.name IN ('char', 'varchar', 'binary', 'varbinary', 'nchar', 'nvarchar') THEN 1
			WHEN t.name IN ('decimal', 'numeric') THEN 2
			ELSE 0
		END AS nAlternateType,
		c.length AS nColumnLength,
		c.prec AS nColumnPrecision,
		c.scale AS nColumnScale, 
		c.IsNullable, 
		SIGN(c.status & 128) AS IsIdentity,
		t.name as sTypeName,
		dbo.fnColumnDefault(@sTableName, c.name) AS sDefaultValue
	FROM	syscolumns c 
		INNER JOIN systypes t ON c.xtype = t.xtype and c.usertype = t.usertype
	WHERE	c.id = OBJECT_ID(@sTableName)


GO
/****** Object:  UserDefinedFunction [dbo].[GetEmpList]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetEmpList](@superior int)
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT a.* from Usuarios as a inner join AspNetUsers as au
on a.idAspNetUsers=au.Id where a.superior=@superior
); 
GO
/****** Object:  UserDefinedFunction [dbo].[GetIdRol]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetIdRol](@Rol nvarchar(128))
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT Id from AspNetRoles where Name=@Rol
); 
GO
/****** Object:  UserDefinedFunction [dbo].[GetIdUser]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetIdUser](@Userid nvarchar(128))
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT a.id from Usuarios as a inner join AspNetUsers as o
	on a.idAspNetUsers=o.Id where o.Id=@Userid
); 
GO
/****** Object:  UserDefinedFunction [dbo].[GetRol]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetRol](@Userid nvarchar(128))
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT o.Name from Usuarios as a left join AspNetRoles as o
	on a.rol=o.Id where a.idAspNetUsers=@Userid
); 
GO
/****** Object:  UserDefinedFunction [dbo].[ManagerBodegaUser]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ManagerBodegaUser]()
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT a.id,a.nombrePersona from Usuarios as a left join DataBodega as d on a.id=d.adminBodega inner join AspNetRoles as o
	on a.rol=o.Id where d.adminBodega is null and o.Name='Manager Bodega'
); 
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [RoleNameIndex]    Script Date: 24/08/2017 13:55:17 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 24/08/2017 13:55:17 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 24/08/2017 13:55:17 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RoleId]    Script Date: 24/08/2017 13:55:17 ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 24/08/2017 13:55:17 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 24/08/2017 13:55:17 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[DataBodega]  WITH CHECK ADD  CONSTRAINT [fk_usuario] FOREIGN KEY([adminBodega])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[DataBodega] CHECK CONSTRAINT [fk_usuario]
GO
ALTER TABLE [dbo].[DetalleFactura]  WITH CHECK ADD  CONSTRAINT [fk_codigoFactura] FOREIGN KEY([codigoFactura])
REFERENCES [dbo].[Factura] ([id])
GO
ALTER TABLE [dbo].[DetalleFactura] CHECK CONSTRAINT [fk_codigoFactura]
GO
ALTER TABLE [dbo].[DetalleFactura]  WITH CHECK ADD  CONSTRAINT [fk_codigoInventarioDetalleFactura] FOREIGN KEY([codigoInventario])
REFERENCES [dbo].[Inventario] ([id])
GO
ALTER TABLE [dbo].[DetalleFactura] CHECK CONSTRAINT [fk_codigoInventarioDetalleFactura]
GO
ALTER TABLE [dbo].[DetalleInOut]  WITH CHECK ADD  CONSTRAINT [fk_codigoProductoInOut] FOREIGN KEY([codigoProducto])
REFERENCES [dbo].[Inventario] ([id])
GO
ALTER TABLE [dbo].[DetalleInOut] CHECK CONSTRAINT [fk_codigoProductoInOut]
GO
ALTER TABLE [dbo].[DetalleInOut]  WITH CHECK ADD  CONSTRAINT [fk_coidgoInOut] FOREIGN KEY([coidgoInOut])
REFERENCES [dbo].[DetalleInOutP] ([id])
GO
ALTER TABLE [dbo].[DetalleInOut] CHECK CONSTRAINT [fk_coidgoInOut]
GO
ALTER TABLE [dbo].[DetalleInOutP]  WITH CHECK ADD  CONSTRAINT [fk_codigoProductoInOutP] FOREIGN KEY([codigoProducto])
REFERENCES [dbo].[Productos] ([id])
GO
ALTER TABLE [dbo].[DetalleInOutP] CHECK CONSTRAINT [fk_codigoProductoInOutP]
GO
ALTER TABLE [dbo].[DetalleInOutP]  WITH CHECK ADD  CONSTRAINT [fk_coidgoInOutP] FOREIGN KEY([coidgoInOut])
REFERENCES [dbo].[InOut] ([id])
GO
ALTER TABLE [dbo].[DetalleInOutP] CHECK CONSTRAINT [fk_coidgoInOutP]
GO
ALTER TABLE [dbo].[EmployeeBodega]  WITH CHECK ADD  CONSTRAINT [fk_idb] FOREIGN KEY([idBodega])
REFERENCES [dbo].[DataBodega] ([id])
GO
ALTER TABLE [dbo].[EmployeeBodega] CHECK CONSTRAINT [fk_idb]
GO
ALTER TABLE [dbo].[EmployeeBodega]  WITH CHECK ADD  CONSTRAINT [fk_idu] FOREIGN KEY([idUsuario])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[EmployeeBodega] CHECK CONSTRAINT [fk_idu]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [fk_cliente] FOREIGN KEY([cliente])
REFERENCES [dbo].[Clientes] ([id])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [fk_cliente]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [fk_estadoFactura] FOREIGN KEY([estadoFactura])
REFERENCES [dbo].[estadoFacturas] ([id])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [fk_estadoFactura]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [fk_vendedor] FOREIGN KEY([vendedor])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [fk_vendedor]
GO
ALTER TABLE [dbo].[InOut]  WITH CHECK ADD  CONSTRAINT [fk_tipoInOut] FOREIGN KEY([tipoInOut])
REFERENCES [dbo].[tipoInOut] ([id])
GO
ALTER TABLE [dbo].[InOut] CHECK CONSTRAINT [fk_tipoInOut]
GO
ALTER TABLE [dbo].[InOut]  WITH CHECK ADD  CONSTRAINT [fk_ubicacionProductoInOut] FOREIGN KEY([ubicacionInOut])
REFERENCES [dbo].[DataBodega] ([id])
GO
ALTER TABLE [dbo].[InOut] CHECK CONSTRAINT [fk_ubicacionProductoInOut]
GO
ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD  CONSTRAINT [fk_codigoProducto] FOREIGN KEY([codigoProducto])
REFERENCES [dbo].[Productos] ([id])
GO
ALTER TABLE [dbo].[Inventario] CHECK CONSTRAINT [fk_codigoProducto]
GO
ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD  CONSTRAINT [fk_estadoProducto] FOREIGN KEY([estadoProducto])
REFERENCES [dbo].[estadoProductos] ([id])
GO
ALTER TABLE [dbo].[Inventario] CHECK CONSTRAINT [fk_estadoProducto]
GO
ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD  CONSTRAINT [fk_ubicacionProducto] FOREIGN KEY([ubicacionProducto])
REFERENCES [dbo].[DataBodega] ([id])
GO
ALTER TABLE [dbo].[Inventario] CHECK CONSTRAINT [fk_ubicacionProducto]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [fk_superior] FOREIGN KEY([superior])
REFERENCES [dbo].[Usuarios] ([id])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [fk_superior]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_AspNetRoles] FOREIGN KEY([rol])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_AspNetRoles]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_AspNetUsers] FOREIGN KEY([idAspNetUsers])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_AspNetUsers]
GO
/****** Object:  StoredProcedure [dbo].[addRoleUser]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[addRoleUser](@Userid nvarchar(128),@Roleid nvarchar(128))
as
insert into AspNetUserRoles values (@Userid,@Roleid)
GO
/****** Object:  StoredProcedure [dbo].[Delete_Cliente]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Delete_Cliente]
	@nit varchar(15)
AS

DELETE	Cliente
WHERE 	nit = @nit


GO
/****** Object:  StoredProcedure [dbo].[Insert_Cliente]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Insert_Cliente]
	@nit varchar(15),
	@nombre varchar(200) = NULL,
	@direccion varchar(300) = NULL
AS

INSERT Cliente(nit, nombre, direccion)
VALUES (@nit, @nombre, @direccion)


GO
/****** Object:  StoredProcedure [dbo].[InsertarBodega]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec InsertarUsuarios 'Carlos','Cordon','charliecech','1234',20,'42210365','carlos.edu.cordon@gmail.com',1,NULL,1
create proc [dbo].[InsertarBodega] (@nombre varchar(max),@dir varchar(max),@admin int) as
insert into DataBodega (nombreBodega,direccionBodega,adminBodega) values (@nombre,@dir,@admin)

GO
/****** Object:  StoredProcedure [dbo].[InsertarClientes]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarClientes] (@nombre varchar(max),@apellido varchar(max),@nit varchar(max),@dpi varchar(max),@edad int,@numeroTelefono varchar(max),@email varchar(max),@sexo bit)
as
insert into Clientes (nombrePersona,apellidoPersona,nit,dpi,edad,numeroTelefono,email,sexo) values(@nombre,@apellido,@nit,@dpi,@edad,@numeroTelefono,@email,@sexo);

GO
/****** Object:  StoredProcedure [dbo].[InsertarDetalleFactura]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarDetalleFactura](@codigoFactura int,@codigoInventario int,@precio money) as
insert into DetalleFactura (codigoFactura,codigoInventario,precio) values (@codigoFactura,@codigoInventario,@precio)

GO
/****** Object:  StoredProcedure [dbo].[InsertarDetalleInOut]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarDetalleInOut](@coidgoInOut int,@codigoProducto int,@cantidad int) as
insert into DetalleInOut (coidgoInOut,codigoProducto,cantidad) values (@coidgoInOut,@codigoProducto,@cantidad)

GO
/****** Object:  StoredProcedure [dbo].[InsertarDetalleInOutP]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarDetalleInOutP](@coidgoInOut int,@codigoProducto int,@cantidad int) as
insert into DetalleInOutP (coidgoInOut,codigoProducto,cantidadP) values (@coidgoInOut,@codigoProducto,@cantidad)

GO
/****** Object:  StoredProcedure [dbo].[InsertarestadoFacturas]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarestadoFacturas](@nombreEstado varchar(max),@descripcionEstado varchar(max)) as
insert into estadoFacturas (nombreEstado,descripcionEstado) values (@nombreEstado,@descripcionEstado)

GO
/****** Object:  StoredProcedure [dbo].[InsertarFactura]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarFactura] (@numeroSerie varchar(max),@numeroFactura varchar(max),@nitFactura varchar(max),@nombreFactura varchar(max),@direccionFacutra varchar(max),@fechaFactura date,@estadoFactura int,@totalFactura money,@cliente int,@vendedor int) as 
insert into  Factura (numeroSerie,numeroFactura,nitFactura,nombreFactura,direccionFacutra,fechaFactura,estadoFactura,totalFactura,cliente,vendedor) 
values (@numeroSerie,@numeroFactura,@nitFactura,@nombreFactura,@direccionFacutra,@fechaFactura,@estadoFactura,@totalFactura,@cliente,@vendedor)

GO
/****** Object:  StoredProcedure [dbo].[InsertarInOut]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--create proc InsertarDetalleInventario(@codigoDetalleFactura int,@codigoInventario int) as
--insert into DetalleInventario (codigoDetalleFactura,codigoInventario) values (@codigoDetalleFactura,@codigoInventario) 
--go
create proc [dbo].[InsertarInOut](@descripcion varchar(max),@fechaInOut date,@tipoInOut int,@cantidadInOut int,@ubicacionInOut int) as
insert into InOut (descripcion,fechaInOut,tipoInOut,cantidadInOut,ubicacionInOut) 
values (@descripcion,@fechaInOut,@tipoInOut,@cantidadInOut,@ubicacionInOut)

GO
/****** Object:  StoredProcedure [dbo].[InsertarInventario]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarInventario](@codigoProducto int,@estadoProducto int,@ubicacionProducto int,@precioVenta money) as
insert into Inventario (codigoProducto,estadoProducto,ubicacionProducto,precioVenta) values (@codigoProducto,@estadoProducto,@ubicacionProducto,@precioVenta)

GO
/****** Object:  StoredProcedure [dbo].[InsertarProductos]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarProductos] (@nombreProducto varchar(max),@descripcionProducto varchar(max),@costoProducto money,@existenciaTotal int)
as
insert into Productos (nombreProducto,descripcionProducto,costoProducto,existenciaTotal) values (@nombreProducto,@descripcionProducto,@costoProducto,@existenciaTotal)

GO
/****** Object:  StoredProcedure [dbo].[InsertarRoles]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertarRoles] (@nombreRol varchar(max),@descripcion varchar(max))
as
insert into rolSistema (nombreRol,direccionRol) values (@nombreRol,@descripcion);

GO
/****** Object:  StoredProcedure [dbo].[InsertarUsuarios]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec InsertarRoles 'Administrador','Administrador del sistema'
create proc [dbo].[InsertarUsuarios] (@nombre varchar(max),@apellido varchar(max),@user varchar(max),@pass varchar(max),@edad int,@numeroTelefono varchar(max),@email varchar(max),@rol int,@superior int,@sexo bit)
as
insert into Usuarios (nombrePersona,apellidoPersona,nombreUsuario,contraUsuario,edad,numeroTelefono,email,rol,superior,sexo) 
values (@nombre,@apellido,@user,@pass,@edad,@numeroTelefono,@email,@rol,@superior,@sexo)

GO
/****** Object:  StoredProcedure [dbo].[inveVendido]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[inveVendido](@id int)
as 
begin
update Inventario set estadoProducto=4 where id=@id
end
GO
/****** Object:  StoredProcedure [dbo].[pr__SYS_MakeDeleteRecordProc]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE      PROC [dbo].[pr__SYS_MakeDeleteRecordProc]
	@sTableName varchar(128),
	@bExecute bit = 0
AS

IF dbo.fnTableHasPrimaryKey(@sTableName) = 0
 BEGIN
	RAISERROR ('Procedure cannot be created on a table with no primary key.', 10, 1)
	RETURN
 END

DECLARE	@sProcText varchar(8000),
	@sKeyFields varchar(2000),
	@sWhereClause varchar(2000),
	@sColumnName varchar(128),
	@nColumnID smallint,
	@bPrimaryKeyColumn bit,
	@nAlternateType int,
	@nColumnLength int,
	@nColumnPrecision int,
	@nColumnScale int,
	@IsNullable bit, 
	@IsIdentity int,
	@sTypeName varchar(128),
	@sDefaultValue varchar(4000),
	@sCRLF char(2),
	@sTAB char(1)

SET	@sTAB = char(9)
SET 	@sCRLF = char(13) + char(10)

SET 	@sProcText = ''
SET 	@sKeyFields = ''
SET	@sWhereClause = ''

SET 	@sProcText = @sProcText + 'IF EXISTS(SELECT * FROM sysobjects WHERE name = ''prApp_' + @sTableName + '_Delete'')' + @sCRLF
SET 	@sProcText = @sProcText + @sTAB + 'DROP PROC prApp_' + @sTableName + '_Delete' + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF

SET 	@sProcText = @sProcText + @sCRLF

PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)

SET 	@sProcText = ''
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + '-- Delete a single record from ' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + 'CREATE PROC prApp_' + @sTableName + '_Delete' + @sCRLF

DECLARE crKeyFields cursor for
	SELECT	*
	FROM	dbo.fnTableColumnInfo(@sTableName)
	ORDER BY 2

OPEN crKeyFields

FETCH 	NEXT 
FROM 	crKeyFields 
INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
	@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
	@IsIdentity, @sTypeName, @sDefaultValue
				
WHILE (@@FETCH_STATUS = 0)
 BEGIN

	IF (@bPrimaryKeyColumn = 1)
	 BEGIN
		IF (@sKeyFields <> '')
			SET @sKeyFields = @sKeyFields + ',' + @sCRLF 
	
		SET @sKeyFields = @sKeyFields + @sTAB + '@' + @sColumnName + ' ' + @sTypeName

		IF (@nAlternateType = 2) --decimal, numeric
			SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnPrecision AS varchar(3)) + ', ' 
					+ CAST(@nColumnScale AS varchar(3)) + ')'
	
		ELSE IF (@nAlternateType = 1) --character and binary
			SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnLength AS varchar(4)) +  ')'
	
		IF (@sWhereClause = '')
			SET @sWhereClause = @sWhereClause + 'WHERE ' 
		ELSE
			SET @sWhereClause = @sWhereClause + ' AND ' 

		SET @sWhereClause = @sWhereClause + @sTAB + @sColumnName  + ' = @' + @sColumnName + @sCRLF 
	 END

	FETCH 	NEXT 
	FROM 	crKeyFields 
	INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
		@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
		@IsIdentity, @sTypeName, @sDefaultValue
 END

CLOSE crKeyFields
DEALLOCATE crKeyFields

SET 	@sProcText = @sProcText + @sKeyFields + @sCRLF
SET 	@sProcText = @sProcText + 'AS' + @sCRLF
SET 	@sProcText = @sProcText + @sCRLF
SET 	@sProcText = @sProcText + 'DELETE	' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + @sWhereClause
SET 	@sProcText = @sProcText + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF


PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)










GO
/****** Object:  StoredProcedure [dbo].[pr__SYS_MakeInsertRecordProc]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       PROC [dbo].[pr__SYS_MakeInsertRecordProc]
	@sTableName varchar(128),
	@bExecute bit = 0
AS

IF dbo.fnTableHasPrimaryKey(@sTableName) = 0
 BEGIN
	RAISERROR ('Procedure cannot be created on a table with no primary key.', 10, 1)
	RETURN
 END

DECLARE	@sProcText varchar(8000),
	@sKeyFields varchar(2000),
	@sAllFields varchar(2000),
	@sAllParams varchar(2000),
	@sWhereClause varchar(2000),
	@sColumnName varchar(128),
	@nColumnID smallint,
	@bPrimaryKeyColumn bit,
	@nAlternateType int,
	@nColumnLength int,
	@nColumnPrecision int,
	@nColumnScale int,
	@IsNullable bit, 
	@IsIdentity int,
	@HasIdentity int,
	@sTypeName varchar(128),
	@sDefaultValue varchar(4000),
	@sCRLF char(2),
	@sTAB char(1)

SET 	@HasIdentity = 0
SET	@sTAB = char(9)
SET 	@sCRLF = char(13) + char(10)
SET 	@sProcText = ''
SET 	@sKeyFields = ''
SET	@sAllFields = ''
SET	@sWhereClause = ''
SET	@sAllParams  = ''

SET 	@sProcText = @sProcText + 'IF EXISTS(SELECT * FROM sysobjects WHERE name = ''prApp_' + @sTableName + '_Insert'')' + @sCRLF
SET 	@sProcText = @sProcText + @sTAB + 'DROP PROC prApp_' + @sTableName + '_Insert' + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF

SET 	@sProcText = @sProcText + @sCRLF

PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)

SET 	@sProcText = ''
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + '-- Insert a single record into ' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + 'CREATE PROC prApp_' + @sTableName + '_Insert' + @sCRLF

DECLARE crKeyFields cursor for
	SELECT	*
	FROM	dbo.fnTableColumnInfo(@sTableName)
	ORDER BY 2

OPEN crKeyFields


FETCH 	NEXT 
FROM 	crKeyFields 
INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
	@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
	@IsIdentity, @sTypeName, @sDefaultValue
				
WHILE (@@FETCH_STATUS = 0)
 BEGIN
	IF (@IsIdentity = 0)
	 BEGIN
		IF (@sKeyFields <> '')
			SET @sKeyFields = @sKeyFields + ',' + @sCRLF 

		SET @sKeyFields = @sKeyFields + @sTAB + '@' + @sColumnName + ' ' + @sTypeName

		IF (@sAllFields <> '')
		 BEGIN
			SET @sAllParams = @sAllParams + ', '
			SET @sAllFields = @sAllFields + ', '
		 END

		IF (@sTypeName = 'timestamp')
			SET @sAllParams = @sAllParams + 'NULL'
		ELSE IF (@sDefaultValue IS NOT NULL)
			SET @sAllParams = @sAllParams + 'COALESCE(@' + @sColumnName + ', ' + @sDefaultValue + ')'
		ELSE
			SET @sAllParams = @sAllParams + '@' + @sColumnName 

		SET @sAllFields = @sAllFields + @sColumnName 

	 END
	ELSE
	 BEGIN
		SET @HasIdentity = 1
	 END

	IF (@nAlternateType = 2) --decimal, numeric
		SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnPrecision AS varchar(3)) + ', ' 
				+ CAST(@nColumnScale AS varchar(3)) + ')'

	ELSE IF (@nAlternateType = 1) --character and binary
		SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnLength AS varchar(4)) +  ')'

	IF (@IsIdentity = 0)
	 BEGIN
		IF (@sDefaultValue IS NOT NULL) OR (@IsNullable = 1) OR (@sTypeName = 'timestamp')
			SET @sKeyFields = @sKeyFields + ' = NULL'
	 END

	FETCH 	NEXT 
	FROM 	crKeyFields 
	INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
		@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
		@IsIdentity, @sTypeName, @sDefaultValue
 END

CLOSE crKeyFields
DEALLOCATE crKeyFields

SET 	@sProcText = @sProcText + @sKeyFields + @sCRLF
SET 	@sProcText = @sProcText + 'AS' + @sCRLF
SET 	@sProcText = @sProcText + @sCRLF
SET 	@sProcText = @sProcText + 'INSERT ' + @sTableName + '(' + @sAllFields + ')' + @sCRLF
SET 	@sProcText = @sProcText + 'VALUES (' + @sAllParams + ')' + @sCRLF
SET 	@sProcText = @sProcText + @sCRLF

IF (@HasIdentity = 1)
 BEGIN
	SET 	@sProcText = @sProcText + 'RETURN SCOPE_IDENTITY()' + @sCRLF
	SET 	@sProcText = @sProcText + @sCRLF
 END

IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF


PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)








GO
/****** Object:  StoredProcedure [dbo].[pr__SYS_MakeSelectRecordProc]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE     PROC [dbo].[pr__SYS_MakeSelectRecordProc]
	@sTableName varchar(128),
	@bExecute bit = 0
AS

IF dbo.fnTableHasPrimaryKey(@sTableName) = 0
 BEGIN
	RAISERROR ('Procedure cannot be created on a table with no primary key.', 10, 1)
	RETURN
 END

DECLARE	@sProcText varchar(8000),
	@sKeyFields varchar(2000),
	@sSelectClause varchar(2000),
	@sWhereClause varchar(2000),
	@sColumnName varchar(128),
	@nColumnID smallint,
	@bPrimaryKeyColumn bit,
	@nAlternateType int,
	@nColumnLength int,
	@nColumnPrecision int,
	@nColumnScale int,
	@IsNullable bit, 
	@IsIdentity int,
	@sTypeName varchar(128),
	@sDefaultValue varchar(4000),
	@sCRLF char(2),
	@sTAB char(1)

SET	@sTAB = char(9)
SET 	@sCRLF = char(13) + char(10)

SET 	@sProcText = ''
SET 	@sKeyFields = ''
SET	@sSelectClause = ''
SET	@sWhereClause = ''

SET 	@sProcText = @sProcText + 'IF EXISTS(SELECT * FROM sysobjects WHERE name = ''prApp_' + @sTableName + '_Select'')' + @sCRLF
SET 	@sProcText = @sProcText + @sTAB + 'DROP PROC prApp_' + @sTableName + '_Select' + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF

SET 	@sProcText = @sProcText + @sCRLF

PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)

SET 	@sProcText = ''
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + '-- Select a single record from ' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + 'CREATE PROC prApp_' + @sTableName + '_Select' + @sCRLF

DECLARE crKeyFields cursor for
	SELECT	*
	FROM	dbo.fnTableColumnInfo(@sTableName)
	ORDER BY 2

OPEN crKeyFields

FETCH 	NEXT 
FROM 	crKeyFields 
INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
	@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
	@IsIdentity, @sTypeName, @sDefaultValue
				
WHILE (@@FETCH_STATUS = 0)
 BEGIN
	IF (@bPrimaryKeyColumn = 1)
	 BEGIN
		IF (@sKeyFields <> '')
			SET @sKeyFields = @sKeyFields + ',' + @sCRLF 
	
		SET @sKeyFields = @sKeyFields + @sTAB + '@' + @sColumnName + ' ' + @sTypeName
	
		IF (@nAlternateType = 2) --decimal, numeric
			SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnPrecision AS varchar(3)) + ', ' 
					+ CAST(@nColumnScale AS varchar(3)) + ')'
	
		ELSE IF (@nAlternateType = 1) --character and binary
			SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnLength AS varchar(4)) +  ')'

		IF (@sWhereClause = '')
			SET @sWhereClause = @sWhereClause + 'WHERE ' 
		ELSE
			SET @sWhereClause = @sWhereClause + ' AND ' 

		SET @sWhereClause = @sWhereClause + @sTAB + @sColumnName  + ' = @' + @sColumnName + @sCRLF 
	 END

	IF (@sSelectClause = '')
		SET @sSelectClause = @sSelectClause + 'SELECT'
	ELSE
		SET @sSelectClause = @sSelectClause + ',' + @sCRLF 

	SET @sSelectClause = @sSelectClause + @sTAB + @sColumnName 

	FETCH 	NEXT 
	FROM 	crKeyFields 
	INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
		@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
		@IsIdentity, @sTypeName, @sDefaultValue
 END

CLOSE crKeyFields
DEALLOCATE crKeyFields

SET 	@sSelectClause = @sSelectClause + @sCRLF

SET 	@sProcText = @sProcText + @sKeyFields + @sCRLF
SET 	@sProcText = @sProcText + 'AS' + @sCRLF
SET 	@sProcText = @sProcText + @sCRLF
SET 	@sProcText = @sProcText + @sSelectClause
SET 	@sProcText = @sProcText + 'FROM	' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + @sWhereClause
SET 	@sProcText = @sProcText + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF


PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)










GO
/****** Object:  StoredProcedure [dbo].[pr__SYS_MakeUpdateRecordProc]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE         PROC [dbo].[pr__SYS_MakeUpdateRecordProc]
	@sTableName varchar(128),
	@bExecute bit = 0
AS

IF dbo.fnTableHasPrimaryKey(@sTableName) = 0
 BEGIN
	RAISERROR ('Procedure cannot be created on a table with no primary key.', 10, 1)
	RETURN
 END

DECLARE	@sProcText varchar(8000),
	@sKeyFields varchar(2000),
	@sSetClause varchar(2000),
	@sWhereClause varchar(2000),
	@sColumnName varchar(128),
	@nColumnID smallint,
	@bPrimaryKeyColumn bit,
	@nAlternateType int,
	@nColumnLength int,
	@nColumnPrecision int,
	@nColumnScale int,
	@IsNullable bit, 
	@IsIdentity int,
	@sTypeName varchar(128),
	@sDefaultValue varchar(4000),
	@sCRLF char(2),
	@sTAB char(1)

SET	@sTAB = char(9)
SET 	@sCRLF = char(13) + char(10)

SET 	@sProcText = ''
SET 	@sKeyFields = ''
SET	@sSetClause = ''
SET	@sWhereClause = ''

SET 	@sProcText = @sProcText + 'IF EXISTS(SELECT * FROM sysobjects WHERE name = ''prApp_' + @sTableName + '_Update'')' + @sCRLF
SET 	@sProcText = @sProcText + @sTAB + 'DROP PROC prApp_' + @sTableName + '_Update' + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF

SET 	@sProcText = @sProcText + @sCRLF

PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)

SET 	@sProcText = ''
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + '-- Update a single record in ' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + '----------------------------------------------------------------------------' + @sCRLF
SET 	@sProcText = @sProcText + 'CREATE PROC prApp_' + @sTableName + '_Update' + @sCRLF

DECLARE crKeyFields cursor for
	SELECT	*
	FROM	dbo.fnTableColumnInfo(@sTableName)
	ORDER BY 2

OPEN crKeyFields


FETCH 	NEXT 
FROM 	crKeyFields 
INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
	@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
	@IsIdentity, @sTypeName, @sDefaultValue
				
WHILE (@@FETCH_STATUS = 0)
 BEGIN
	IF (@sKeyFields <> '')
		SET @sKeyFields = @sKeyFields + ',' + @sCRLF 

	SET @sKeyFields = @sKeyFields + @sTAB + '@' + @sColumnName + ' ' + @sTypeName

	IF (@nAlternateType = 2) --decimal, numeric
		SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnPrecision AS varchar(3)) + ', ' 
				+ CAST(@nColumnScale AS varchar(3)) + ')'

	ELSE IF (@nAlternateType = 1) --character and binary
		SET @sKeyFields =  @sKeyFields + '(' + CAST(@nColumnLength AS varchar(4)) +  ')'

	IF (@bPrimaryKeyColumn = 1)
	 BEGIN
		IF (@sWhereClause = '')
			SET @sWhereClause = @sWhereClause + 'WHERE ' 
		ELSE
			SET @sWhereClause = @sWhereClause + ' AND ' 

		SET @sWhereClause = @sWhereClause + @sTAB + @sColumnName  + ' = @' + @sColumnName + @sCRLF 
	 END
	ELSE
		IF (@IsIdentity = 0)
		 BEGIN
			IF (@sSetClause = '')
				SET @sSetClause = @sSetClause + 'SET'
			ELSE
				SET @sSetClause = @sSetClause + ',' + @sCRLF 
			SET @sSetClause = @sSetClause + @sTAB + @sColumnName  + ' = '
			IF (@sTypeName = 'timestamp')
				SET @sSetClause = @sSetClause + 'NULL'
			ELSE IF (@sDefaultValue IS NOT NULL)
				SET @sSetClause = @sSetClause + 'COALESCE(@' + @sColumnName + ', ' + @sDefaultValue + ')'
			ELSE
				SET @sSetClause = @sSetClause + '@' + @sColumnName 
		 END

	IF (@IsIdentity = 0)
	 BEGIN
		IF (@IsNullable = 1) OR (@sTypeName = 'timestamp')
			SET @sKeyFields = @sKeyFields + ' = NULL'
	 END

	FETCH 	NEXT 
	FROM 	crKeyFields 
	INTO 	@sColumnName, @nColumnID, @bPrimaryKeyColumn, @nAlternateType, 
		@nColumnLength, @nColumnPrecision, @nColumnScale, @IsNullable, 
		@IsIdentity, @sTypeName, @sDefaultValue
 END

CLOSE crKeyFields
DEALLOCATE crKeyFields

SET 	@sSetClause = @sSetClause + @sCRLF

SET 	@sProcText = @sProcText + @sKeyFields + @sCRLF
SET 	@sProcText = @sProcText + 'AS' + @sCRLF
SET 	@sProcText = @sProcText + @sCRLF
SET 	@sProcText = @sProcText + 'UPDATE	' + @sTableName + @sCRLF
SET 	@sProcText = @sProcText + @sSetClause
SET 	@sProcText = @sProcText + @sWhereClause
SET 	@sProcText = @sProcText + @sCRLF
IF @bExecute = 0
	SET 	@sProcText = @sProcText + 'GO' + @sCRLF


PRINT @sProcText

IF @bExecute = 1 
	EXEC (@sProcText)


GO
/****** Object:  StoredProcedure [dbo].[prApp_DetalleInOutP_Delete]    Script Date: 24/08/2017 13:55:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[prApp_DetalleInOutP_Delete]
	@id int
AS

DELETE	DetalleInOutP
WHERE 	id = @id


GO
USE [master]
GO
ALTER DATABASE [ProyectoFinalTJ] SET  READ_WRITE 
GO
