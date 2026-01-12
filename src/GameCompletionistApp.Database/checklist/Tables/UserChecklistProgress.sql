CREATE TABLE [checklist].[UserChecklistProgress] (
    [UserChecklistProgressId] INT           IDENTITY (1, 1) NOT NULL,
    [DateCreated]             DATETIME2 (2) CONSTRAINT [DF_Checklist_UserChecklistProgress_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]             DATETIME2 (2) CONSTRAINT [DF_checklist_UserChecklistProgress_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [UserId]                  SMALLINT      NOT NULL,
    [ChecklistItemId]         INT           NOT NULL,
    [IsCompleted]             BIT           NOT NULL,
    CONSTRAINT [PK_Checklist_UserChecklistProgress] PRIMARY KEY CLUSTERED ([UserChecklistProgressId] ASC),
    CONSTRAINT [FK_Checklist_UserChecklistProgress_Checklist_ChecklistItem] FOREIGN KEY ([ChecklistItemId]) REFERENCES [checklist].[ChecklistItem] ([ChecklistItemId]),
    CONSTRAINT [FK_Checklist_UserChecklistProgress_Dbo_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([UserId])
);


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