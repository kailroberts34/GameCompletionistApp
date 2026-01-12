CREATE TABLE [game].[GameToUser] (
    [GameToUserId] INT           IDENTITY (1, 1) NOT NULL,
    [DateCreated]  DATETIME2 (2) CONSTRAINT [DF_Game_GameToUser_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]  DATETIME2 (2) CONSTRAINT [DF_Game_GameToUser_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [UserId]       SMALLINT      NOT NULL,
    [GameId]       INT           NOT NULL,
    CONSTRAINT [PK_Game_GameToUser] PRIMARY KEY CLUSTERED ([GameToUserId] ASC),
    CONSTRAINT [FK_Game_GameToUser_Dbo_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserId]),
    CONSTRAINT [FK_Game_GameToUser_Game_Game] FOREIGN KEY ([GameId]) REFERENCES [game].[Game] ([GameId])
);


GO

CREATE TRIGGER game.TrGameToUserDateUpdated ON game.GameToUser AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM game.GameToUser t
	INNER JOIN inserted i ON i.GameToUserId = t.GameToUserId;
END;