USE [WorkTest]

SET IDENTITY_INSERT [dbo].[Personnels] ON 
IF NOT EXISTS(SELECT TOP 1 1 from dbo.[Personnels])
BEGIN

INSERT [dbo].[Personnels] ([PersonnelId], [FirstName], [MiddleName], [Surname], [ExtensionName], [ContactNumber], [EmailAddress], [CreatedAt], [Active]) VALUES (1, N'Shannen Valerie', N'Juan', N'Tan', NULL, N'1', N'shannen@email.com', 1470211455, 1)

END
SET IDENTITY_INSERT [dbo].[Personnels] OFF
