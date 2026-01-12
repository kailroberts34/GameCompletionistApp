CREATE   PROCEDURE game.GetGamesForUser
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
		G.ReleaseYear,
		P.PlatformName
	FROM game.Game G
	INNER JOIN game.[Platform] P ON P.[PlatformId] = G.[PlatformId]
	INNER JOIN game.GameToUser GTU ON GTU.GameId = G.GameId AND GTU.UserId = @UserId
END;