Drop user ija_tibet2_user cascade;

Create user ija_tibet2_user identified by ija_tibet2_user default tablespace users; 

Grant dba to ija_tibet2_user;
Grant resource to ija_tibet2_user;
Grant connect to ija_tibet2_user;

DROP ROLE ROLE_ING_WEBSPHERE_XA;
CREATE ROLE ROLE_ING_WEBSPHERE_XA;
GRANT SELECT ON SYS.DBA_PENDING_TRANSACTIONS TO ROLE_ING_WEBSPHERE_XA;
GRANT SELECT ON SYS.DBA_2PC_PENDING TO ROLE_ING_WEBSPHERE_XA;
GRANT EXECUTE ON SYS.DBMS_SYSTEM TO ROLE_ING_WEBSPHERE_XA;
GRANT SELECT ON SYS.PENDING_TRANS$ TO ROLE_ING_WEBSPHERE_XA;

Grant ROLE_ING_WEBSPHERE_XA to ija_tibet2_user;

commit;
exit