import pandas as pd


def ler_csv_corrigido(arquivo, encoding='latin1'):
    with open(arquivo, 'r', encoding=encoding) as f:
        linhas = f.readlines()
    
    dados_processados = []
    for linha in linhas:
        linha = linha.strip()
        if linha:
            linha = linha.strip('"')
            colunas = linha.split(';')
            dados_processados.append(colunas)
    
    if dados_processados:
        df = pd.DataFrame(dados_processados[1:], columns=dados_processados[0])
        return df
    return pd.DataFrame()


produtos= ler_csv_corrigido('data/produtos.csv')
vendas = ler_csv_corrigido('data/vendas.csv')
usuarios = ler_csv_corrigido('data/usuarios.csv')

usuarios = usuarios.rename(columns={'cidade': 'estado', 'estado': 'cidade'})
usuarios['data_cadastro'] = pd.to_datetime(usuarios['data_cadastro'])

vendas['valor_compra'] = vendas['valor_compra'].str.replace(',', '.', regex=False).astype(float)
vendas['data_prevista_entrega'] = pd.to_datetime(vendas['data_prevista_entrega'], errors='coerce')
vendas['data_entrega'] = pd.to_datetime(vendas['data_entrega'], errors='coerce')
vendas['data_compra'] = pd.to_datetime(vendas['data_compra'], errors='coerce')
vendas['quantidade'] = pd.to_numeric(vendas['quantidade'], errors='coerce').astype('Int64')

produtos['valor_produto'] = produtos['valor_produto'].str.replace(',', '.', regex=False).astype(float)
produtos['cod_produto'] = pd.to_numeric(produtos['cod_produto'], errors='coerce').astype('Int64')

produtos.to_csv('data/produtos.csv', index=False)
vendas.to_csv('data/vendas.csv', index=False)
usuarios.to_csv('data/usuarios.csv', index=False)
