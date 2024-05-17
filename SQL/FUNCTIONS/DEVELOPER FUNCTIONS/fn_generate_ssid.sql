USE PP_DDBB;

-- fn_generate_ssid  generar sesion id 
go

create view v_guid 
AS
    select newid() guid
go

CREATE OR ALTER FUNCTION fn_generate_ssid()
returns UNIQUEIDENTIFIER
AS
BEGIN
    declare @ssid UNIQUEIDENTIFIER;

    set @ssid = (select guid from v_guid)

    return @ssid
END
GO
