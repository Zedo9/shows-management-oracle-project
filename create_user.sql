-- Create User
CREATE USER proj_sgbd IDENTIFIED BY 123456
DEFAULT TABLESPACE users
QUOTA UNLIMITED on users
TEMPORARY TABLESPACE temp;

-- Granting DBA Role
GRANT DBA TO proj_sgbd;