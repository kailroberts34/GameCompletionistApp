CREATE TABLE [game].[Game] (
    [GameId]      INT           IDENTITY (1, 1) NOT NULL,
    [DateCreated] DATETIME2 (2) CONSTRAINT [DF_Game_Game_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated] DATETIME2 (2) CONSTRAINT [DF_Game_Game_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [GameName]    VARCHAR (100) NOT NULL,
    [ReleaseYear] INT           NOT NULL,
    [PlatformId]  TINYINT       NOT NULL,
    CONSTRAINT [PK_Game_Game] PRIMARY KEY CLUSTERED ([GameId] ASC),
    CONSTRAINT [FK_Game_Game_Game_Platform] FOREIGN KEY ([PlatformId]) REFERENCES [game].[Platform] ([PlatformId])
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