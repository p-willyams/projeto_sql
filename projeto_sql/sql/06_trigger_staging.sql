\c producao;

-- Criar staging no DW
CREATE TABLE IF NOT EXISTS homologacao_dw.public.vendas_staging (
    cod_usuario INT,
    cod_produto INT,
    data_compra TIMESTAMP,
    forma_pagamento VARCHAR(50),
    quantidade INT,
    valor_compra NUMERIC(10,2),
    data_prevista_entrega DATE,
    data_entrega DATE
);

CREATE OR REPLACE FUNCTION trig_staging_vendas()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO homologacao_dw.public.vendas_staging
    VALUES (
        NEW.cod_usuario,
        NEW.cod_produto,
        NEW.data_compra,
        NEW.forma_pagamento,
        NEW.quantidade,
        NEW.valor_compra,
        NEW.data_prevista_entrega,
        NEW.data_entrega
    );
    RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER tg_vendas_staging
AFTER INSERT ON vendas
FOR EACH ROW
EXECUTE FUNCTION trig_staging_vendas();
