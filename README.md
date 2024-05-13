# Sales Dashboard Report

**Tool** : PostgreSQL<br>
**Programming Language** : SQL<br>
**Visualization** : Looker<br>
**Source Dataset** : Rakamin Academy<br>
<br>

**Table of Content**
* Case Study
* Membuat database dan tabel
* Menentukan relasi antartabel
* Membuat tabel master
* Membuat visualisasi looker
* Menentukan insight dan business recomendations<br>
- - - 

## Case Study
PT Sejahtera Bersama ingin mengetahui bagaimana hasil penjualan produk mereka dari bulan Januari 2020 sampai dengan Desember 2021. Sebagai BI Analyst PT Sejahtera Bersama, diharapkan anda bisa memberi usulan terkait cara mempertahankan penjualan ataupun menaikkan penjualan dengan tabel visualisasi transaksi yang telah dibuat.

## 1. Database dan Tabel
```Creating database
CREATE DATABASE "BI Analyst "
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Indonesia.1252'
    LC_CTYPE = 'English_Indonesia.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

```Creating tables
CREATE TABLE IF NOT EXISTS public.category
(
    product_cat bigint NOT NULL,
    category_name character varying COLLATE pg_catalog."default",
    category_abb character varying COLLATE pg_catalog."default",
    CONSTRAINT category_pkey PRIMARY KEY (product_cat)
)

CREATE TABLE IF NOT EXISTS public.customers
(
    cust_id bigint NOT NULL,
    first_name character varying COLLATE pg_catalog."default",
    last_name character varying COLLATE pg_catalog."default",
    email character varying COLLATE pg_catalog."default",
    phone character varying COLLATE pg_catalog."default",
    address character varying COLLATE pg_catalog."default",
    city character varying COLLATE pg_catalog."default",
    state character varying COLLATE pg_catalog."default",
    zipcode integer,
    CONSTRAINT customers_pkey PRIMARY KEY (cust_id)
)

CREATE TABLE IF NOT EXISTS public.orders
(
    order_id bigint NOT NULL,
    order_date date,
    cust_id bigint,
    product_id character varying COLLATE pg_catalog."default",
    order_qty bigint,
    CONSTRAINT orders_pkey PRIMARY KEY (order_id),
    CONSTRAINT cust_id FOREIGN KEY (cust_id)
        REFERENCES public.customers (cust_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id)
        REFERENCES public.products (product_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

CREATE TABLE IF NOT EXISTS public.products
(
    product_id character varying COLLATE pg_catalog."default" NOT NULL,
    product_name character varying COLLATE pg_catalog."default",
    product_cat bigint,
    product_price double precision,
    CONSTRAINT products_pkey PRIMARY KEY (product_id),
    CONSTRAINT products_product_cat_fkey FOREIGN KEY (product_cat)
        REFERENCES public.category (product_cat) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
```
Setelah database dan tabel dibuat, kita bisa menentukan primary key untuk setiap tabel. Syarat untuk menentukan primary key pada suatu kolom di dalam tabel adalah merupakan nilai unique dan tidak memiliki null value. Dari query di atas kita bisa mendapatkan primary key untuk setiap tabel sebagai berikut.

| No | Tabel         |  Primary Key       |
| -- | ------------- | ------------------ |
| 1  | cutsomers     | 'cust_id'          |
| 2  | orders        | 'order_id'         |
| 3  | products      | 'product_id'       |
| 4  | category      | 'product_cat'      |

