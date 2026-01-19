CREATE   PROCEDURE [dbo].[GetUserByUserId]
@UserId SMALLINT
/*
author: kroberts

inserts games for user

*/
AS
BEGIN

	IF EXISTS (SELECT 1 FROM dbo.[User] U WHERE U.UserId = @UserId)
	BEGIN
		SELECT @UserId;
	END;

	
END;