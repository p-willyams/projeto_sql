CREATE OR REPLACE FUNCTION trig_staging_vendas()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec(
        'host=localhost dbname=homologacao_dw user=postgres password=sua_senha',
        format(
            $sql$
            INSERT INTO vendas_staging
            VALUES (%s, %s, '%s', '%s', %s, %s, '%s', '%s')
            $sql$,
            NEW.cod_usuario,
            NEW.cod_produto,
            NEW.data_compra,
            NEW.forma_pagamento,
            NEW.quantidade,
            NEW.valor_compra,
            NEW.data_prevista_entrega,
            NEW.data_entrega
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;