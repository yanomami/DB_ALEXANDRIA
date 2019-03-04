drop database if exists DB_ALEXANDRIA
go

create database DB_ALEXANDRIA collate French_CI_AS
go

alter database DB_ALEXANDRIA set read_write with no_wait
go

use DB_ALEXANDRIA
go

create table title
(
	id_title int identity
		constraint title_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table collection
(
	id_collection int identity
		constraint collection_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table order_line_status
(
	id_order_line_status int identity
		constraint order_line_status_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table product
(
	id_product int identity
		constraint product_pk
			primary key nonclustered,
	name nvarchar(255) not null,
	stock int not null,
	price_ex_vat decimal(19,4) not null,
	picture varbinary(max)
)
go

create table publisher
(
	id_publisher int identity
		constraint publisher_pk
			primary key nonclustered,
	name nvarchar(255) not null
)
go

create table order_status
(
	id_order_status int identity
		constraint order_status_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table shipping_method
(
	id_shipping_method int identity
		constraint shipping_method_pk
			primary key nonclustered,
	description nvarchar(255) not null,
	charges decimal(19,4) not null
)
go

create table author
(
	id_author int identity
		constraint author_pk
			primary key nonclustered,
	first_name nvarchar(255) not null,
	last_name nvarchar(255),
	bio text
)
go

create table genre
(
	id_genre int identity
		constraint genre_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table country
(
	id_country int identity
		constraint country_pk
			primary key nonclustered,
	description nvarchar(255) not null
)
go

create table category
(
	id_category int identity
		constraint category_pk
			primary key nonclustered,
	description nvarchar(255) not null,
	parent int default 1
		constraint category_category_id_category_fk
			references category
)
go

create table payment_method
(
	id_payment_method int identity
		constraint payment_method_pk
			primary key nonclustered,
	description varchar(255) not null
)
go

create table book
(
	id_book int identity
		constraint book_pk
			primary key nonclustered,
	isbn nvarchar(13) not null,
	title nvarchar(255) not null,
	nb_pages int,
	product_id int not null
		constraint book_product_id_product_fk
			references product,
	author_id int not null
		constraint book_author_id_author_fk
			references author,
	publisher_id int not null
		constraint book_publisher_id_publisher_fk
			references publisher,
	collection_id int not null
		constraint book_collection_id_collection_fk
			references collection
)
go

create unique index book_product_id_uindex
	on book (product_id)
go

create table address
(
	id_address int identity
		constraint address_pk
			primary key nonclustered,
	address_line_1 nvarchar(255) not null,
	address_line_2 nvarchar(255),
	city nvarchar(255) not null,
	state nvarchar(45),
	postal_code nvarchar(10) not null,
	country_id int not null
		constraint address_country_id_country_fk
			references country
)
go

create table product_category
(
	category_id int not null
		constraint product_category_category_id_category_fk
			references category,
	product_id int not null
		constraint product_category_product_id_product_fk
			references product,
	constraint product_category_pk
		primary key nonclustered (category_id, product_id)
)
go

create table book_genre
(
	book_id int not null
		constraint book_genre_book_id_book_fk
			references book,
	genre_id int not null
		constraint book_genre_genre_id_genre_fk
			references genre,
	constraint book_genre_pk
		primary key nonclustered (book_id, genre_id)
)
go

create table client
(
	id_client int identity
		constraint client_pk
			primary key nonclustered,
	title_id int not null
		constraint client_title_id_title_fk
		references title,
	first_name nvarchar(255) not null,
	last_name nvarchar(255),
	email nvarchar(255) not null,
	phone nvarchar(255),
	password nvarchar(255) not null,
	invoice_address_id int not null
		constraint client_address_id_address__invoice_fk
			references address,
	delivery_address_id int not null
		constraint client_address_id_address__delivery_fk
			references address,
	payment_method_id int not null
		constraint client_payment_method_id_payment_method_fk
			references payment_method
)
go

create table order_header
(
	id_order_header int identity
		constraint order_header_pk
			primary key nonclustered,
	date_placed date not null,
	date_shipped date,
	date_delivered date,
	comment text,
	client_id int not null
		constraint order_header_client_id_client_fk
			references client,
	order_status_id int not null
		constraint order_header_order_status_id_order_status_fk
			references order_status,
	shipping_method_id int not null
		constraint order_header_shipping_method_id_shipping_method_fk
			references shipping_method
)
go

create table order_line
(
	id_order_line int identity
		constraint order_line_pk
			primary key nonclustered,
	quantity int not null,
	order_line_status_id int not null
		constraint order_line_order_line_status_id_order_line_status_fk
			references order_line_status,
	order_header_id int not null
		constraint order_line_order_header_id_order_header_fk
			references order_header,
	product_id int not null
		constraint order_line_product_id_product_fk
			references product
)
go

