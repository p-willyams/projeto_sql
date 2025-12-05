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

usuarios = usuarios.rename(columns={'estado': 'cidade1', 'cidade': 'estado'})
usuarios = usuarios.rename(columns={'cidade1': 'cidade'})

vendas['valor_compra'] = (vendas['valor_compra']
                          .str.replace('.', '', regex=False)
                          .str.replace(',', '.', regex=False))
vendas['quantidade'] = pd.to_numeric(vendas['quantidade'], errors='coerce').astype('Int64')

produtos['valor_produto'] = (produtos['valor_produto']
                             .str.replace('.', '', regex=False)
                             .str.replace(',', '.', regex=False))
produtos['cod_produto'] = pd.to_numeric(produtos['cod_produto'], errors='coerce').astype('Int64')

usuarios = usuarios[usuarios['cod_usuario'] != '10938']
vendas = vendas[vendas['cod_usuario'] != '10938']

produtos.to_csv('data/produtos.csv', index=False)
vendas.to_csv('data/vendas.csv', index=False)
usuarios.to_csv('data/usuarios.csv', index=False)



