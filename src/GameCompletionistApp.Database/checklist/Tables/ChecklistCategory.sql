CREATE TABLE [checklist].[ChecklistCategory] (
    [ChecklistCategoryId]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [DateCreated]           DATETIME2 (2) CONSTRAINT [DF_Checklist_ChecklistCategory_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated]           DATETIME2 (2) CONSTRAINT [DF_checklist_ChecklistCategory_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [ChecklistCategoryName] VARCHAR (100) NOT NULL,
    [GameId]                INT           NOT NULL,
    CONSTRAINT [PK_Checklist_ChecklistCategory] PRIMARY KEY CLUSTERED ([ChecklistCategoryId] ASC),
    CONSTRAINT [FK_Checklist_ChecklistCategory_Game_Game] FOREIGN KEY ([GameId]) REFERENCES [game].[Game] ([GameId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Checklist_ChecklistCategory_ChecklistCategoryName_GameId]
    ON [checklist].[ChecklistCategory]([ChecklistCategoryName] ASC, [GameId] ASC);


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