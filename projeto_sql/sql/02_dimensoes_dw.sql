CREATE DATABASE homologacao_dw;
\c homologacao_dw;

-- Dimensão Usuario
CREATE TABLE dim_usuario (
    sk_usuario SERIAL PRIMARY KEY,
    cod_usuario INT,
    data_cadastro DATE,
    faixa_etaria VARCHAR(50),
    cidade VARCHAR(100),
    estado VARCHAR(2)
);

-- Dimensão Produto
CREATE TABLE dim_produto (
    sk_produto SERIAL PRIMARY KEY,
    cod_produto INT,
    nome_produto VARCHAR(200),
    categoria_produto VARCHAR(100),
    valor_produto NUMERIC(10,2)
);

-- Dimensão Tempo
CREATE TABLE dim_tempo (
    sk_tempo SERIAL PRIMARY KEY,
    data_compra DATE,
    ano INT,
    mes INT,
    dia INT
);
