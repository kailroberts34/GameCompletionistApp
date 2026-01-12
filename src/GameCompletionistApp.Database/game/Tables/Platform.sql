CREATE TABLE [game].[Platform] (
    [PlatformId]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [DateCreated]  DATETIME2 (2) CONSTRAINT [DF_Game_Platform_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]  DATETIME2 (2) CONSTRAINT [DF_Game_Platform_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [PlatformName] VARCHAR (25)  NOT NULL,
    CONSTRAINT [PK_Game_Platform] PRIMARY KEY CLUSTERED ([PlatformId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Game_Platform_PlatformName]
    ON [game].[Platform]([PlatformName] ASC);


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