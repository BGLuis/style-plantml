# Análise Técnica — `style-plantml` (temas, build e documentação)

**Data:** 2026-10-02 · **Branch:** `claude/practical-lamport-7194jc` · **Commit base:** `df00005` (igual a `main`)
**Escopo:** repositório inteiro — `themes/*`, `Makefile`, `examples/*`, `comparison/*`, `preview/*`,
`README*.md`, `CONTRIBUTING.md`, `.github/*`

---

## 1. Sumário executivo

O `style-plantml` entrega três temas claros (arquitetura, ER, sequência) sobre `skinparam`, com um
arquivo de *tokens* de cor e macros `SVC_*`/`COL*` que alternam ícones via `HIDE_SPRITES`. A base de
*tokens* é limpa, mas os dois caminhos que o README apresenta como padrão — ícones ligados e
*include* por URL — **não funcionam**, e nenhum deles é renderizado pelo `Makefile`.

| # | Problema | Alcance | Severidade |
|---|---|---|---|
| P-01 | Macros usam `<$fa5_*>`, mas o *sprite* se chama `$server`: nenhum ícone aparece | Modo padrão (com ícones) | Crítica |
| P-02 | *Include* por URL (Opção B do README) falha em `../shared/variables-light.puml` | Quem usa a Opção B | Crítica |
| P-03 | `skinparam padding` desenha um aviso no diagrama a partir do PlantUML 1.2026.3 | Tema de arquitetura | Alta |
| U-01 | `</b>` aparece como texto em rótulos com `\n` no modo com ícones | Modo padrão | Alta |
| P-05 | Ícones baixados por URL a cada render: +1,8 s por diagrama e erro sem rede | Modo padrão | Alta |

**Veredicto:** paleta e organização sólidas, mas o produto anunciado — ícones e *include* remoto —
está quebrado, e a vitrine do README só funciona porque foi renderizada sem ícones e copiada à mão.

---

## 2. Metodologia e limites

### 2.1 O que foi feito

Leitura integral dos 23 arquivos de texto (todos menos `LICENSE`) e execução real do PlantUML,
baixado do Maven Central [F8], nas versões 1.2024.8 (mínimo de `README.md:50`), 1.2025.0, 1.2025.10,
1.2026.0–1.2026.4 e 1.2026.8 (a mais recente). Cada achado foi reproduzido numa cópia do repositório; as correções de
P-01, P-02, P-03, P-05, U-01 e U-05 foram aplicadas numa segunda cópia e renderizadas para validar o
critério de aceite. Contraste calculado com a fórmula normativa do WCAG [F7]; comparações visuais
pixel a pixel com Pillow 12.3.0. Identificadores: **P-NN** cobre funcionamento, *build* e
desempenho; **U-NN**, usabilidade, acessibilidade e documentação.

**Protocolo de tempo** (seção 3.2): VM com 4 vCPU Intel Xeon 2,10 GHz, 16 GB, Ubuntu 24.04, OpenJDK
21.0.11, PlantUML 1.2026.8 · relógio de parede por `date +%s%N` em torno de `java -jar plantuml.jar`
· n = 10, 2 execuções de aquecimento descartadas · JVM fria a cada execução, cache de disco quente ·
rede via *proxy* de saída · **não** controlados: vizinhos de VM, governador de CPU, latência do
*proxy*.

### 2.2 O que NÃO foi feito — limites desta análise

> `plantuml.com` e a interface web do `github.com` estão bloqueados nesta sessão (HTTP 403): a
> documentação oficial de pré-processador, `<style>`, Smetana e linha de comando **não** foi lida.
> Onde ela faria falta, o relatório usa medição no binário instalado ou marca `[modelado]`. Graphviz
> não está instalado; renders usam as fontes do container (DejaVu); macOS e Windows não foram testados.

| Métrica | Limiar "Bom" | Fonte |
|---|---|---|
| Texto sobre fundo | ≥ 4,5:1 | WCAG 2.2 SC 1.4.3 (AA) [F5] |
| Objeto gráfico necessário à leitura | ≥ 3:1 | WCAG 2.2 SC 1.4.11 (AA) [F6] |
| Código de saída em diagrama válido | 0 (erro devolve 200, medido) | seção 3.1 |
| Ícones nos exemplos com *sprites* | 13 (arquitetura) · 12 (ER) | contagem de `<image` no SVG |

---

## 3. Evidências medidas

### 3.1 O `Makefile` não reproduz as imagens que o README usa

