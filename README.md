![image](https://github.com/alfatharr/Sales-Dashboard-Report/assets/156917349/b699fd93-ea65-4fcc-bdcc-2d8d68f7d88a)# Sales Dashboard Report

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
---
## 2. Relasi Antartabel
Relasi antartabel dimaksudkan untuk mengetahui bagaimana hubungan dari suatu tabel ke tabel lainnya melalui minimal satu kolom yang valuenya sama-sama ada pada kedua tabel. Constraint yang kita gunakan adalah **foreign key**, yaitu pengenal unique yang menghubungkan kedua tabel.<br>

| No | Tabel                  |  Foreign Key       |
| -- | --------------------   | ------------------ |
| 1  | cutsomers dan orders   | 'cust_id'          |
| 2  | orders dan products    | 'order_id'         |
| 3  | products dan category  | 'product_cat'      |

Berikut ini adalah Entity Relationship Diagram berdasarkan foreign key yang telah kita buat.
![image](https://github.com/alfatharr/Sales-Dashboard-Report/assets/156917349/ccb1683d-2f07-4527-863a-4e5fb3de6044)
Bisa kita lihat pada ERD tersebut bahwa keempat tabel memiliki hubungan one-to-many, artinya setiap satu entitas dapat terhubung dengan banyak entitas lainnya.
---
## 3. Tabel Master
Tabel master digunakan untuk membuat visualisasi di Looker. Berikut ini adalah query yang digunakan untuk membuat tabel master tersebut.
```
SELECT 	o.order_date,	
	ct.category_name,	
	p.product_name,	
	p.product_price,	
	o.order_qty,			p.product_price * o.order_qty AS total_sales,	cs.email,	
	cs.city
FROM orders o 
JOIN customers cs ON cs.cust_id = o.cust_id	
JOIN products p ON p.product_id = o.product_id
JOIN category ct ON ct.product_cat = p.product_cat
ORDER BY o.order_date ASC
```

Dari query tabel master di atas akan menghasilkan tabel sebagai berikut.
![image](https://github.com/alfatharr/Sales-Dashboard-Report/assets/156917349/25fdd227-a1a2-48bf-b153-7188b4c44613)
---
## 4. Visualisasi
Visualisasi data merupakan alat yang kuat untuk mempermudah pemahaman data. Dengan mengubah data yang kompleks menjadi bentuk visual seperti grafik, diagram, peta, dan infografik, kita dapat lebih cepat dan lebih mudah memahami informasi.<br>

Berikut ini adalah sales dashboard yang telah dibuat di Google Looker.
![image](https://github.com/alfatharr/Sales-Dashboard-Report/assets/156917349/99713a19-5c9a-4fcf-b42e-cdb0768a51dd)
---
## 5. Insight dan Business Recommendations
<br>
**Insight**
Dari visualisasi pada Looker, berikut ini adalah insight yang berhasil didapatkan.
| No | Insight                                                                                                                      |  
| -- | --------------------------------------------------------------------------------------------------------------------------   | 
| 1  | Total penjualan ebooks terbanyak dari semua kategori produk, namun hanya menghasilkan keuntungan 3%                          | 
| 2  | Total penjualan robot termasuk dua terbawah, namun menghasilkan keuntungan paling besar sebanyak 42% dari total sales        |
| 3  | Kota Washington menjadi penyumbang total sales terbesar dari keseluruhan kota di Amerika                                     |
| 4  | Berdasarkan garis tren order, dari Januari 2020 sampai Desember 2021 mengalami penurunan, sehingga total sales ikut turun    |
| 5  | Di antara semua produk yang mengalami penurunan penjualan, hanya training videos saja yang mengalami peningkatan penjualan   |
| 6  | Top 5 produk yang diorder pelanggan yaitu eBooks, training videos, blueprint, drone kits, dan drones                         |
| 7  | Top 5 produk berdasarkan total sales yaitu robots, drones, robot kits, drone kits, training videos                           |
| 8  | Tidak ada pola signifikan dari total order setiap bulannya                                                                   |





