\c homologacao_dw;

CREATE OR REPLACE PROCEDURE atualizar_dw()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Limpeza
    DELETE FROM fato_vendas;
    DELETE FROM dim_usuario;
    DELETE FROM dim_produto;
    DELETE FROM dim_tempo;

    -- Dim usuario
    INSERT INTO dim_usuario (cod_usuario, data_cadastro, faixa_etaria, cidade, estado)
    SELECT cod_usuario, data_cadastro, faixa_etaria, cidade, estado
    FROM vw_usuarios_producao;

    -- Dim produto
    INSERT INTO dim_produto (cod_produto, nome_produto, categoria_produto, valor_produto)
    SELECT cod_produto, nome_produto, categoria_produto, valor_produto
    FROM vw_produtos_producao;

    -- Dim tempo
    INSERT INTO dim_tempo (data_compra, ano, mes, dia)
    SELECT DISTINCT
        DATE(data_compra),
        EXTRACT(YEAR FROM data_compra),
        EXTRACT(MONTH FROM data_compra),
        EXTRACT(DAY FROM data_compra)
    FROM vw_vendas_producao;

    -- Fato vendas
    INSERT INTO fato_vendas (sk_usuario, sk_produto, sk_tempo, quantidade, valor_compra, forma_pagamento)
    SELECT
        du.sk_usuario,
        dp.sk_produto,
        dt.sk_tempo,
        v.quantidade,
        v.valor_compra,
        v.forma_pagamento
    FROM vw_vendas_producao v
    JOIN dim_usuario du ON du.cod_usuario = v.cod_usuario
    JOIN dim_produto dp ON dp.cod_produto = v.cod_produto
    JOIN dim_tempo dt ON dt.data_compra = DATE(v.data_compra);
END $$;

-- CALL atualizar_dw();
