CREATE TABLE [checklist].[ChecklistItem] (
    [ChecklistItemId]          INT           IDENTITY (1, 1) NOT NULL,
    [DateCreated]              DATETIME2 (2) CONSTRAINT [DF_Checklist_ChecklistItem_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]              DATETIME2 (2) CONSTRAINT [DF_checklist_ChecklistItem_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [ChecklistCategoryId]      TINYINT       NOT NULL,
    [GameId]                   INT           NOT NULL,
    [ChecklistItemName]        VARCHAR (100) NOT NULL,
    [ChecklistItemDescription] VARCHAR (100) NOT NULL,
    [IsOptional]               BIT           NOT NULL,
    CONSTRAINT [PK_Checklist_ChecklistItem] PRIMARY KEY CLUSTERED ([ChecklistItemId] ASC),
    CONSTRAINT [FK_Checklist_ChecklistItem_Checklist_ChecklistCategory] FOREIGN KEY ([ChecklistCategoryId]) REFERENCES [checklist].[ChecklistCategory] ([ChecklistCategoryId]),
    CONSTRAINT [FK_Checklist_ChecklistItem_Game_Game] FOREIGN KEY ([GameId]) REFERENCES [game].[Game] ([GameId])
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