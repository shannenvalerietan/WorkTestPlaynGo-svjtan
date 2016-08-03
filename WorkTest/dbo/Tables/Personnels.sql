CREATE TABLE [dbo].[Personnels]
(
	[PersonnelId] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY, 
    [FirstName] NVARCHAR(250) NOT NULL, 
    [MiddleName] NVARCHAR(50) NULL, 
    [Surname] NVARCHAR(250) NOT NULL, 
    [ExtensionName] NVARCHAR(10) NULL, 
    [ContactNumber] NVARCHAR(50) NOT NULL, 
    [EmailAddress] NVARCHAR(150) NOT NULL, 
    [CreatedAt] INT NOT NULL, 
    [Active] BIT NOT NULL DEFAULT 1
)
