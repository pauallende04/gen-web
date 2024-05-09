USE PP_DDBB;
GO

CREATE OR ALTER FUNCTION fn_mail_isvalid (@EMAIL NVARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @ValidEmail BIT = 0;
    DECLARE @AtPosition INT, @DotPosition INT;

    -- Verificar si el correo electrónico contiene '@' y al menos un caracter antes y después
    SET @AtPosition = CHARINDEX('@', @EMAIL);
    IF (@AtPosition > 1 AND @AtPosition < LEN(@EMAIL))
    BEGIN
        -- Verificar si el correo electrónico contiene un punto después de '@' y al menos un caracter después del punto
        SET @DotPosition = CHARINDEX('.', @EMAIL, @AtPosition);
        IF (@DotPosition > (@AtPosition + 1) AND @DotPosition < LEN(@EMAIL))
        BEGIN
            SET @ValidEmail = 1;
        END;
    END;

    RETURN @ValidEmail;
END;