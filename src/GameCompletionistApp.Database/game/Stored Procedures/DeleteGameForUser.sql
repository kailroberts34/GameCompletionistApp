CREATE   PROCEDURE [game].[DeleteGameForUser]
@UserId SMALLINT,
@GameId INT
/*
author: kroberts

inserts games for user

*/
AS
BEGIN

	DELETE GTU
	FROM game.GameToUser GTU
	WHERE GTU.UserId = @UserId AND GTU.GameId = @GameId;

	
END;