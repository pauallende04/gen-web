USE PP_DDBB;
GO

--
EXEC sp_wdev_user_insert 
    @USERNAME = 'TOR',
    @NAME = 'Pau',
    @LASTNAME = 'Allende',
    @PASSWORD = 'contraseña',
    @EMAIL = 'correoTOR@example.com'
--
EXEC sp_user_register 
    @USERNAME = 'BlowFlow',
    @NAME = 'Pau',
    @LASTNAME = 'Allende',
    @PASSWORD = 'Contraseña#123',
    @EMAIL = 'blowflow@example.com'

--
EXEC sp_user_accountvalidate
    @USERNAME = 'BlowFlow',
    @REGISTER_CODE = 99204;

--
EXEC sp_user_login
    @USERNAME = 'BlowFlow',
    @PASSWORD = 'Contraseña#123'

--
SELECT * FROM USER_CONNECTIONS;
EXEC sp_user_logout
    @CONNECTION_ID = 'eb19238b-e9f0-45b7-8f3d-988dc209bf19';

--
SELECT * FROM USERS
EXEC sp_user_change_password
    @USERNAME = 'BlowFlow', 
    @CURRENT_PASSWORD = 'Contraseña#123', 
    @NEW_PASSWORD = 'Contraseña*123'
SELECT * FROM USERS;
SELECT * FROM PWD_HISTORY;

--
EXEC sp_user_get_accountdata 
    @USERNAME = 'BlowFlow'