Em cópia limpa, `make clean && make all` (PlantUML 1.2026.8) termina com código 0 e gera
`architecture-styled.png`, `database-unstyled.png` etc. — o nome vem do argumento de `@startuml`
(`comparison/architecture/styled.puml:1`). O README exibe `styled.png`/`unstyled.png`
(`README.md:34,39,44`), que o `make` **nunca** gera: os versionados são cópias manuais, com `md5sum`
idêntico aos `*-styled.png`. `preview/` não é gerado por alvo nenhum nem referenciado por arquivo
nenhum. Diagrama com erro devolve código **200**, o que permite usar o código de saída como portão de CI.

### 3.2 Os ícones por URL custam rede, não CPU

| Configuração (n = 10) | Mediana | p95 | Mín–máx | Ícones no SVG |
|---|---|---|---|---|
| `arch-light-no-sprites.puml` (atual) | 1.107,5 ms | 1.313 ms | 1.039–1.313 ms | 0 (esperado) |
| `arch-light-with-sprites.puml` via URL (atual) | 3.011 ms | 3.366 ms | 2.859–3.366 ms | 0 (P-01) |
| `arch-light-with-sprites.puml` via stdlib (corrigido) | 1.164,5 ms | 1.210 ms | 1.105–1.210 ms | 13 |

Com n = 10 o p95 coincide com o máximo. Numa série extra de 5 execuções com `time`, a versão por URL
gastou 3,24–3,68 s de CPU (user + sys) em 2,63–2,86 s de parede; a stdlib, 2,68–2,98 s de CPU em
1,10–1,23 s. A URL soma ~1,6 s de parede e só ~0,6 s de CPU: o resto é **espera de rede** pelos 14
`!include` remotos. A versão corrigida desenha 13 ícones a mais e ainda é ~1,8 s mais rápida.

Sem rede (porta do *proxy* trocada para 1), o exemplo devolve código 200 e uma imagem de erro em
698 ms, acusando `Error line 23 in file: examples/arch-light-with-sprites.puml` — a linha 23 é de
`sprites.puml`, não do arquivo do usuário.

### 3.3 O aviso de `padding` surgiu no PlantUML 1.2026.3

| PlantUML | 1.2024.8 | 1.2025.0 | 1.2025.10 | 1.2026.0 | 1.2026.1 | 1.2026.2 | 1.2026.3 | 1.2026.4 | 1.2026.8 |
|---|---|---|---|---|---|---|---|---|---|
| Aviso desenhado | não | não | não | não | não | não | sim | sim | sim |

Com `skinparam padding 14`, a imagem mínima passa de 176 × 320 para 320 × 304 px quando o aviso
aparece. O *bytecode* de `CommandSkinParam` no 1.2026.8 (`javap -c`) mostra que só `handwritten`,
`ParticipantPadding` e `padding` geram aviso; dos temas, só `architecture.puml:45` é afetado.

### 3.4 Duas diretivas não têm efeito nenhum

| Diretiva (PlantUML 1.2026.8, Smetana) | Comparada com | Resultado |
|---|---|---|
| `skinparam linetype ortho` | sem a linha | **pixels idênticos** |
| `defaultFontName "Helvetica Neue, Arial, sans-serif"` | sem a linha · `Dialog` | **pixels idênticos** |
| `defaultFontName "Liberation Sans"` (controle) | sem a linha | imagem diferente (147 × 220 × 158 × 221) |

No SVG a pilha vira `font-family="'Helvetica Neue, Arial, sans-serif'"`: entre aspas simples, um
único nome de família inexistente, ignorado também pelo navegador.

### 3.5 Verificações negativas: hipóteses refutadas

**As flags `-D` do `Makefile:2` funcionam.** Postas depois de `-jar`, poderiam ser ignoradas — não
são: um diagrama de 60 caixas sai com 16.384 px de largura com `-DPLANTUML_LIMIT_SIZE=16384` e 4.096
px sem, em 1.2024.8 e 1.2026.8. O nome também vira variável do pré-processador, inofensivo aqui:

```bash
grep -rn "PLANTUML_LIMIT_SIZE" . --include=*.puml
# → 0 resultados
```

**`decimal(10,2)` não quebra os macros `COL*`.** A vírgula não divide o argumento:
`COL(price, decimal(10,2))` renderiza `decimal(10,2)`. Os 6 usos de `decimal(10.2)` em `examples/`
são erro de digitação (U-07). Ambas ficam registradas para não voltarem a ser levantadas.

---

## 4. Achados de funcionamento, build e desempenho

### P-01 · Nenhum ícone é renderizado: macros apontam para `<$fa5_*>`, que não existe — **Crítica**

`themes/shared/sprites.puml:44-53,59-61`

