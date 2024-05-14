USE PP_DDBB;
GO

--
EXEC sp_user_register 
    @USERNAME = 'pol888',
    @NAME = 'Pol',
    @LASTNAME = 'Rabascall',
    @PASSWORD = 'Contraseña#123',
    @EMAIL = 'pol888@example.com'

SELECT * FROM USERS;

--
EXEC sp_user_accountvalidate
    @USERNAME = 'pauallende04',
    @REGISTER_CODE = 89354;

--
EXEC sp_user_login
    @USERNAME = 'pol888',
    @PASSWORD = 'Contraseña#123'

--
SELECT * FROM USER_CONNECTIONS;
EXEC sp_user_logout
    @USERNAME = 'pol888';
    
SELECT * FROM USERS;

--
SELECT * FROM USERS
EXEC sp_user_change_password
    @USERNAME = 'BlowFlow', 
    @CURRENT_PASSWORD = 'Contraseña#123', 
    @NEW_PASSWORD = 'Contraseña*123'
SELECT * FROM USERS;
SELECT * FROM PWD_HISTORY;
DELETE FROM PWD_HISTORY;

--
EXEC sp_user_get_accountdata 
    @USERNAME = 'BlowFlow'

---
EXEC sp_list_connections;
