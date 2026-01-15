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
go

ALTER   PROCEDURE [game].[GetGamesForUser]
@UserId SMALLINT
/*
author: kroberts

gets games for user

*/
AS
BEGIN

	SELECT
		G.GameId,
		GTU.UserId,
		G.GameName,
		G.ReleaseYear,
		P.PlatformName
	FROM game.Game G
	INNER JOIN game.[Platform] P ON P.[PlatformId] = G.[PlatformId]
	INNER JOIN game.GameToUser GTU ON GTU.GameId = G.GameId AND GTU.UserId = @UserId
END;
GO

CREATE   PROCEDURE [game].[InsertGamesForUser]
@GameName VARCHAR(100),
@Platform VARCHAR(25),
@ReleaseYear INT
/*
author: kroberts

inserts games for user

*/
AS
BEGIN

	DECLARE @PlatformId TINYINT;
	IF NOT EXISTS (SELECT 1 FROM game.[Platform] WHERE PlatformName = @Platform)
	BEGIN
		INSERT INTO game.[Platform](
			PlatformName
		)
		VALUES
		(
			@Platform
		)
		SELECT @PlatformId = SCOPE_IDENTITY();
	END;

	SELECT @PlatformId = P.PlatformId
	FROM game.[Platform] P
	WHERE P.PlatformName = @Platform;


	INSERT INTO game.Game
	(
		GameName,
		PlatformId,
		ReleaseYear
	)
	VALUES
	(
	@GameName,
	@PlatformId,
	@ReleaseYear
	)

	
END;
GO


CREATE   PROCEDURE [game].[GetGameByGameNameAndPlatformName]
@GameName VARCHAR(100),
@Platform VARCHAR(25)
/*
author: kroberts

inserts games for user

*/
AS
BEGIN

	SELECT G.GameId
	FROM game.Game G
	INNER JOIN game.[Platform] P ON P.PlatformId = G.PlatformId
	WHERE P.PlatformName = @Platform AND G.GameName = @GameName;

	
END;
GO

CREATE   PROCEDURE [game].[AssignGameToUser]
@GameId INT,
@UserId SMALLINT
/*
author: kroberts

inserts games for user

*/
AS
BEGIN

	INSERT INTO game.GameToUser
	(
		GameId,
		UserId
	)
	VALUES
	(
		@GameId,
		@UserId
	)

	
END;
GO