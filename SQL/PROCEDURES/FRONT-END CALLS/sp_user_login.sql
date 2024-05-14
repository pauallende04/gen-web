USE PP_DDBB;
GO

-- sp_user_login
CREATE OR ALTER PROCEDURE sp_user_login
    @USERNAME NVARCHAR(25),
    @PASSWORD NVARCHAR(50)

AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @XML_RESPONSE XML;
    DECLARE @LOGIN_STATUS BIT;
    DECLARE @ret INT;
    SET @ret = -1;

    SELECT @LOGIN_STATUS = LOGIN_STATUS
    FROM USERS
    WHERE USERNAME = @USERNAME;

    IF @LOGIN_STATUS = 1
    BEGIN
        EXEC sp_user_logout @USERNAME;
        SET @ret = 500;
        GOTO ExitProc;
    END
    
    IF (dbo.fn_user_exists(@USERNAME) = 0)
    BEGIN
        SET @ret = 501;
        GOTO ExitProc;
    END
    ELSE
    BEGIN
        IF (dbo.fn_user_state(@USERNAME) = 0)
        BEGIN
            SET @ret = 423;
            GOTO ExitProc;
        END
        ELSE
        BEGIN
            IF (dbo.fn_pwd_isvalid(@PASSWORD, @USERNAME) = 0)
            BEGIN
                SET @ret = 502;
                GOTO ExitProc;
            END
            ELSE
            BEGIN
                DECLARE @CONNECTION_ID UNIQUEIDENTIFIER;
                SET @CONNECTION_ID = dbo.fn_generate_ssid();

                INSERT INTO USER_CONNECTIONS
                    (CONNECTION_ID, USER_ID, USERNAME, DATE_CONNECTED)
                VALUES
                    (@CONNECTION_ID, (SELECT ID
                        FROM USERS
                        WHERE USERNAME = @USERNAME),@USERNAME, CONVERT(DATETIME, SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02:00')));

                UPDATE USERS SET LOGIN_STATUS = 1 WHERE USERNAME = @USERNAME;

                IF @@ROWCOUNT = 1
                BEGIN
                    SET @ret = 0;
                    GOTO ExitProc;
                END
            END
        END
    END

    ExitProc:
    DECLARE @ResponseXML XML;
    EXEC sp_xml_error_message @RETURN = @ret, @XmlResponse = @ResponseXML OUTPUT;
    SELECT @ResponseXML;

END
GO
