USE GameChecklist;
GO

CREATE SCHEMA game;
GO

CREATE SCHEMA checklist;
GO


CREATE TABLE dbo.[User](

	UserId SMALLINT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Dbo_User_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_Dbo_User_DateUpdated] DEFAULT (SYSDATETIME()),
	UserName VARCHAR(50) NOT NULL,
	CONSTRAINT [PK_Dbo_User] PRIMARY KEY CLUSTERED (UserId ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Dbo_User_UserName] ON dbo.[User] (UserName ASC);
GO

CREATE TRIGGER dbo.TrUserDateUpdated ON dbo.[User] AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM dbo.[User] t
	INNER JOIN inserted i ON i.UserId = t.UserId;
END;
GO



CREATE TABLE game.[Platform](

	PlatformId TINYINT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Game_Platform_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_Game_Platform_DateUpdated] DEFAULT (SYSDATETIME()),
	PlatformName VARCHAR(25) NOT NULL,
	CONSTRAINT [PK_Game_Platform] PRIMARY KEY CLUSTERED (PlatformId ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Game_Platform_PlatformName] ON game.[Platform] (PlatformName ASC);
GO

CREATE TRIGGER game.TrPlatformDateUpdated ON game.[Platform] AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM game.[Platform] t
	INNER JOIN inserted i ON i.PlatformId = t.PlatformId;
END;
GO

CREATE TABLE game.Game(

	GameId INT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Game_Game_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_Game_Game_DateUpdated] DEFAULT (SYSDATETIME()),
	GameName VARCHAR(100) NOT NULL,
	ReleaseYear INT NOT NULL,
	PlatformId TINYINT NOT NULL CONSTRAINT [FK_Game_Game_Game_Platform] FOREIGN KEY REFERENCES game.[Platform](PlatformId),
	CONSTRAINT [PK_Game_Game] PRIMARY KEY CLUSTERED (GameId ASC)
);
GO

CREATE TRIGGER game.TrGameDateUpdated ON game.Game AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM game.Game t
	INNER JOIN inserted i ON i.GameId = t.GameId;
END;
GO

CREATE TABLE checklist.ChecklistCategory(

	ChecklistCategoryId TINYINT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Checklist_ChecklistCategory_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_checklist_ChecklistCategory_DateUpdated] DEFAULT (SYSDATETIME()),
	ChecklistCategoryName VARCHAR(100) NOT NULL,
	GameId INT NOT NULL CONSTRAINT [FK_Checklist_ChecklistCategory_Game_Game] FOREIGN KEY REFERENCES game.[Game](GameId),
	CONSTRAINT [PK_Checklist_ChecklistCategory] PRIMARY KEY CLUSTERED (ChecklistCategoryId ASC)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [UQ_Checklist_ChecklistCategory_ChecklistCategoryName_GameId] ON checklist.[ChecklistCategory] (ChecklistCategoryName ASC, GameId ASC);
GO

CREATE TRIGGER checklist.TrChecklistCategoryDateUpdated ON checklist.ChecklistCategory AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM checklist.ChecklistCategory t
	INNER JOIN inserted i ON i.ChecklistCategoryId = t.ChecklistCategoryId;
END;
GO

CREATE TABLE checklist.ChecklistItem(

	ChecklistItemId INT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Checklist_ChecklistItem_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_checklist_ChecklistItem_DateUpdated] DEFAULT (SYSDATETIME()),
	ChecklistCategoryId TINYINT NOT NULL CONSTRAINT [FK_Checklist_ChecklistItem_Checklist_ChecklistCategory] FOREIGN KEY REFERENCES checklist.ChecklistCategory(ChecklistCategoryId),
	GameId INT NOT NULL CONSTRAINT [FK_Checklist_ChecklistItem_Game_Game] FOREIGN KEY REFERENCES game.[Game](GameId),
	ChecklistItemName VARCHAR(100) NOT NULL,
	ChecklistItemDescription VARCHAR(100) NOT NULL,
	IsOptional BIT NOT NULL,
	CONSTRAINT [PK_Checklist_ChecklistItem] PRIMARY KEY CLUSTERED (ChecklistItemId ASC)
);
GO

CREATE TRIGGER checklist.TrChecklistItemDateUpdated ON checklist.ChecklistItem AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM checklist.ChecklistItem t
	INNER JOIN inserted i ON i.ChecklistItemId = t.ChecklistItemId;
END;
GO

CREATE TABLE checklist.UserChecklistProgress(

	UserChecklistProgressId INT NOT NULL IDENTITY(1, 1),
	DateCreated DATETIME2(2) NOT NULL CONSTRAINT [DF_Checklist_UserChecklistProgress_DateCreated] DEFAULT (SYSDATETIME()),
	DateUpdated DATETIME2(2) NOT NULL CONSTRAINT [DF_checklist_UserChecklistProgress_DateUpdated] DEFAULT (SYSDATETIME()),
	UserId SMALLINT NOT NULL CONSTRAINT [FK_Checklist_UserChecklistProgress_Dbo_User] FOREIGN KEY REFERENCES dbo.[User] (UserId),
	ChecklistItemId INT NOT NULL CONSTRAINT [FK_Checklist_UserChecklistProgress_Checklist_ChecklistItem]  FOREIGN KEY REFERENCES checklist.ChecklistItem (ChecklistItemId),
	CONSTRAINT [PK_Checklist_UserChecklistProgress] PRIMARY KEY CLUSTERED (UserChecklistProgressId ASC)
);
GO

ALTER TABLE checklist.UserChecklistProgress ADD IsCompleted BIT NOT NULL;
GO

CREATE TRIGGER checklist.TrUserChecklistProgressDateUpdated ON checklist.UserChecklistProgress AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM checklist.UserChecklistProgress t
	INNER JOIN inserted i ON i.UserChecklistProgressId = t.UserChecklistProgressId;
END;
GO

ALTER TABLE dbo.[User] ADD PasswordHash VARBINARY(64) NULL, PasswordSalt VARBINARY(128) NULL, IsActive BIT NULL;
GO

ALTER TABLE dbo.[User] ADD Email VARCHAR(255) NULL;
GO