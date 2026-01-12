CREATE TABLE [dbo].[User] (
    [UserId]       SMALLINT        IDENTITY (1, 1) NOT NULL,
    [DateCreated]  DATETIME2 (2)   CONSTRAINT [DF_Dbo_User_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]  DATETIME2 (2)   CONSTRAINT [DF_Dbo_User_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [UserName]     VARCHAR (50)    NOT NULL,
    [PasswordHash] VARBINARY (64)  NULL,
    [PasswordSalt] VARBINARY (128) NULL,
    [IsActive]     BIT             NULL,
    [Email]        VARCHAR (255)   NULL,
    CONSTRAINT [PK_Dbo_User] PRIMARY KEY CLUSTERED ([UserId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Dbo_User_UserName]
    ON [dbo].[User]([UserName] ASC);


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