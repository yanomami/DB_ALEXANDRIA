drop database IF EXISTS DB_STARFOOD
go
-- rien
create database DB_STARFOOD collate French_CI_AS
go

USE DB_STARFOOD

create table country
(
    country_id       int identity
        constraint country_pk
            primary key nonclustered,
    country_sequence int
        constraint DF__country__country__37703C52 default 10 not null,
    country_ISO nvarchar(3) not null
)
go

create table company
(
    company_id           int           not null
        constraint company_pk
            primary key nonclustered,
    company_name         nvarchar(255) not null,
    company_address_1    nvarchar(255) not null,
    company_address_2    nvarchar(255),
    company_postal_code  nvarchar(10),
    country_id           int           not null
        constraint company_country_country_id_fk
            references country,
    company_phone_number nvarchar(255) not null,
    company_email        nvarchar(255) not null
)
go

create table lang
(
    lang_id                int identity
        constraint lang_pk
            primary key nonclustered,
    lang_short_description nvarchar(50)   not null,
)
go

create table country_lang
(
    country_id                     int not null
        constraint country_lang_country_country_id_fk
            references country,
    lang_id                        int not null
        constraint country_lang_lang_lang_id_fk
            references lang,
    country_lang_short_description int not null,
    constraint country_lang_pk
        primary key nonclustered (country_id, lang_id)
)
go

create table element_lang
(
    element_id                    int                                   not null,
    lang_id                       int                                   not null
        constraint element_lang_lang_lang_id_fk
            references lang,
    element_lang_long_description nvarchar(255)
        constraint DF__element_l__eleme__3C34F16F default 'non traduit' not null,
    constraint element_lang_pk
        primary key nonclustered (element_id, lang_id)
)
go

create table location
(
    location_id                int identity
        constraint location_pk
            primary key nonclustered,
    location_short_description nvarchar(50)
)
go

create table offer
(
    offer_id               int identity
        constraint offer_pk
            primary key nonclustered,
    product_id             int   not null,
    offer_start_date       date  not null,
    offer_discounted_price float not null,
    offer_end_date         date  not null
)
go

create table offer_lang
(
    offer_id                     int           not null
        constraint offer_lang_offer_offer_id_fk
            references offer,
    lang_id                      int           not null
        constraint offer_lang_lang_lang_id_fk
            references lang,
    offer_lang_short_description nvarchar(255) not null,
    offer_lang_long_description  text          not null,
    constraint offer_lang_pk
        primary key nonclustered (offer_id, lang_id)
)
go

create table order_status
(
    order_status_id                int identity          not null
        constraint order_status_pk
            primary key nonclustered,
    order_status_short_description nvarchar(255) not null
)
go

create table origin
(
    origin_id                int identity           not null
        constraint origine_pk
            primary key nonclustered,
    origin_short_description nvarchar(255) not null
)
go

create table payment_method
(
    payment_method_id                int identity not null
        constraint payment_method_pk
            primary key nonclustered,
    payment_method_short_description nvarchar(255)
)
go

create table product_type
(
    product_type_id                int identity          not null
        constraint product_type_pk
            primary key nonclustered,
    product_type_short_description nvarchar(255) not null
)
go

create table role
(
    role_id                int identity
        constraint role_pk
            primary key nonclustered,
    role_short_description nvarchar(50) not null
)
go

create table status
(
    status_id                int identity
        constraint status_pk
            primary key nonclustered,
    status_short_description nvarchar(50) not null
)
go

create table category
(
    category_id     int identity
        constraint category_pk
            primary key nonclustered,
/*    category_parent int
        constraint DF__category__catego__06CD04F7 default 1,*/
    status_id       int not null
        constraint category_status_status_id_fk
            references status
)
go

create table category_lang
(
    category_id int not null
        constraint category_lang_category_category_id_fk
            references category,
    lang_id     int not null
        constraint category_lang_lang_lang_id_fk
            references lang,
    constraint category_lang_pk
        primary key nonclustered (category_id, lang_id)
)
go

create table tva
(
    tva_id                int identity          not null
        constraint tva_pk
            primary key nonclustered,
    tva_short_description nvarchar(255) not null,
    tva_rate              float         not null
)
go

create table product
(
    product_id      int identity
        constraint product_pk
            primary key nonclustered,
    product_price   decimal(7, 2) not null,
    tva_id          int           not null
        constraint product_tva_tva_id_fk
            references tva,
    status_id       int           not null
        constraint product_status_status_id_fk
            references status,
    category_id     int           not null
        constraint product_category_category_id_fk
            references category,
    product_type_id int           not null
        constraint product_product_type_product_type_id_fk
            references product_type
)
go

create table menu
(
    menu_id   int not null
        constraint menu_pk
            primary key nonclustered,
    menu_main int not null
        constraint menu_product_product_id_fk
            references product
)
go

