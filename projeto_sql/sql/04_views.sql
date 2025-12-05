\c homologacao_dw;

CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE VIEW vw_usuarios_producao AS
SELECT *
FROM dblink(
    'host=localhost port=5432 dbname=producao user=postgres password=SUA_SENHA',
    'SELECT cod_usuario, data_cadastro, faixa_etaria, cidade, estado FROM usuarios'
) AS t(
    cod_usuario INT,
    data_cadastro DATE,
    faixa_etaria VARCHAR(50),
    cidade VARCHAR(100),
    estado VARCHAR(2)
);

-- VIEW PRODUTOS
CREATE OR REPLACE VIEW vw_produtos_producao AS
SELECT *
FROM dblink(
    'host=localhost port=5432 dbname=producao user=postgres password=SUA_SENHA',
    'SELECT cod_produto, nome_produto, categoria_produto, valor_produto FROM produtos'
) AS t(
    cod_produto INT,
    nome_produto VARCHAR(200),
    categoria_produto VARCHAR(100),
    valor_produto NUMERIC
);

-- VIEW VENDAS
CREATE OR REPLACE VIEW vw_vendas_producao AS
SELECT *
FROM dblink(
    'host=localhost port=5432 dbname=producao user=postgres password=SUA_SENHA',
    'SELECT id_venda, cod_usuario, cod_produto, data_compra, forma_pagamento, quantidade,
            valor_compra, data_prevista_entrega, data_entrega FROM vendas'
) AS t(
    id_venda INT,
    cod_usuario INT,
    cod_produto INT,
    data_compra TIMESTAMP,
    forma_pagamento VARCHAR(50),
    quantidade INT,
    valor_compra NUMERIC,
    data_prevista_entrega DATE,
    data_entrega DATE
);