```plantuml
!define SVC_COMPUTE(alias, label)  node "<$fa5_server>\n<b>label</b>" as alias <<compute>>
!define COL_PK(name, type)   <color:#B45309><$fa5_key{scale=0.5}> <b>name</b></color> : ...
```

O `font-awesome-5/server.puml` do tupadr3 v2.4.0 declara `sprite $server` na linha 2 [F2]; o prefixo
`FA5_` existe só nas macros (`FA5_SERVER(...)`) [F1]. *Sprite* inexistente é ignorado **em silêncio**:
código 0, nenhum erro, nenhum ícone. O modo padrão do tema nunca mostrou ícones.

| Alcance | Impacto |
|---|---|
| Arquitetura com ícones | 0 de 13 ícones no exemplo |
| ER com ícones | 0 de 12; `COL_PK` mostra só o nome em negrito, sem chave nem `[PK]` |

**Reprodução:** `java -jar plantuml.jar -tsvg examples/arch-light-with-sprites.puml` e
`grep -o '<image' examples/arch-light-with-sprites.svg | wc -l` → `0`.

**Correção:** `<$fa5_X>` → `<$X>` nas 13 referências, forma documentada pela stdlib ("using
`<$sprite_name>`") [F3]. Fazer junto com P-05 e U-01, que editam as mesmas linhas.
**Critério de aceite:** `grep -c 'fa5_' themes/shared/sprites.puml` devolve 0 e os SVGs dos exemplos
com ícones têm 13 (arquitetura) e 12 (ER) `<image` — validado nesta sessão em 1.2024.8 e 1.2026.8.

---

### P-02 · Opção B do README (*include* por URL) falha nos `!include ../shared/…` — **Crítica**

`README.md:72-82` + `themes/light/architecture.puml:30-31` + `database.puml:33-34` + `sequence.puml:9`

```plantuml
!include STYLE_PLANTML/themes/light/architecture.puml   ' README.md:76
!include ../shared/variables-light.puml                 ' architecture.puml:30
```

Com o tema vindo por URL, `../shared/` não é resolvido contra a URL: o PlantUML procura no disco e
para com `cannot include ../shared/variables-light.puml` (1.2024.8 e 1.2026.8, código 200). O trecho
do README produz **sempre** uma tela de erro.

O C4-PlantUML resolve o mesmo problema com `%variable_exists`: caminho relativo quando a variável de
modo local existe, URL absoluta caso contrário [F4]. Aqui o próprio `STYLE_PLANTML` do README serve
de chave, no molde do *toggle* de `sprites.puml:19`:

```plantuml
!if %variable_exists("STYLE_PLANTML")
  !include STYLE_PLANTML/themes/shared/variables-light.puml
!else
  !include ../shared/variables-light.puml
!endif
```

**Reprodução:** salvar `README.md:74-81` num diretório vazio e renderizar; sai a imagem de erro com
`[From https://raw.githubusercontent.com/.../architecture.puml (line 30)]`.

**Correção:** aplicar o bloco acima às quatro linhas de `!include ../shared/` dos três temas.
Validado: o tema alterado, num diretório sem `themes/shared/`, buscou as dependências pela URL e
aplicou as cores (código 0).
**Critério de aceite:** um teste de CI renderiza o bloco exato de `README.md:74-81`, apontando para o
*commit* sob teste, a partir de um diretório vazio, e recebe código 0.

---

### P-03 · `skinparam padding` desenha um aviso em todo diagrama de arquitetura — **Alta**

`themes/light/architecture.puml:45`

```plantuml
skinparam padding          14
```

A partir do 1.2026.3 (seção 3.3), o parâmetro desenha "Please use CSS style instead of skinparam
padding" **no topo do diagrama** — em 100 % dos diagramas de arquitetura em versões atuais, e em
qualquer exportação. Até 1.2026.2 o *padding* é aplicado sem aviso.

**Reprodução:** `java -jar plantuml-1.2026.8.jar examples/arch-light-no-sprites.puml`; a faixa
amarela aparece logo abaixo do título.

**Correção:** remover a linha. Três tentativas de equivalente em `<style>` (`root`, `element` e
`document` com `Padding 14`) deram pixels idênticos a não ter *padding*; sem a documentação oficial a
chave certa não foi achada (seção 9). Sem a linha o layout fica mais compacto e `nodesep`/`ranksep`
(`:46-47`) seguem valendo.
**Critério de aceite:** `grep -o 'Please' examples/arch-light-no-sprites.svg | wc -l` devolve 0 em
PlantUML 1.2026.8.

---

### P-04 · `make clean && make` apaga as imagens do README e não as recria — **Média**

`Makefile:8-21`

```make
	$(PLANTUML) $(FLAGS) comparison/architecture/styled.puml   # gera architecture-styled.png
clean:
	rm -f comparison/*/*.png examples/*.png preview/*.png
```

Depois de `clean`, o README fica com seis imagens quebradas (seção 3.1). E quem segue
`CONTRIBUTING.md:18` atualiza arquivos que o README **não** mostra: a vitrine nunca acompanha mudanças
nos temas sem uma cópia manual.

**Reprodução:** em cópia limpa, `make clean && make all && ls comparison/*/` — não há `styled.png`.

**Correção:** apontar `README.md` e `README.pt.md` para os nomes que o `make` gera e apagar as cópias
e `preview/` (com P-08).
**Critério de aceite:** em cópia limpa, `make clean && make all` seguido de uma checagem de que todo
`src=` dos dois READMEs existe em disco termina sem arquivo faltando.

---

### P-05 · Ícones por URL: render depende de rede, custa +1,8 s e falha *offline* — **Alta**

`themes/shared/sprites.puml:22-38`

```plantuml
!define ICONURL https://raw.githubusercontent.com/tupadr3/plantuml-icon-font-sprites/v2.4.0
!include ICONURL/font-awesome-5/server.puml   ' … 14 includes remotos no total
```

Cada render baixa 14 arquivos. A mediana vai de 1.164,5 ms (stdlib) para 3.011 ms (URL), e o extra é
espera de rede (seção 3.2). Sem rede — ou com `raw.githubusercontent.com` bloqueado, comum em redes
corporativas — o usuário recebe erro em vez de diagrama. O PlantUML já embute a mesma biblioteca na
stdlib [F3].

**Reprodução:** o *benchmark* da seção 3.2; para o caso *offline*,
`JAVA_TOOL_OPTIONS="-Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=1"`.

**Correção:** `!include <tupadr3/common>` e `!include <tupadr3/font-awesome-5/server>` etc., forma
documentada pela stdlib [F3]. Validado: 13 ícones em 1.2024.8 e 1.2026.8.
**Critério de aceite:** com a rede bloqueada como na reprodução, o exemplo termina com código 0 e 13
`<image` no SVG; mediana ≤ 1,3 s no protocolo da seção 2.1.

---

### P-06 · Nada é fixado nem verificado: PlantUML, CI e versão do tema — **Média**

`Makefile:1` + `.gitignore:2` + `README.md:50,75`

```bash
ls .github/workflows         # → No such file or directory
git ls-remote --tags origin  # → 0 tags
```

`PLANTUML = java -jar plantuml.jar` usa um *jar* ignorado pelo git e sem alvo para baixá-lo. Os PNGs
versionados não são reprodutíveis: `examples/arch-light-no-sprites.png` tem 744 × 1084 px, regenerado
aqui sai com 825 × 1188 px. O README promete "≥ 1.2024.x", mas P-03 muda a saída em 1.2026.3. A
Opção B consome `main`: qualquer *commit* muda o diagrama de todos os usuários de uma vez.

**Reprodução:** procurar onde o `plantuml.jar` é obtido — não há alvo, *script* nem instrução.

**Correção:** `PLANTUML_VERSION ?= 1.2026.8` e um alvo que baixa o *jar* do Maven Central [F8] com
conferência de SHA-256; um *workflow* que roda `make` com ícones e o teste de P-02; *tags* semânticas
e `v1.0.0` no lugar de `main` na Opção B.
**Critério de aceite:** um PR que reintroduza `<$fa5_server>` ou `skinparam padding` deixa o CI
vermelho — falha com código ≠ 0, com menos de 13 `<image` no SVG com ícones ou com `Please` no SVG.

---

### P-07 · `linetype ortho` e a pilha de fontes não têm efeito — **Média**

`themes/light/architecture.puml:35,40,44` + `database.puml:38,43,47` + `sequence.puml:13`

Ambas produzem pixels idênticos à ausência delas (seção 3.4). A pilha é lida como **um** nome de
família; como ele não existe, o Java usa a fonte padrão do sistema — por isso o PNG versionado parece
Arial e o render deste container sai em DejaVu. E o `!pragma layout smetana` força o motor interno até
para quem tem Graphviz; o "Remove this line" de `architecture.puml:34` não serve a quem usa o tema por
URL.

**Reprodução:** renderizar um diagrama mínimo com e sem cada diretiva e comparar pixel a pixel.

**Correção:** um único nome em `defaultFontName` (`"SansSerif"` é garantido em qualquer JVM); o
`pragma` dentro de `!ifndef USE_GRAPHVIZ`, no molde de `sprites.puml:19`; `linetype ortho` só no ramo
Graphviz.
**Critério de aceite:** um *script* confirma que nenhuma linha de `themes/` é pixel-idêntica à sua
remoção no exemplo correspondente.

---

### P-08 · 50 % dos bytes de PNG versionados são duplicatas exatas — **Baixa**

`comparison/*/styled.png` + `comparison/*/unstyled.png` + `preview/*.png`

Seis PNGs de `comparison/` repetem os `*-styled.png`/`*-unstyled.png` (216.679 bytes) e os dois de
`preview/` repetem `examples/*.png` (120.010 bytes): 336.689 de 673.378 bytes, **50,0 %**. Cada
atualização de imagem dobra o peso no histórico.

**Reprodução:** `md5sum comparison/*/*.png examples/*.png preview/*.png` — pares com o mesmo *hash*.

**Correção:** junto com P-04, manter só os nomes gerados pelo `make` e apagar `preview/`.
**Critério de aceite:** `md5sum $(git ls-files '*.png') | cut -d' ' -f1 | sort | uniq -d` não imprime nada.

---

## 5. Achados de usabilidade, acessibilidade e documentação

### U-01 · `</b>` aparece como texto em rótulos de várias linhas — **Alta**

`themes/shared/sprites.puml:44-53` + `examples/arch-light-with-sprites.puml:17,25`

```plantuml
!define SVC_AUTH(alias, label)  node "<$fa5_shield_alt>\n<b>label</b>" as alias <<auth>>
SVC_AUTH(gateway, "API Gateway\n+ Auth")
```

`<b>` não atravessa a quebra de linha: o `\n` do usuário divide o rótulo, a primeira linha fica em
negrito e a segunda mostra `+ Auth</b>` literalmente. Os próprios exemplos disparam o defeito duas
vezes ("API Gateway" e "Notification Service").

**Reprodução:** renderizar o exemplo em SVG e
`grep -o '&lt;/b>' examples/arch-light-with-sprites.svg | wc -l` → `2`.

**Correção:** tirar `<b>…</b>` das macros e declarar o negrito por elemento, como já fazem
`architecture.puml:55` (`FontStyle bold` em `package`) e `sequence.puml:30` (`ParticipantFontStyle
bold`) — em `node`, `database`, `queue`, `cloud` e `actor`.
**Critério de aceite:** a mesma contagem devolve 0 e os rótulos seguem em negrito (validado para `node`).

---

### U-02 · Os modos com e sem ícones divergem, e o modo com ícones esconde estereótipos do usuário — **Média**

`themes/shared/sprites.puml:15-16,23`

O `common.puml` do tupadr3 executa `hide stereotype` (linha 21) [F2]. Com ícones, `«compute»`,
`«storage»` etc. somem; com `HIDE_SPRITES`, aparecem. O efeito é **global**: some também todo
estereótipo que o usuário declarar. Só o modo com ícones aplica negrito. A promessa de `:15-16` ("work
identically in both modes") não se cumpre — e sem ícones o estereótipo é a única pista de categoria
que não depende de cor.

**Reprodução:** comparar os PNGs de `arch-light-no-sprites.puml` e de `arch-light-with-sprites.puml`
(com P-01 corrigido): só o primeiro mostra `«compute»`.

**Correção:** depois de incluir `sprites.puml`, cada tema declara `show stereotype` ou
`hide stereotype` nos dois modos, controlado por um *toggle* `HIDE_STEREOTYPES` no molde de
`sprites.puml:19`; o negrito sai das macros (U-01).
**Critério de aceite:** para o mesmo diagrama, as listas de `<text>` dos SVGs dos dois modos são
iguais.

---

### U-03 · Contraste de 4,27:1 nos rótulos de seta e 1,44:1 no traço do ator — **Média** (WCAG 1.4.3/1.4.11, com ressalva)

`themes/shared/variables-light.puml:15,17` + `architecture.puml:102,186-190` +
`sequence.puml:21,31,36` + `database.puml:69`

| Par (frente sobre fundo) | Razão calculada | Limiar |
|---|---|---|
| `$L_TEXT2` `#6B7591` sobre `$L_BG` `#F5F7FA` — rótulo de seta, 11 pt | 4,27:1 | 4,5:1 [F5] |
| `$L_TEXT2` sobre `$L_SURFACE2` `#EEF2F8` — divisor de sequência | 4,08:1 | 4,5:1 |
| `$DB_TEXT2` `#6B7280` sobre `$DB_HEADER` `#F1F3F9` — estereótipo, 10 pt | 4,36:1 | 4,5:1 |
| `$L_BORDER` `#C8D0E0` sobre `$L_BG` — traço do ator | 1,44:1 | 3:1 [F6] |

Os rótulos de seta carregam o significado da relação ("publish", "charge") no menor corpo do tema, e
o ator, no PNG, é quase invisível.

> **Ressalva:** o WCAG trata de conteúdo web; texto em diagrama pode cair na exceção de imagem com
> "significant other visual content" [F5]. Os limiares servem de referência, não de alegação de
> conformidade — e a correção custa duas linhas.

**Reprodução:** aplicar a fórmula de luminância relativa [F7] aos valores de `variables-light.puml`.

**Correção:** `$L_TEXT2 = "#5F6985"` (≥ 4,79:1 sobre os quatro fundos claros, calculado); `$DB_TEXT2`
com o mesmo valor (≥ 4,92:1 sobre os fundos do ER); traço do ator com `$L_TEXT2` (≥ 5,09:1).
**Critério de aceite:** um *script* lê `variables-light.puml` e afirma ≥ 4,5:1 para cada par de texto
da tabela e ≥ 3:1 para o traço do ator.

---

### U-04 · A comparação "antes × depois" mistura mudança de conteúdo com mudança de tema — **Média**

`comparison/architecture/unstyled.puml:6-14` × `styled.puml:7-22` +
`comparison/database/unstyled.puml:40-44` × `styled.puml:45-49`

O "depois" de arquitetura ganha dois `package` e troca o `node "Web Client"` por um ator; o de ER
troca `--o{` por `||--o{`/`||--|{`, `string` por `varchar(…)` e tira os marcadores `+`. Parte da
melhora exibida em `README.md:31-39` é de **conteúdo**, não do tema. Só a de sequência é justa.

**Reprodução:** `diff comparison/database/unstyled.puml comparison/database/styled.puml` atinge todas
as entidades e relações, não só o `!include`.

**Correção:** um corpo único por comparação, incluído pelas duas versões; a versão "antes" inclui um
arquivo que define `SVC_*`/`COL*` como formas nuas, sem `skinparam` (o ramo de
`sprites.puml:66-86`, sem o tema).
**Critério de aceite:** o `diff` entre os dois *wrappers* de cada comparação mostra só a linha de
`!include` e o título.

---

### U-05 · `COL*` repetem cores em hexadecimal em vez de usar os *tokens* — **Baixa**

`themes/shared/sprites.puml:59-62,83-86` + `themes/shared/variables-light.puml:51-53`

`$DB_PK`, `$DB_FK` e `$DB_IDX` aparecem uma vez cada — na própria definição. As macros repetem os
valores à mão em 14 lugares, contra `CONTRIBUTING.md:15` ("Keep styles consistent with existing
tokens"); uma troca de paleta divergiria em silêncio.

**Reprodução:** `grep -rn '\$DB_PK' themes` → 1 linha, a definição.

**Correção:** `<color:$DB_PK>` etc. — validado: a variável é substituída dentro do corpo de `!define`.
**Critério de aceite:** `grep -c '#[0-9A-Fa-f]\{6\}' themes/shared/sprites.puml` devolve 0.

---

### U-06 · `SVC_API` é uma cópia de `SVC_EXTERNAL` — **Baixa**

`themes/shared/sprites.puml:48,53,73,78` + `themes/light/architecture.puml:22`

Mesmo `node`, mesmo ícone (`plug`), mesmo `<<external>>` — embora o cabeçalho documente `SVC_API`
como "API endpoint / gateway". Um *gateway* interno sai pintado de laranja "externo".

**Reprodução:** renderizar `SVC_API(a, "A")` e `SVC_EXTERNAL(b, "B")` lado a lado — saída idêntica.

**Correção:** `<<api>>` com cor própria, no molde de `<<auth>>` (`architecture.puml:171-176`); ou
remover a macro e documentar.
**Critério de aceite:** no SVG, os dois nós têm `fill` diferentes.

---

### U-07 · Documentação inconsistente com o código — **Baixa**

| Local | Diz | Realidade |
|---|---|---|
| `README.md:14` × `:49` | *Badge* "OpenJDK 17+" · requisito "≥ 11" | 1.2024.8 compila para Java 8 (*bytecode* 52); 1.2026.8, Java 11 (55) |
| `README.md:50` | PlantUML "≥ 1.2024.x" | saída muda em 1.2026.3 (P-03) |
| `variables-light.puml:5-8` | incluído por 2 temas | `sequence.puml:9` é o terceiro |
| `README.md:64` × `:88` | `path/to/style-plantml/…` · `../themes/…` | dois estilos de caminho no mesmo guia |
| `examples/db-light-*.puml` | `decimal(10.2)` (6 vezes) | `decimal(10,2)` funciona (seção 3.5) |
| `README.md:95` | `<img>` dos contribuidores | sem `alt` |

**Reprodução:** conferir cada linha da tabela.

**Correção:** "Java ≥ 11" no *badge* e no texto; "PlantUML ≥ 1.2024.8, testado até a versão fixada"
(P-06); cabeçalho atualizado; `path/to/style-plantml` em todo o guia; `decimal(10,2)`; `alt`. Replicar
em `README.pt.md`.
**Critério de aceite:** `grep -n "17+\|10\.2" README*.md examples/*.puml` devolve 0 linhas.

---

## 6. O que está bem feito

| Local | Decisão |
|---|---|
| `themes/shared/variables-light.puml:11-54` | Paleta centralizada por papel (`_B` borda, `_F` preenchimento): trocar tema é trocar um arquivo |
| `themes/shared/sprites.puml:19,64` | *Toggle* `HIDE_SPRITES` sem mudar o diagrama do usuário — molde para P-02, P-07 e U-02 |
| `themes/shared/sprites.puml:22` | Dependência remota fixada por *tag* (`v2.4.0`), não por `master` |
| `themes/light/database.puml:52-53` | `hide circle` e `hide empty members` dão cara de tabela ER sem macro extra |
| `.github/ISSUE_TEMPLATE/bug_report.yml:25-29` | O relato de *bug* pede a versão do PlantUML — essencial dado P-03 |

---

## 7. Achado transversal: os caminhos quebrados são os únicos que nunca são renderizados

`Makefile:16-18` só renderiza os exemplos `*-no-sprites`; as comparações estilizadas usam
`!define HIDE_SPRITES` (`comparison/architecture/styled.puml:4`, `comparison/database/styled.puml:4`);
nenhum alvo usa a Opção B. P-01, P-02 e U-01 vivem exatamente nos caminhos que nenhum comando do
repositório exercita, e P-03 depende de uma versão que o projeto não fixa. O checklist do PR
(`.github/pull_request_template.md:23-24`) pede "render tested", mas o render disponível não toca esses
caminhos. O CI de P-06 — renderizar **o que o README ensina**, com ícones e por URL — é o que impede a
volta de todos os outros.

---

## 8. Backlog priorizado

> Ordenado por (impacto no usuário × alcance) ÷ esforço.

| Pri | Item | Esforço | Alcance | Tipo |
|---|---|---|---|---|
| 1 | **P-01 + P-05 + U-01** — `<$X>`, stdlib no lugar da URL, negrito fora das macros | S | Modo padrão | Correção/Perf |
| 2 | **P-03** — remover `skinparam padding` | XS | Arquitetura em PlantUML ≥ 1.2026.3 | Correção |
| 3 | **P-02** — *include* condicional por `STYLE_PLANTML` | S | Opção B | Correção |
| 4 | **U-03** — `$L_TEXT2` e `$DB_TEXT2` mais escuros, traço do ator | XS | Todos | A11y |
| 5 | **P-04 + P-08** — nomes de saída do `make`, fim das duplicatas | XS | Mantenedores · README | Qualidade |
| 6 | **P-06** — versão fixada, CI de render, *tags* | M | Todos (prevenção) | Qualidade |
| 7 | **U-02** — estereótipos explícitos nos dois modos | S | Todos | UX |
| 8 | **P-07** — fonte única, Smetana opcional | S | Todos | Qualidade |
| 9 | **U-04** — comparações com o mesmo corpo | S | Leitores do README | UX |
| 10 | **U-05 + U-06 + U-07** — *tokens*, `SVC_API`, documentação | XS | Todos | Qualidade |

O item 1 é uma unidade porque P-01, P-05 e U-01 editam as mesmas linhas de `sprites.puml:22-53` —
corrigir só P-01 expõe U-01 em todo rótulo multilinha. P-04 e P-08 são uma unidade porque o nome de
saída escolhido decide quais arquivos sobram.

Os itens 1, 2, 4 e 5 somam menos de meio dia-dev e põem de pé as duas promessas do README — ícones e
diagramas limpos — com render mais rápido que o atual. Medir o item 1 de novo com o protocolo da
seção 2.1 antes de começar o 6, para fixar a linha de base do CI.

---

## 9. Riscos e o que falta verificar

1. **A documentação oficial do PlantUML não foi lida.** Antes de fechar P-03, consultar a página de
   evolução de estilos em `plantuml.com` para achar a chave `<style>` equivalente a `padding`; até lá
   a remoção pura é a única correção validada.
2. **Graphviz não foi testado.** A parte de P-07 que torna Smetana opcional exige render com `dot`
   para confirmar que `linetype ortho` passa a valer e que o layout não piora.
3. **A Opção B corrigida foi validada com o tema local e as dependências remotas**, não com o tema
   servido por URL — isso exige o arquivo publicado num *branch*; o CI de P-06 cobre. *Includes*
   irmãos por URL (sem `../`) não foram testados: o PlantUML recusa `localhost` ("Cannot open URL").
4. **A stdlib não é o mesmo artefato que o tupadr3 v2.4.0.** Os ícones resolvem em 1.2024.8 e
   1.2026.8, mas o desenho pode variar entre versões do PlantUML; revisar os PNGs antes de republicar.
5. **Os tempos vêm de uma VM compartilhada atrás de um *proxy*.** O custo da URL depende da rede de
   cada usuário; o resultado é a ordem de grandeza (segundos, dominados por espera), não o 1,8 s.
6. **macOS e Windows não foram verificados.** A troca de fonte de P-07 muda a largura das caixas;
   regerar e revisar todas as imagens depois dela.
7. **Plugins de IDE e o servidor PlantUML não foram testados.** Perfis de segurança mais restritos
   podem bloquear `!include` por URL por completo, o que inviabilizaria a Opção B mesmo corrigida
   `[modelado]`.

---

## 10. Fontes consultadas

| # | Fonte | Tipo | Versão | Consultada em | Sustenta |
|---|---|---|---|---|---|
| F1 | [tupadr3 — README](https://raw.githubusercontent.com/tupadr3/plantuml-icon-font-sprites/v2.4.0/README.md) | Doc oficial | v2.4.0 | 2026-10-02 | P-01 (prefixo só nas macros) |
| F2 | [tupadr3 — `font-awesome-5/server.puml` e `common.puml`](https://raw.githubusercontent.com/tupadr3/plantuml-icon-font-sprites/v2.4.0/common.puml) | Exemplo do mantenedor | v2.4.0 | 2026-10-02 | P-01 (`sprite $server`, linha 2) · U-02 (`hide stereotype`, linha 21) |
| F3 | [PlantUML stdlib — Tupadr3 library](https://raw.githubusercontent.com/plantuml/plantuml-stdlib/master/README.md) | Doc oficial | `master` | 2026-10-02 | Correções de P-01 e P-05 |
| F4 | [C4-PlantUML — README e `C4_Container.puml:1-5`](https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/README.md) | Projeto de terceiros | `master` | 2026-10-02 | Correção de P-02 |
| F5 | [WCAG 2.2 — SC 1.4.3 Contrast (Minimum)](https://raw.githubusercontent.com/w3c/wcag/main/guidelines/sc/20/contrast-minimum.html) | Doc oficial | 2.2 (`main`) | 2026-10-02 | U-03 · limiar da seção 2 |
| F6 | [WCAG 2.2 — SC 1.4.11 Non-text Contrast](https://raw.githubusercontent.com/w3c/wcag/main/guidelines/sc/21/non-text-contrast.html) | Doc oficial | 2.2 (`main`) | 2026-10-02 | U-03 · limiar da seção 2 |
| F7 | [WCAG — definições de *relative luminance* e *contrast ratio*](https://raw.githubusercontent.com/w3c/wcag/main/guidelines/terms/20/relative-luminance.html) | Doc oficial | 2.2 (`main`) | 2026-10-02 | Cálculo de U-03 |
| F8 | [Maven Central — `net.sourceforge.plantuml:plantuml`](https://repo1.maven.org/maven2/net/sourceforge/plantuml/plantuml/maven-metadata.xml) | Doc oficial | 1.2024.8–1.2026.8 | 2026-10-02 | Seções 2.1 e 3.3 · correção de P-06 |

Não consultadas (bloqueadas pelo *proxy*, HTTP 403): `plantuml.com` (pré-processador, `skinparam` e
`<style>`, Smetana, linha de comando) e `github.com` (*release notes* do 1.2026.3). Por isso a origem
do aviso de P-03 vem do *bisect* e do *bytecode*, não do *changelog*.

---

> Nenhuma alteração foi feita nos temas do repositório. A evidência vem de renders reais com PlantUML
> 1.2024.8–1.2026.8 numa VM Linux sem Graphviz, sobre o commit `df00005`; as correções foram
> validadas só numa cópia descartável. Graphviz, macOS/Windows, plugins de IDE e o servidor PlantUML
> não foram testados — pendências listadas na seção 9.
