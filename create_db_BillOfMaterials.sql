/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     2017-02-15 21:38:25                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BOM') and o.name = 'FK_BOM_REFERENCE_PRODUCT')
alter table BOM
   drop constraint FK_BOM_REFERENCE_PRODUCT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BOM') and o.name = 'FK_BOM_REFERENCE_MATERIAL')
alter table BOM
   drop constraint FK_BOM_REFERENCE_MATERIAL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OTHER_EXPENCES') and o.name = 'FK_OTHER_EX_REFERENCE_PRODUCT')
alter table OTHER_EXPENCES
   drop constraint FK_OTHER_EX_REFERENCE_PRODUCT
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('OTHER_EXPENCES') and o.name = 'FK_OTHER_EX_REFERENCE_EXPENCES')
alter table OTHER_EXPENCES
   drop constraint FK_OTHER_EX_REFERENCE_EXPENCES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PRICE_LIST') and o.name = 'FK_PRICE_LI_REFERENCE_MATERIAL')
alter table PRICE_LIST
   drop constraint FK_PRICE_LI_REFERENCE_MATERIAL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BOM')
            and   type = 'U')
   drop table BOM
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EXPENCES')
            and   name  = 'IDX_EXPRENCE_UQ'
            and   indid > 0
            and   indid < 255)
   drop index EXPENCES.IDX_EXPRENCE_UQ
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EXPENCES')
            and   type = 'U')
   drop table EXPENCES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('MATERIALS')
            and   name  = 'IDX_MATERIALS_UQ'
            and   indid > 0
            and   indid < 255)
   drop index MATERIALS.IDX_MATERIALS_UQ
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MATERIALS')
            and   type = 'U')
   drop table MATERIALS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OTHER_EXPENCES')
            and   type = 'U')
   drop table OTHER_EXPENCES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PRICE_LIST')
            and   type = 'U')
   drop table PRICE_LIST
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PRODUCT')
            and   name  = 'IDX_PRODUCT_UQ'
            and   indid > 0
            and   indid < 255)
   drop index PRODUCT.IDX_PRODUCT_UQ
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PRODUCT')
            and   type = 'U')
   drop table PRODUCT
go

/*==============================================================*/
/* Table: BOM                                                   */
/*==============================================================*/
create table BOM (
   PRODUCT_ID           numeric              not null,
   MATERIAL_ID          numeric              not null,
   BOM_QTY              numeric(10,3)        not null,
   constraint PK_BOM primary key (PRODUCT_ID, MATERIAL_ID)
)
go

/*==============================================================*/
/* Table: EXPENCES                                              */
/*==============================================================*/
create table EXPENCES (
   EXPENCE_ID           numeric              not null,
   EXPENCE_NAME         varchar(20)          not null,
   constraint PK_EXPENCES primary key (EXPENCE_ID)
)
go

/*==============================================================*/
/* Index: IDX_EXPRENCE_UQ                                       */
/*==============================================================*/
create unique index IDX_EXPRENCE_UQ on EXPENCES (
EXPENCE_NAME ASC
)
go

/*==============================================================*/
/* Table: MATERIALS                                             */
/*==============================================================*/
create table MATERIALS (
   MATERIAL_ID          numeric              not null,
   MATERIAL_NAME        varchar(50)          not null,
   MATERIAL_DESCRIPTION varchar(400)         null,
   MATERIAL_MEASURE     varchar(20)          null,
   constraint PK_MATERIALS primary key (MATERIAL_ID)
)
go

/*==============================================================*/
/* Index: IDX_MATERIALS_UQ                                      */
/*==============================================================*/
create unique index IDX_MATERIALS_UQ on MATERIALS (
MATERIAL_NAME ASC
)
go

/*==============================================================*/
/* Table: OTHER_EXPENCES                                        */
/*==============================================================*/
create table OTHER_EXPENCES (
   PRODUCT_ID           numeric              not null,
   EXPENCE_ID           numeric              not null,
   EXPRENCE_VALUE       numeric(10,2)        not null,
   constraint PK_OTHER_EXPENCES primary key (PRODUCT_ID, EXPENCE_ID)
)
go

/*==============================================================*/
/* Table: PRICE_LIST                                            */
/*==============================================================*/
create table PRICE_LIST (
   MATERIAL_ID          numeric              not null,
   PRICE_DATE           date                 not null,
   PRICE_PRICE          numeric(10,2)        not null,
   constraint PK_PRICE_LIST primary key (MATERIAL_ID, PRICE_DATE, PRICE_PRICE)
)
go

/*==============================================================*/
/* Table: PRODUCT                                               */
/*==============================================================*/
create table PRODUCT (
   PRODUCT_ID           numeric              not null,
   PRODUCT_NAME         varchar(50)          not null,
   PRODUCT_DESCRIPTION  varchar(100)         null,
   constraint PK_PRODUCT primary key (PRODUCT_ID)
)
go

/*==============================================================*/
/* Index: IDX_PRODUCT_UQ                                        */
/*==============================================================*/
create unique index IDX_PRODUCT_UQ on PRODUCT (
PRODUCT_NAME ASC
)
go

alter table BOM
   add constraint FK_BOM_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (PRODUCT_ID)
go

alter table BOM
   add constraint FK_BOM_REFERENCE_MATERIAL foreign key (MATERIAL_ID)
      references MATERIALS (MATERIAL_ID)
go

alter table OTHER_EXPENCES
   add constraint FK_OTHER_EX_REFERENCE_PRODUCT foreign key (PRODUCT_ID)
      references PRODUCT (PRODUCT_ID)
go

alter table OTHER_EXPENCES
   add constraint FK_OTHER_EX_REFERENCE_EXPENCES foreign key (EXPENCE_ID)
      references EXPENCES (EXPENCE_ID)
go

alter table PRICE_LIST
   add constraint FK_PRICE_LI_REFERENCE_MATERIAL foreign key (MATERIAL_ID)
      references MATERIALS (MATERIAL_ID)
go

