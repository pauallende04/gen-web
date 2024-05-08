USE PP_DDBB;

-- fn_generate_connect_id
go

create view v_guid 
AS
    select newid() guid
go

CREATE OR ALTER FUNCTION fn_generate_connect_id()
returns UNIQUEIDENTIFIER
AS
BEGIN
    declare @ssid UNIQUEIDENTIFIER;

    set @ssid = (select guid from v_guid)

    return @ssid
END
GO

select dbo.fn_generate_connect_id();