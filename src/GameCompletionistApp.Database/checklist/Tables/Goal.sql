CREATE TABLE [checklist].[Goal] (
    [GoalId]      INT           IDENTITY (1, 1) NOT NULL,
    [DateCreated] DATETIME2 (2) CONSTRAINT [DF_Checklist_Goal_DateCreated] DEFAULT (sysdatetime()) NOT NULL,
    [DateUpdated] DATETIME2 (2) CONSTRAINT [DF_checklist_Goal_DateUpdated] DEFAULT (sysdatetime()) NOT NULL,
    [GameId]      INT           NOT NULL,
    [IsCompleted] BIT           NOT NULL,
    [Description] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_Checklist_Goal] PRIMARY KEY CLUSTERED ([GoalId] ASC),
    CONSTRAINT [FK_Checklist_Goal_Game_Game] FOREIGN KEY ([GameId]) REFERENCES [game].[Game] ([GameId])
);


GO

CREATE TRIGGER checklist.TrGoalDateUpdated ON checklist.Goal AFTER UPDATE
AS
/*
author: kroberts

updates DateUpdated when record is updated

*/
BEGIN
	SET NOCOUNT ON;

	UPDATE t
	SET t.DateUpdated = SYSDATETIME()
	FROM checklist.Goal t
	INNER JOIN inserted i ON i.GoalId = t.GoalId;
END;