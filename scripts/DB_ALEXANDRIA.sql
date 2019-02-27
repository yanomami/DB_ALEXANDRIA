drop database if exists DB_ALEXANDRIA
go

create database DB_ALEXANDRIA collate French_CI_AS
go

alter database DB_ALEXANDRIA set read_write with no_wait
go

use DB_ALEXANDRIA
go

create table genre
(
  id_gen int identity,
  desc_gen nvarchar(255) not null,
  constraint genre_pk
    primary key nonclustered (id_gen)
)
go

create table product
(
  id_pdt int identity,
  name_pdt nvarchar(255) not null,
  stock_pdt int not null,
  price_ex_vat_pdt decimal(19,4) not null,
  picture_pdt varbinary(max),
  constraint product_pk
    primary key nonclustered (id_pdt)
)
go

create table country
(
  id_country int identity,
  desc_country nvarchar(255) not null,
  constraint country_pk
    primary key nonclustered (id_country)
)
go

create table order_line_status
(
  id_ols int identity,
  desc_ols nvarchar(255) not null,
  constraint order_line_status_pk
    primary key nonclustered (id_ols)
)
go

create table category
(
  id_cat int identity,
  desc_cat nvarchar(255) not null,
  parent_cat int default 1 not null,
  constraint category_pk
    primary key nonclustered (id_cat),
  constraint category_category_id_cat_fk
    foreign key (parent_cat) references category
)
go

create table payment_method
(
  id_pam int identity,
  desc_pam varchar(255) not null,
  constraint payment_method_pk
    primary key nonclustered (id_pam)
)
go

create table publisher
(
  id_pub int identity,
  name_pub nvarchar(255) not null,
  constraint publisher_pk
    primary key nonclustered (id_pub)
)
go

create table author
(
  id_aut int identity,
  name_aut nvarchar(255) not null,
  surname_aut nvarchar(255),
  bio_aut text,
  constraint author_pk
    primary key nonclustered (id_aut)
)
go

create table collection
(
  id_col int identity,
  desc_col nvarchar(255) not null,
  constraint collection_pk
    primary key nonclustered (id_col)
)
go

create table shipping_method
(
  id_shm int identity,
  desc_shm nvarchar(255) not null,
  charges_shm decimal(19,4) not null,
  constraint shipping_method_pk
    primary key nonclustered (id_shm)
)
go

create table order_status
(
  id_ors int identity,
  desc_ors nvarchar(255) not null,
  constraint order_status_pk
    primary key nonclustered (id_ors)
)
go

create table address
(
  id_add int identity,
  address_line_add nvarchar(255) not null,
  postal_code_add nvarchar(10) not null,
  city_add nvarchar(255) not null,
  country_id int not null,
  state_add nvarchar(45),
  constraint address_pk
    primary key nonclustered (id_add),
  constraint address_country_id_country_fk
    foreign key (country_id) references country
)
go

create table product_category
(
  cat_id int not null,
  pdt_id int not null,
  constraint product_category_pk
    primary key nonclustered (cat_id, pdt_id),
  constraint product_category_category_id_cat_fk
    foreign key (cat_id) references category,
  constraint product_category_product_id_pdt_fk
    foreign key (pdt_id) references product
)
go

create table book
(
  id_bok int identity,
  isbn_bok nvarchar(13) not null,
  title_bok nvarchar(255) not null,
  nb_pages_bok int,
  pdt_id int not null,
  aut_id int not null,
  pub_id int not null,
  col_id int not null,
  constraint book_pk
    primary key nonclustered (id_bok),
  constraint book_author_id_aut_fk
    foreign key (aut_id) references author,
  constraint book_collection_id_col_fk
    foreign key (col_id) references collection,
  constraint book_product_id_pdt_fk
    foreign key (pdt_id) references product,
  constraint book_publisher_id_pub_fk
    foreign key (pub_id) references publisher
)
go

create unique index book_pdt_id_uindex
  on book (pdt_id)
go

create table client
(
  id_cli int identity,
  email_cli nvarchar(255) not null,
  sti_id int not null,
  name_cli nvarchar(255) not null,
  surname_cli nvarchar(255),
  phone_cli nvarchar(255),
  inv_address_cli int not null,
  del_address_cli int not null,
  password_cli nvarchar(255) not null,
  pam_id int not null,
  constraint client_pk
    primary key nonclustered (id_cli),
  constraint client_address_id_add_fk
    foreign key (inv_address_cli) references address,
  constraint client_address_id_add_fk_2
    foreign key (del_address_cli) references address,
  constraint client_payment_method_id_pam_fk
    foreign key (pam_id) references payment_method
)
go

create table book_genre
(
  bok_id int not null,
  gen_id int not null,
  constraint book_genre_pk
    primary key nonclustered (bok_id, gen_id),
  constraint book_genre_book_id_bok_fk
    foreign key (bok_id) references book,
  constraint book_genre_genre_id_gen_fk
    foreign key (gen_id) references genre
)
go

create table order_header
(
  id_orh int identity,
  orh_placed date not null,
  orh_shipped date,
  orh_delivered date,
  orh_comment text,
  cli_id int not null,
  ors_id int not null,
  shm_id int not null,
  constraint order_header_pk
    primary key nonclustered (id_orh),
  constraint order_header_client_id_cli_fk
    foreign key (cli_id) references client,
  constraint order_header_order_status_id_ors_fk
    foreign key (ors_id) references order_status,
  constraint order_header_shipping_method_id_shm_fk
    foreign key (shm_id) references shipping_method
)
go

create table order_line
(
  id_orl int identity,
  quantity_orl int not null,
  ols_id int not null,
  orh_id int not null,
  pdt_id int not null,
  constraint order_line_pk
    primary key nonclustered (id_orl),
  constraint order_line_order_header_id_orh_fk
    foreign key (orh_id) references order_header,
  constraint order_line_order_line_status_id_ols_fk
    foreign key (ols_id) references order_line_status,
  constraint order_line_product_id_pdt_fk
    foreign key (pdt_id) references product
)
go
