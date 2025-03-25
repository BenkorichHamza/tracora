--
-- File generated with SQLiteStudio v3.2.1 on Fri Mar 14 12:45:33 2025
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: brand
CREATE TABLE brand (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    slug  TEXT,
    img   STRING
);


-- Table: cart
CREATE TABLE cart (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER REFERENCES product (id) 
                       UNIQUE ON CONFLICT REPLACE,
    price      REAL,
    total      REAL,
    topay      REAL,
    qte        REAL    DEFAULT (1) 
);


-- Table: category
CREATE TABLE category (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    title       TEXT,
    description TEXT,
    slug        TEXT,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER,
    img         STRING,
    [order]     INTEGER
);


-- Table: image
CREATE TABLE image (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    img        BLOB,
    created_at INTEGER,
    updated_at INTEGER,
    deleted_at INTEGER,
    deleted    BOOLEAN
);


-- Table: location
CREATE TABLE location (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT,
    adddress    TEXT,
    description TEXT,
    slug        TEXT,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER,
    deleted     BOOLEAN
);


-- Table: money_transaction
CREATE TABLE money_transaction (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    amount      INTEGER,
    type        TEXT,
    employee_id INTEGER REFERENCES employee (id),
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER
);


-- Table: product
CREATE TABLE product (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    alert       DOUBLE,
    name        TEXT,
    code        TEXT,
    barcode     TEXT,
    description TEXT,
    unity       STRING,
    brand_id    INTEGER REFERENCES brand (id),
    packaging   INTEGER,
    buyPrice    REAL,
    createdAt   INTEGER,
    updatedAt   INTEGER,
    deletedAt   INTEGER,
    deteled     BOOLEAN,
    sellPrice   DOUBLE,
    img         STRING
);


-- Table: product_category
CREATE TABLE product_category (
    product_id  INTEGER REFERENCES product (id),
    category_id INTEGER REFERENCES category (id) 
);


-- Table: product_transaction
CREATE TABLE product_transaction (
    transaction_id INTEGER REFERENCES stock_transaction (id),
    product_id     INTEGER REFERENCES product (id),
    location_id    INTEGER REFERENCES location (id),
    direction      INTEGER,
    qte            REAL,
    total          REAL,
    topay          REAL,
    tax            REAL,
    created_at     INTEGER
);


-- Table: stock_transaction
CREATE TABLE stock_transaction (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id     INTEGER REFERENCES employee (id),
    transactionType TEXT,
    topay           REAL,
    total           REAL,
    tax             REAL,
    createdAt       INTEGER,
    updatedAt       INTEGER,
    deletedAt       INTEGER
);


-- Table: user
CREATE TABLE user (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    firstName   TEXT,
    lastName    TEXT,
    address     TEXT,
    phone       TEXT,
    fax         TEXT,
    fix         TEXT,
    email       TEXT,
    companyName TEXT,
    updatedAt   INTEGER,
    createdAt   INTEGER,
    deletedAt   INTEGER,
    code        TEXT,
    deleted     BOOLEAN,
    nif         STRING,
    nis         STRING,
    nin         STRING,
    password    STRING,
    img         STRING
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
