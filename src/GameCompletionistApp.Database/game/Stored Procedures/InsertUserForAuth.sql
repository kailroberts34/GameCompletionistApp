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