CREATE PROCEDURE game.GetGameForUser
@UserId SMALLINT
/*
author: kroberts

gets games for user

*/
AS
BEGIN

	SELECT
		G.GameId,
		G.GameName,
		P.PlatformName,
		COUNT(CI.ChecklistItemId) AS TotalItems,
		SUM(CASE WHEN UCP.IsCompleted = 1 THEN 1 ELSE 0 END) as CompletedItems
	FROM game.Game G
	INNER JOIN game.[Platform] P ON P.[PlatformId] = G.[PlatformId]
	INNER JOIN checklist.ChecklistItem CI ON CI.GameId = G.GameId
	LEFT JOIN checklist.UserChecklistProgress UCP ON UCP.ChecklistItemId = CI.ChecklistItemId AND UCP.UserId = @UserId
	GROUP BY G.GameId, G.GameName, P.PlatformName
END;
go
CREATE or alter PROCEDURE game.GetUserByEmailForAuth
@Email VARCHAR(255)
/*
author: kroberts

gets games for user

*/
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
        UserId,
		UserName
        Email,
        PasswordHash,
		PasswordSalt
    FROM dbo.[User]
    WHERE Email = @Email
      AND IsActive = 1;
END;

GO

CREATE PROCEDURE game.InsertUserForAuth
@UserName VARCHAR(50),
@Email VARCHAR(255),
@PasswordHash VARBINARY(64),
@PasswordSalt VARBINARY(128)
/*
author: kroberts

gets games for user

*/
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @UserId SMALLINT;
    INSERT INTO dbo.[User] (UserName, Email, PasswordHash, PasswordSalt, IsActive)
	VALUES (@UserName, @Email, @PasswordHash, @PasswordSalt, 1);

	SELECT @UserId = SCOPE_IDENTITY();
END;