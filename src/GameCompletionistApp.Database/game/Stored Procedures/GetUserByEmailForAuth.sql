
CREATE   PROCEDURE game.GetUserByEmailForAuth
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