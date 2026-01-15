
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