create table product_lang
(
    product_id                     int                                 not null
        constraint product_lang_product_product_id_fk
            references product,
    lang_id                        int                                 not null
        constraint product_lang_lang_lang_id_fk
            references lang,
    product_lang_short_description nvarchar(255)                       not null,
    product_lang_long_description  text
        constraint DF__product_l__produ__3E1D39E1 default 'à venir...' not null,
    constraint product_lang_pk
        primary key nonclustered (product_id, lang_id)
)
go

create table recipe
(
    product_id           int not null
        constraint recipe_product_product_id_fk
            references product,
    recipe_quantity      int not null,
    product_id_component int not null
        constraint recipe_product_product_id_fk_2
            references product,
    constraint recipe_pk
        primary key nonclustered (product_id, product_id_component)
)
go

create table stock
(
    product_id     int                                      not null
        constraint stock_product_product_id_fk
            references product,
    location_id    int                                      not null
        constraint stock_location_location_id_fk
            references location,
    stock_quantity int
        constraint DF__stock__stock_qua__47A6A41B default 0 not null,
    constraint stock_pk
        primary key nonclustered (product_id, location_id)
)
go

create table [user]
(
    user_id int identity
        constraint user_pk
            primary key nonclustered,
    user_firstname nvarchar(255) not null,
    user_lastname nvarchar(255) not null,
    user_email nvarchar(255) not null
        constraint user_pk_2
            unique,
    user_phone nvarchar(50) not null,
    role_id int not null
        constraint user_role_role_id_fk
            references role,
    status_id int not null
        constraint user_status_status_id_fk
            references status,
    user_password nvarchar(50)
)
go

create unique index user_user_email_uindex
    on [user] (user_email)
go

create unique index user_user_phone_uindex
    on [user] (user_phone)
go

create table address
(
    address_id int identity
        constraint address_pk
            primary key nonclustered,
    address_line_1 nvarchar(255) not null,
    address_line_2 nvarchar(255),
    address_postal_code nvarchar(10) not null,
    address_city nvarchar(255) not null,
    country_id int not null
        constraint address_country_country_id_fk
            references country,
    user_id int not null
        constraint address_user_user_id_fk
            references [user]
)
go

create table [order]
(
    order_id          int identity
        constraint order_pk
            primary key nonclustered,
    user_id_customer  int                                   not null
        constraint order_user_user_id_fk
            references [user],
    order_weigth      int
        constraint DF__order__order_wei__3F115E1A default 1 not null,
    origin_id         int                                   not null
        constraint order_origine_origine_id_fk
            references origin,
    user_id_origin    int                                   not null
        constraint order_user_user_id_fk_2
            references [user],
    payment_method_id int
        constraint order_payment_method_payment_method_id_fk
            references payment_method,
    order_status_id   int                                   not null
        constraint order_order_status_order_status_id_fk
            references order_status
)
go

create table order_line
(
    order_id            int not null
        constraint order_line_order_order_id_fk
            references [order],
    product_id          int not null,
    order_line_number   int not null,
    order_line_quantity int not null,
    status_id           int not null
        constraint order_line_status_status_id_fk
            references status,
    order_line_type     int,
    order_line_is_free  bit
        constraint DF__order_lin__order__44CA3770 default 0,
    constraint order_line_pk
        primary key nonclustered (order_id, order_line_number)
)
go

-- alimenttaion
--ROLE
delete
from role
where 1 = 1;
insert into role
values ('admin'),
       ('kitchen'),
       ('client');
--COUNTRY
delete
from country
where 1 = 1;
insert into country
values (1, 'FR'),
       (2, 'BE');
--COMPANY
delete
from company
where 1 = 1;
insert into company
values (1, 'StarFood', '32 rue du Gras', ' ', '75012', 1, '0664928007', 'starfood@kymryd.com');
--LANG
delete
from lang
where 1 = 1;
insert into lang
values ('French'),
       ('English');
--LOCATION
delete
from location
where 1 = 1;
insert into location
values ('RESERVE'),
       ('CUISINE'),
       ('COMPTOIR'),
       ('CLIENT');
--ORIGIN
delete
from origin
where 1 = 1;
insert into origin
values ('borne');
--PAYMENT_METHOD
delete
from payment_method
where 1 = 1;
insert into payment_method
values ('CB');
--STATUS
delete
from status
where 1 = 1;
insert into status
values ('active'),
       ('inactive');
--TVA
delete
from tva
where 1 = 1;
insert into TVA
values ('taux plein', 20),
       ('taux réduit', 7);
--ORDER STATUS
delete
from order_status
where 1 = 1;
insert into order_status
values ('pending'),
       ('processing'),
       ('delivered'),
       ('backorder');
