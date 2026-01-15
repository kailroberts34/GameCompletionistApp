
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