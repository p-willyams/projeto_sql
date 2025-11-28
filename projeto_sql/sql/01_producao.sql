CREATE DATABASE producao;
\c producao;

-- TABELA PRODUTOS
CREATE TABLE produtos (
    cod_produto INT PRIMARY KEY,
    nome_produto VARCHAR(200),
    categoria_produto VARCHAR(100),
    valor_produto NUMERIC(10,2)
);

-- TABELA USUARIOS
CREATE TABLE usuarios (
    cod_usuario INT PRIMARY KEY,
    data_cadastro DATE,
    faixa_etaria VARCHAR(50),
    cidade VARCHAR(100),
    estado VARCHAR(2)
);


-- TABELA VENDAS
CREATE TABLE vendas (
    id_venda SERIAL PRIMARY KEY,
    cod_usuario INT REFERENCES usuarios(cod_usuario),
    cod_produto INT REFERENCES produtos(cod_produto),
    data_compra TIMESTAMP,
    forma_pagamento VARCHAR(50),
    quantidade INT,
    valor_compra NUMERIC(10,2),
    data_prevista_entrega DATE,
    data_entrega DATE
);


-- IMPORTAÇÃO DOS CSVs
COPY produtos
FROM '../data/produtos.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY usuarios
FROM '../data/usuarios.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';

COPY vendas(cod_usuario,cod_produto,data_compra,forma_pagamento,quantidade,valor_compra,data_prevista_entrega,data_entrega)
FROM '../data/vendas.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';
