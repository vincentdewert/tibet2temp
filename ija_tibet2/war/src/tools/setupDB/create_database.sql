DROP TABLE IBISCONFIG cascade constraints;
DROP TABLE IBISSTORE cascade constraints;
DROP TABLE EXCEPTIONLOG cascade constraints;
DROP TABLE AUDITLOG cascade constraints;
DROP TABLE AUTHORISATION cascade constraints;
DROP TABLE IBISPROP cascade constraints;

DROP SEQUENCE SEQ_IBISSTORE;
DROP SEQUENCE SEQ_LOG; 




---------------------------------------------------
--   CREATE TABLE IBISSTORE
---------------------------------------------------

CREATE TABLE IBISSTORE
(
  MESSAGEKEY     NUMBER(10),
  TYPE           CHAR(1 CHAR),
  SLOTID         VARCHAR2(100 CHAR),
  HOST           VARCHAR2(100 CHAR),
  MESSAGEID      VARCHAR2(100 CHAR),
  CORRELATIONID  VARCHAR2(256 CHAR),
  MESSAGEDATE    TIMESTAMP(6),
  COMMENTS       VARCHAR2(1000 CHAR),
  MESSAGE        BLOB,
  EXPIRYDATE     TIMESTAMP(6),
  LABEL          VARCHAR2(100 CHAR)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;


CREATE UNIQUE INDEX PK_IBISSTORE ON IBISSTORE
(MESSAGEKEY)
LOGGING
NOPARALLEL;


CREATE INDEX IX_IBISSTORE ON IBISSTORE
(TYPE, SLOTID, MESSAGEDATE)
LOGGING
NOPARALLEL;


CREATE INDEX IX_IBISSTORE_02 ON IBISSTORE
(EXPIRYDATE)
LOGGING
NOPARALLEL;


ALTER TABLE IBISSTORE ADD (
  CONSTRAINT PK_IBISSTORE
 PRIMARY KEY
 (MESSAGEKEY));

--------------------------------------------------------
--  CREATE SEQUENCE SEQ_IBISSTORE
--------------------------------------------------------

CREATE SEQUENCE SEQ_IBISSTORE
  START WITH 161332
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

---------------------------------------------------
--   CREATE TABLE EXCEPTIONLOG
---------------------------------------------------

CREATE TABLE EXCEPTIONLOG
(
  LOGID                 NUMBER(10)      NOT NULL,
  MESSAGEID             VARCHAR2(255)   NOT NULL,
  CONVERSATIONID        VARCHAR2(255),
  CPAID                 VARCHAR2(255),
  BUSINESSDOMAIN        VARCHAR2(30),
  SERVICENAME           VARCHAR2(255),
  SERVICECONTEXT        VARCHAR2(255),
  SERVICECONTEXTVERSION NUMBER(3),
  OPERATIONNAME         VARCHAR2(255),
  OPERATIONVERSION      NUMBER(3),
  APPLICATIONNAME       VARCHAR2(255),
  APPLICATIONFUNCTION   VARCHAR2(255),
  LOG_TIMESTAMP         TIMESTAMP(6)    NOT NULL,
  SENDERID              VARCHAR2(255),
  CRE_TIMESTAMP         TIMESTAMP(6)    NOT NULL,
  ERROR_CODE            VARCHAR2(30)    NOT NULL,
  ERROR_REASON          VARCHAR2(255)   NOT NULL,
  ERROR_TEXT            VARCHAR2(4000),
  MESSAGE               BLOB            NOT NULL,
  RESEND_CONN_FACT      VARCHAR2(255),
  RESEND_PROV_URL       VARCHAR2(255),
  RESEND_DESTINATION    VARCHAR2(255)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX PK_EXCEPTIONLOG ON EXCEPTIONLOG
(LOGID)
LOGGING
NOPARALLEL;

ALTER TABLE EXCEPTIONLOG ADD (
  CONSTRAINT PK_EXCEPTIONLOG
 PRIMARY KEY
 (LOGID));

---------------------------------------------------
--   CREATE TABLE AUDITLOG
---------------------------------------------------

CREATE TABLE AUDITLOG
(
  LOGID					NUMBER(10)		NOT NULL,
  MESSAGEID				VARCHAR2(255)	NOT NULL,
  CONVERSATIONID		VARCHAR2(255),
  CPAID					VARCHAR2(255),
  BUSINESSDOMAIN		VARCHAR2(30),
  SERVICENAME			VARCHAR2(255),
  SERVICECONTEXT		VARCHAR2(255),
  SERVICECONTEXTVERSION	NUMBER(3),
  OPERATIONNAME			VARCHAR2(255),
  OPERATIONVERSION		NUMBER(3),
  APPLICATIONNAME		VARCHAR2(255),
  APPLICATIONFUNCTION	VARCHAR2(255),
  LOG_TIMESTAMP			TIMESTAMP(6)	NOT NULL,
  SENDERID				VARCHAR2(255),
  CRE_TIMESTAMP			TIMESTAMP(6)	NOT NULL,
  MESSAGE				BLOB			NOT NULL,
  TYPE					VARCHAR2(30)	NOT NULL,
  FUNCT_CALLID			VARCHAR2(255),
  LABEL					VARCHAR2(255),
  FUNCT_ERROR_CODE		VARCHAR2(30),
  FUNCT_ERROR_REASON	VARCHAR2(255),
  FUNCT_ERROR_TEXT		VARCHAR2(4000)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX PK_AUDITLOG ON AUDITLOG
(LOGID)
LOGGING
NOPARALLEL;

ALTER TABLE AUDITLOG ADD (
  CONSTRAINT PK_AUDITLOG
 PRIMARY KEY
 (LOGID));

--------------------------------------------------------
--  CREATE SEQUENCE SEQ_LOG
--------------------------------------------------------

CREATE SEQUENCE SEQ_LOG
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;

---------------------------------------------------
--   CREATE TABLE AUTHORISATION
---------------------------------------------------

CREATE TABLE AUTHORISATION
(
  BUSINESSDOMAIN	VARCHAR2(30),
  SERV_APPL_NAME	VARCHAR2(255),
  ROLE				VARCHAR2(255),
  CLAIM_ROLE		VARCHAR2(255)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


---------------------------------------------------
--   CREATE TABLE IBISCONFIG
---------------------------------------------------

CREATE TABLE IBISCONFIG
(
  NAME              VARCHAR2(100 CHAR),
  CONFIG            BLOB,
  CRE_TYDST         TIMESTAMP (6),
  RUSER             VARCHAR2(32 CHAR),
  VERSION           VARCHAR2(50 CHAR),
  FILENAME          VARCHAR2(150 CHAR),
  ACTIVECONFIG      NUMBER(1,0),
  AUTORELOAD        NUMBER(1,0)
);
---------------------------------------------------
--   CREATE TABLE IBISPROP
---------------------------------------------------

CREATE TABLE IBISPROP
(
  NAME              VARCHAR(100) NOT NULL,
  VALUE             VARCHAR(100),
  LASTMODDATE       TIMESTAMP,
  LASTMODBY         VARCHAR(100)
);




 
commit;
exit