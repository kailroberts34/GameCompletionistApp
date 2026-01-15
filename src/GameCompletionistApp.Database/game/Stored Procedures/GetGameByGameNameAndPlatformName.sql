
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