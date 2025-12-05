# Projeto SQL – Banco de Produção e Banco de Homologação

Este projeto implementa uma arquitetura completa contendo:

* **Banco de Produção** (OLTP)
* **Banco de Homologação** (OLAP)
* **Dimensões, Fato, Views, Trigger de Staging e Procedure de ETL**
* **Pipeline de limpeza e padronização dos dados em Python**
* **Carga dos arquivos CSV tratados no banco de produção**

O objetivo segue:

> Criar dois bancos de dados (Produção e Homologação), montar a modelagem dimensional (dimensões e fatos), e enviar os scripts utilizados para criar as dimensões e fatos, podendo usar views ou triggers para alimentação do DW.

---

# Estrutura do Projeto

```
projeto_sql/
│
├── sql/
│   ├── 01_producao.sql
│   ├── 02_dimensoes_dw.sql
│   ├── 03_fato_dw.sql
│   ├── 04_views.sql
│   ├── 05_procedure_atualizar_dw.sql
│   ├── 06_trigger_staging.sql
│
├── data/
│   ├── produtos.csv
│   ├── vendas.csv
│   ├── usuarios.csv
│
├── limpeza.py
├── README.md
└── .gitignore
```

---

# Descrição dos Arquivos

### **/sql/01_producao.sql**

Cria o banco **producao**, as tabelas OLTP (produtos, usuários, vendas) e realiza a carga dos CSVs limpos.

### **/sql/02_dimensoes_dw.sql**

Cria o banco **homologacao_dw** e as tabelas dimensionais:

* dim_usuario
* dim_produto
* dim_tempo

### **/sql/03_fato_dw.sql**

Cria a tabela de fato principal:

* fato_vendas

### **/sql/04_views.sql**

Cria **views usando dblink** para acessar os dados do banco de produção diretamente no DW.

### **/sql/05_procedure_atualizar_dw.sql**

Procedure completa para **limpar e recarregar o DW** a partir das views.

### **/sql/06_trigger_staging.sql**

Trigger no banco de produção que copia automaticamente novos registros para uma **tabela de staging** no DW.

### **limpeza.py**

Script em Python que corrige encoding, datas, separadores, valores monetários e sobrescreve os CSVs tratados.

---

# ⚠️ **Importante — Arquivos CSV e Caminhos no PostgreSQL/DBeaver**

Para que a importação dos CSVs funcione corretamente:

### **1. Coloque os arquivos CSV na pasta `data/` do PostgreSQL**

No Windows, normalmente o caminho é algo como:

```
C:\Program Files\PostgreSQL\18\data\
```

Ou, se for instalado via outro método, na pasta equivalente ao diretório **data** do seu servidor PostgreSQL.

### **2. Edite o `01_producao.sql` e altere o caminho dos arquivos**

Procure as linhas de carga como:

```sql
COPY produtos FROM '/caminho/para/produtos.csv'
CSV HEADER;
```

E substitua pelo caminho onde você colocou os CSVs.

### **3. No DBeaver, também é necessário ajustar o caminho absoluto**

O DBeaver executa o comando `COPY` no servidor, não no cliente.

Ou seja, o caminho deve ser **valido para o PostgreSQL**, não para o seu computador.

---

# ⚠️ **Importante — Alterar partes 'sua_senha'**

Nos arquivos de criação de views com `dblink` e na procedure, procure entradas como:

```sql
password='sua_senha'
```

E substitua pela **senha real do usuário PostgreSQL**.

Exemplo:

```sql
password='postgres'
```

Sem essa alteração, as views e o dblink não conseguirão acessar o banco de produção.

---

# Banco de Produção (OLTP)

Criado em `01_producao.sql`.

Tabelas:

```
produtos  
usuarios  
vendas  
```

Execute:

```
\i sql/01_producao.sql
```

---

# Banco de Homologação

Criado pelos scripts:

```
02_dimensoes_dw.sql
03_fato_dw.sql
```

### **Dimensões**

* dim_usuario
* dim_produto
* dim_tempo

### **Fato**

* fato_vendas

---

# Views com dblink

Usadas para acessar o banco de produção:

```
vw_usuarios_producao  
vw_produtos_producao  
vw_vendas_producao  
```

---

# Procedure de Atualização do DW

Executa o processo completo de ETL:

```
CALL atualizar_dw();
```

---

# Trigger de Staging

Toda nova venda inserida no banco de produção é copiada automaticamente para:

```
homologacao_dw.public.vendas_staging
```

---

# Como Executar Todo o Projeto

### **1. Crie o banco de produção**

```
\i sql/01_producao.sql
```

### **2. Crie o banco de homologação**

```
\i sql/02_dimensoes_dw.sql
\i sql/03_fato_dw.sql
```

### **3. Ative as views**

```
\i sql/04_views.sql
```

### **4. Crie a procedure**

```
\i sql/05_procedure_atualizar_dw.sql
```

### **5. Crie o trigger**

```
\i sql/06_trigger_staging.sql
```

### **6. Execute o ETL**

```
CALL atualizar_dw();
```

---

# Resultado Final

✓ Banco de Produção completo
✓ Banco DW modelado (estrela)
✓ Dimensões e Fato populadas
✓ Views integrando os bancos via dblink
✓ ETL automatizado via procedure
✓ Trigger alimentando staging
✓ CSVs limpos e padronizados

