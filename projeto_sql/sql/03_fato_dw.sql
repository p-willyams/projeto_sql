\c homologacao_dw;

CREATE TABLE fato_vendas (
    sk_fato SERIAL PRIMARY KEY,
    sk_usuario INT REFERENCES dim_usuario(sk_usuario),
    sk_produto INT REFERENCES dim_produto(sk_produto),
    sk_tempo INT REFERENCES dim_tempo(sk_tempo),
    quantidade INT,
    valor_compra NUMERIC(10,2),
    forma_pagamento VARCHAR(50)
);
