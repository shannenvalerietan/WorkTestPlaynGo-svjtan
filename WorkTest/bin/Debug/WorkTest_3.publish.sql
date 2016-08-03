﻿/*
Deployment script for WorkTest

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "WorkTest"
:setvar DefaultFilePrefix "WorkTest"
:setvar DefaultDataPath "c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Personnels].[BirthDate] is being dropped, data loss could occur.

The column [dbo].[Personnels].[BirthPlace] is being dropped, data loss could occur.

The column [dbo].[Personnels].[Gender] is being dropped, data loss could occur.

The type for column EmailAddress in table [dbo].[Personnels] is currently  NVARCHAR (250) NULL but is being changed to  NVARCHAR (150) NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Personnels])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'The following operation was generated from a refactoring log file 51e348a4-27a1-485a-ac90-5b0a98945f8c, c20be0d0-e7c1-4d98-8e34-457b7ee9d887';

PRINT N'Rename [dbo].[Personnels].[CivilStatus] to EmailAddress';


GO
EXECUTE sp_rename @objname = N'[dbo].[Personnels].[CivilStatus]', @newname = N'EmailAddress', @objtype = N'COLUMN';


GO
PRINT N'Dropping unnamed constraint on [dbo].[Personnels]...';


GO
ALTER TABLE [dbo].[Personnels] DROP CONSTRAINT [DF__Personnel__Activ__1273C1CD];


GO
PRINT N'Starting rebuilding table [dbo].[Personnels]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Personnels] (
    [PersonnelId]   INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]     NVARCHAR (250) NOT NULL,
    [MiddleName]    NVARCHAR (50)  NULL,
    [Surname]       NVARCHAR (250) NOT NULL,
    [ExtensionName] NVARCHAR (10)  NULL,
    [ContactNumber] NVARCHAR (50)  NULL,
    [EmailAddress]  NVARCHAR (150) NULL,
    [CreatedAt]     INT            NOT NULL,
    [UpdatedAt]     INT            NULL,
    [Active]        BIT            DEFAULT 1 NOT NULL,
    PRIMARY KEY CLUSTERED ([PersonnelId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Personnels])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Personnels] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Personnels] ([PersonnelId], [FirstName], [MiddleName], [Surname], [ExtensionName], [EmailAddress], [CreatedAt], [UpdatedAt], [Active])
        SELECT   [PersonnelId],
                 [FirstName],
                 [MiddleName],
                 [Surname],
                 [ExtensionName],
                 [EmailAddress],
                 [CreatedAt],
                 [UpdatedAt],
                 [Active]
        FROM     [dbo].[Personnels]
        ORDER BY [PersonnelId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Personnels] OFF;
    END

DROP TABLE [dbo].[Personnels];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Personnels]', N'Personnels';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '51e348a4-27a1-485a-ac90-5b0a98945f8c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('51e348a4-27a1-485a-ac90-5b0a98945f8c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c20be0d0-e7c1-4d98-8e34-457b7ee9d887')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c20be0d0-e7c1-4d98-8e34-457b7ee9d887')

GO

GO
PRINT N'Update complete.';


GO