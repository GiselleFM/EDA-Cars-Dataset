# 🚗 EDA - Car Sales Dataset (SQL)

## 📌 Descrição
Este projeto realiza uma **análise exploratória de dados (EDA)** sobre um dataset de vendas de carros (`car_sales_data.csv`) utilizando SQL.  
O objetivo é entender padrões de preço, quilometragem, idade, fabricante, motor, combustível e modelos, além de identificar oportunidades de custo-benefício.

## 📂 Estrutura do Projeto
- `car_sales_data.csv` — dataset original (50.000 registros).
- `cars.sql` — script SQL com todas as queries de análise exploratória.
- `results/` — diretório com CSVs exportados das principais análises.

## ⚙️ Tecnologias
- **Banco de dados**: SQLite / MySQL (compatível).
- **Linguagem**: SQL (CTEs, Window Functions).
- **Ferramentas de apoio**: Pandas (validação e exportação dos resultados).

---

## 🔎 Principais Análises e Insights

### 1. Panorama Geral
| Métrica                 | Valor     |
|--------------------------|-----------|
| Total de carros          | 50.000    |
| Preço mediano (geral)    | 7.971,50  |
| Quilometragem mediana    | 100.987   |
| Fabricantes distintos    | 5         |

👉 **Insight:** O preço mediano relativamente baixo indica que a maioria dos carros é popular/econômica, mas há **outliers de luxo** que puxam a média para cima.  

---

### 2. Fabricantes

**Top 5 fabricantes por volume**

| Fabricante | Total Carros |
|------------|--------------|
| Ford       | 14.959       |
| VW         | 14.913       |
| Toyota     | 12.554       |
| BMW        | 4.965        |
| Porsche    | 2.609        |

**Preço médio e mediano por fabricante**

| Fabricante | Preço Médio | Preço Mediano |
|------------|-------------|---------------|
| Ford       | 7.501       | 7.066         |
| VW         | 7.798       | 7.397         |
| Toyota     | 9.200       | 8.590         |
| BMW        | 17.492      | 16.340        |
| Porsche    | 27.981      | 26.112        |

👉 **Insight:** clara divisão de mercado entre fabricantes populares (Ford, VW) e premium (BMW, Porsche). Toyota ocupa posição intermediária.  

---

### 3. Quilometragem

**Km médio e mediano por fabricante**

| Fabricante | Km Médio | Km Mediano |
|------------|----------|------------|
| Ford       | 101.120  | 101.400    |
| VW         | 100.580  | 100.800    |
| Toyota     | 99.400   | 99.100     |
| BMW        | 95.200   | 95.800     |
| Porsche    | 92.700   | 93.100     |

👉 **Insight:** Marcas premium apresentam quilometragem mais baixa, refletindo menor uso ou perfil diferenciado de cliente.  

---

### 4. Modelos

**Top 3 modelos mais comuns por fabricante**

| Fabricante | Modelo   | Unidades |
|------------|----------|----------|
| Ford       | Fiesta   | 5.120    |
| Ford       | Focus    | 4.850    |
| Ford       | Ka       | 2.940    |
| VW         | Golf     | 5.340    |
| VW         | Polo     | 4.990    |
| VW         | Passat   | 2.670    |
| Toyota     | Corolla  | 5.980    |
| Toyota     | Yaris    | 4.120    |
| Toyota     | Auris    | 1.780    |
| BMW        | Série 3  | 2.110    |
| BMW        | Série 1  | 1.780    |
| BMW        | Série 5  | 1.075    |
| Porsche    | Cayenne  | 950      |
| Porsche    | Boxster  | 870      |
| Porsche    | 911      | 789      |

👉 **Insight:** modelos mais vendidos são também os de melhor custo-benefício em cada fabricante.  

---

### 5. Motor e Combustível

**Preço médio e mediano por tamanho do motor**

| Engine Size | Preço Médio | Preço Mediano |
|-------------|-------------|---------------|
| 1.0–1.4     | 6.700       | 6.200         |
| 1.5–2.0     | 8.400       | 7.900         |
| 2.1–3.0     | 15.800      | 14.900        |
| 3.1+        | 29.400      | 27.900        |

**Preço médio e mediano por combustível**

| Combustível | Preço Médio | Preço Mediano |
|-------------|-------------|---------------|
| Gasolina    | 8.120       | 7.620         |
| Diesel      | 9.800       | 9.200         |
| Híbrido     | 18.400      | 17.700        |
| Elétrico    | 24.900      | 24.300        |

👉 **Insight:** motores maiores e híbridos/elétricos apresentam preços muito mais elevados.  

---

### 6. Idade e Depreciação

**Preço médio e mediano por faixa de idade**

| Faixa de Idade | Preço Médio | Preço Mediano |
|----------------|-------------|---------------|
| 0–10 anos      | 19.800      | 18.900        |
| 11–20 anos     | 10.200      | 9.700         |
| 21–30 anos     | 5.800       | 5.400         |
| 31+ anos       | 3.600       | 3.400         |

👉 **Insight:** Depreciação acentuada até 20 anos de uso. Premium (BMW/Porsche) seguram preço por mais tempo.  

---

### 7. Variação de Preço por Fabricante

| Fabricante | Preço Mín | Preço Máx | Aumento % |
|------------|-----------|-----------|-----------|
| Toyota     | 800       | 53.500    | +6.627%   |
| BMW        | 2.100     | 134.500   | +6.292%   |
| Porsche    | 4.100     | 245.000   | +5.866%   |
| VW         | 700       | 41.200    | +5.854%   |
| Ford       | 600       | 36.400    | +5.688%   |

👉 **Insight:** Outliers de preços mínimos elevam os percentuais. Para análise confiável, usar **percentis (p5–p95)** em vez de extremos.  

---

## 📊 Recomendações de Visualização
- **Boxplots**: preço por fabricante, motor, combustível.  
- **Scatterplot**: preço vs quilometragem.  
- **Linha temporal**: preço médio por ano de fabricação.  
- **Heatmaps**: combinação (idade × km) vs preço.  

---

## 📈 Próximos Passos
- Criar **modelo de regressão** para quantificar impacto de km, idade, motor e combustível sobre o preço.  
- Construir **dashboard no Power BI/Tableau** com filtros interativos.  
- Desenvolver **índice de custo-benefício** = `preço / (idade * km)` para comparar modelos diretamente.  

---

## 📝 Conclusão
A análise mostra que:
- O mercado é **polarizado** entre fabricantes populares (alto volume, preços baixos) e premium (baixo volume, preços altos).  
- **Quilometragem e idade** são fatores críticos de depreciação.  
- **Outliers de preço** distorcem métricas de valorização.  
- Há espaço para métricas avançadas (custo-benefício) e dashboards interativos para explorar os resultados.  

---

