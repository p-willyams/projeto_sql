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

Script em Python para:

* corrigir encoding
* padronizar datas
* ajustar valores numéricos
* inverter colunas erradas
* limpar o dataset
* sobrescrever os CSVs tratados

---

# Pré-Processamento dos Dados

Os CSVs originais estavam com inconsistências, como:

* encoding `latin1`
* datas inválidas
* valores monetários com vírgula
* colunas invertidas (cidade/estado)
* separador inconsistente

O script `limpeza.py` corrige tudo isso:

```bash
python limpeza.py
```

Após a execução, os arquivos limpos ficam na pasta:

```
/data
```

Prontos para importação no PostgreSQL.

---

# Banco de Produção (OLTP)

Banco criado em `01_producao.sql`.

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

* fato_vendas (modelo estrela)

---

# Views com dblink

Essas views permitem extrair dados diretamente do banco de produção:

```
vw_usuarios_producao
vw_produtos_producao
vw_vendas_producao
```

São essenciais para o processo de ETL.

---

# Procedure de Atualização do DW

A procedure:

```sql
CALL atualizar_dw();
```

Executa todo o ETL:

1. limpa dados antigos
2. recarrega as dimensões
3. gera a dimensão tempo
4. popula a tabela fato
5. usa **views via dblink** como fonte de dados

---

# Trigger de Staging

O trigger:

* roda **no banco de produção**
* toda vez que uma venda é inserida
* grava automaticamente uma cópia na tabela de staging no DW

A tabela:

```
homologacao_dw.public.vendas_staging
```

## **Importante — Requisitos de Permissões**

Como o trigger está em **um banco** e insere dados **em outro banco**, é necessário:

### 1. Conectar ao PostgreSQL com um usuário superuser

Ou garantir que o usuário tenha permissão para escrever no outro banco.

### 2. Conceder permissões explícitas:

Antes de criar o trigger, executar:

```sql
GRANT INSERT ON TABLE homologacao_dw.public.vendas_staging TO postgres;
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

### **4. Crie a procedure de carga**

```
\i sql/05_procedure_atualizar_dw.sql
```

### **5. Crie a trigger**

```
\i sql/06_trigger_staging.sql
```

### **6. Rode o ETL**

```
CALL atualizar_dw();
```

# Resultado Final

✔ Banco de Produção completo
✔ Banco DW em modelo estrela
✔ Dimensões e fato populadas
✔ Views de integração entre bancos
✔ Trigger alimentando área de staging
✔ ETL automatizado via procedure
✔ CSVs limpos e padronizados
✔ Estrutura clara, modular e didática

