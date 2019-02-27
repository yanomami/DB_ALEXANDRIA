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
  id_genre int identity,
  description nvarchar(255) not null,
  constraint genre_pk
    primary key nonclustered (id_genre)
)
go

create table product
(
  id_product int identity,
  name nvarchar(255) not null,
  stock int not null,
  price_ex_vat decimal(19,4) not null,
  picture varbinary(max),
  constraint product_pk
    primary key nonclustered (id_product)
)
go

create table country
(
  id_country int identity,
  description nvarchar(255) not null,
  constraint country_pk
    primary key nonclustered (id_country)
)
go

create table order_line_status
(
  id_order_line_status int identity,
  description nvarchar(255) not null,
  constraint order_line_status_pk
    primary key nonclustered (id_order_line_status)
)
go

create table category
(
  id_category int identity,
  description nvarchar(255) not null,
  parent int default 1 not null,
  constraint category_pk
    primary key nonclustered (id_category),
  constraint category_category_id_category_fk
    foreign key (parent) references category
)
go

create table payment_method
(
  id_payment_method int identity,
  description varchar(255) not null,
  constraint payment_method_pk
    primary key nonclustered (id_payment_method)
)
go

create table publisher
(
  id_publisher int identity,
  name nvarchar(255) not null,
  constraint publisher_pk
    primary key nonclustered (id_publisher)
)
go

create table author
(
  id_author int identity,
  name nvarchar(255) not null,
  surname nvarchar(255),
  bio text,
  constraint author_pk
    primary key nonclustered (id_author)
)
go

create table collection
(
  id_collection int identity,
  description nvarchar(255) not null,
  constraint collection_pk
    primary key nonclustered (id_collection)
)
go

create table shipping_method
(
  id_shipping_method int identity,
  description nvarchar(255) not null,
  charges decimal(19,4) not null,
  constraint shipping_method_pk
    primary key nonclustered (id_shipping_method)
)
go

create table order_status
(
  id_order_status int identity,
  description nvarchar(255) not null,
  constraint order_status_pk
    primary key nonclustered (id_order_status)
)
go

create table address
(
  id_address int identity,
  address_line_1 nvarchar(255) not null,
  address_line_2 nvarchar(255),
  city nvarchar(255) not null,
  state nvarchar(45),
  postal_code nvarchar(10) not null,
  country_id int not null,
  constraint address_pk
    primary key nonclustered (id_address),
  constraint address_country_id_country_fk
    foreign key (country_id) references country
)
go

create table product_category
(
  category_id int not null,
  product_id int not null,
  constraint product_category_pk
    primary key nonclustered (category_id, product_id),
  constraint product_category_category_id_category_fk
    foreign key (category_id) references category,
  constraint product_category_product_id_product_fk
    foreign key (product_id) references product
)
go

create table book
(
  id_book int identity,
  isbn nvarchar(13) not null,
  title nvarchar(255) not null,
  nb_pages int,
  product_id int not null,
  author_id int not null,
  publisher_id int not null,
  collection_id int not null,
  constraint book_pk
    primary key nonclustered (id_book),
  constraint book_author_id_author_fk
    foreign key (author_id) references author,
  constraint book_collection_id_collection_fk
    foreign key (collection_id) references collection,
  constraint book_product_id_product_fk
    foreign key (product_id) references product,
  constraint book_publisher_id_publisher_fk
    foreign key (publisher_id) references publisher
)
go

create unique index book_product_id_uindex
  on book (product_id)
go

create table client
(
  id_client int identity,
  email nvarchar(255) not null,
  sti_id___________________ int not null,
  name nvarchar(255) not null,
  surname nvarchar(255),
  phone nvarchar(255),
  invoice_address_id int not null,
  delivery_address_id int not null,
  password nvarchar(255) not null,
  payment_method_id int not null,
  constraint client_pk
    primary key nonclustered (id_client),
  constraint client_address_id_address__invoice_fk
    foreign key (invoice_address_id) references address,
  constraint client_address_id_address__delivery_fk
    foreign key (delivery_address_id) references address,
  constraint client_payment_method_id_payment_method_fk
    foreign key (payment_method_id) references payment_method
)
go

create table book_genre
(
  book_id int not null,
  genre_id int not null,
  constraint book_genre_pk
    primary key nonclustered (book_id, genre_id),
  constraint book_genre_book_id_book_fk
    foreign key (book_id) references book,
  constraint book_genre_genre_id_genre_fk
    foreign key (genre_id) references genre
)
go

create table order_header
(
  id_order_header int identity,
  date_placed date not null,
  date_shipped date,
  date_delivered date,
  comment text,
  client_id int not null,
  order_status_id int not null,
  shipping_method_id int not null,
  constraint order_header_pk
    primary key nonclustered (id_order_header),
  constraint order_header_client_id_client_fk
    foreign key (client_id) references client,
  constraint order_header_order_status_id_order_status_fk
    foreign key (order_status_id) references order_status,
  constraint order_header_shipping_method_id_shipping_method_fk
    foreign key (shipping_method_id) references shipping_method
)
go

create table order_line
(
  id_order_line int identity,
  quantity int not null,
  order_line_status_id int not null,
  order_header_id int not null,
  product_id int not null,
  constraint order_line_pk
    primary key nonclustered (id_order_line),
  constraint order_line_order_header_id_order_header_fk
    foreign key (order_header_id) references order_header,
  constraint order_line_order_line_status_id_order_line_status_fk
    foreign key (order_line_status_id) references order_line_status,
  constraint order_line_product_id_product_fk
    foreign key (product_id) references product
)
go
