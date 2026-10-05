<div align="center">

<!-- Badges de Status do GitHub -->
![GitHub Stars](https://www.shieldcn.dev/github/stars/bgluis/style-plantml.svg?variant=secondary&size=sm)
![GitHub Forks](https://www.shieldcn.dev/github/forks/bgluis/style-plantml.svg?variant=secondary&size=sm)
![Watchers](https://www.shieldcn.dev/github/watchers/bgluis/style-plantml.svg?variant=secondary&size=sm)
![Contributors](https://www.shieldcn.dev/github/contributors/bgluis/style-plantml.svg?theme=emerald&size=sm)
![License](https://www.shieldcn.dev/github/license/bgluis/style-plantml.svg?variant=ghost&size=sm)

<br/>

<!-- Badges das Tecnologias Utilizadas -->
![PlantUML](https://www.shieldcn.dev/badge/PlantUML-Theme-3178C6.svg?variant=branded&size=sm)
![Java](https://www.shieldcn.dev/badge/OpenJDK-11+-ED8B00.svg?variant=branded&size=sm)

  <h3>style-plantml</h3>
  Estilização moderna para PlantUML inspirada em design kits do Figma com suporte a sprites opcionais.
</div>

<div align="center">
  <a href="README.md">English</a> • <strong>Português</strong>
</div>

---

# 📖 Sobre
O **style-plantml** oferece temas visuais modernos para o PlantUML, inspirados em design kits do Figma. Aplica paletas suaves, cantos arredondados, distinção por categoria (compute, storage, queue, etc.), cabeçalhos estilizados em tabelas de banco de dados e ícones opcionais via Font Awesome 5.

# ⚡ Comparação Visual (Antes vs Depois)

### Diagrama de Arquitetura
| Padrão PlantUML (Sem estilo) | style-plantml (Com estilo) |
|:---:|:---:|
| <img src="comparison/architecture/architecture-unstyled.png?v=1.1.0" width="380" alt="Arquitetura sem estilo"/> | <img src="comparison/architecture/architecture-styled.png?v=1.1.0" width="380" alt="Arquitetura estilizada"/> |

### Banco de Dados Relacional / ER
| Padrão PlantUML (Sem estilo) | style-plantml (Com estilo) |
|:---:|:---:|
| <img src="comparison/database/database-unstyled.png?v=1.1.0" width="380" alt="Banco de dados sem estilo"/> | <img src="comparison/database/database-styled.png?v=1.1.0" width="380" alt="Banco de dados estilizado"/> |

### Diagrama de Sequência
| Padrão PlantUML (Sem estilo) | style-plantml (Com estilo) |
|:---:|:---:|
| <img src="comparison/sequence/sequence-unstyled.png?v=1.1.0" width="440" alt="Sequência sem estilo"/> | <img src="comparison/sequence/sequence-styled.png?v=1.1.0" width="440" alt="Sequência estilizada"/> |

# 💻 Como Iniciar

### Requisitos
- [Java OpenJDK](https://openjdk.org/) (>= 11)
- [PlantUML](https://plantuml.com/download) (>= 1.2024.8)
- [Graphviz](https://graphviz.org/download/) *(Opcional — o motor interno Smetana já vem pré-configurado)*

### Instalação e Uso

#### Opção A: Include Local
Clone o repositório do projeto:
```sh
git clone https://github.com/bgluis/style-plantml.git
```

Inclua o tema desejado:
```plantuml
@startuml
!include path/to/style-plantml/themes/light/architecture.puml

SVC_ACTOR(user, "User")
SVC_COMPUTE(api, "API Service")
user --> api
@enduml
```

#### Opção B: URL Direta do GitHub
```plantuml
@startuml
!define STYLE_PLANTML https://raw.githubusercontent.com/bgluis/style-plantml/v1.0.0
!include STYLE_PLANTML/themes/light/architecture.puml

SVC_ACTOR(user, "User")
SVC_COMPUTE(api, "API Service")
user --> api
@enduml
```

### Desativar Ícones / Sprites
Os ícones vêm habilitados por padrão. Para renderizar apenas as formas sem ícones, defina `!define HIDE_SPRITES` **antes** do `!include`:
```plantuml
!define HIDE_SPRITES
!include path/to/style-plantml/themes/light/architecture.puml
```

### Logos Originais dos Serviços
Inclua qualquer logo da stdlib do PlantUML (`logos`, `awslib`, `azure`, `gcp`, `k8s`) e passe o nome do sprite para as macros `SVC_<CATEGORIA>_ICON`. A cor da categoria é mantida; com `HIDE_SPRITES` o logo é removido.
```plantuml
!include path/to/style-plantml/themes/light/architecture.puml
!include <logos/postgresql>

SVC_STORAGE_ICON(pg, "PostgreSQL", postgresql)
```

Os logos têm proporções diferentes, então `SVC_<CATEGORIA>_ICON` aceita um 4º argumento opcional com a escala daquele logo (padrão `0.5`). Evite exatamente `1.0`: o PlantUML 1.2026.8 falha em alguns logos com esse valor.
```plantuml
SVC_EXTERNAL_ICON(payment, "Stripe API", stripe, 0.7)
```

### Tamanho dos Ícones
Defina antes do `!include` para mudar os padrões:

| Variável | Padrão | Afeta |
|---|---|---|
| `$ICON_SCALE_COL` | `0.25` | Ícones PK / FK / IDX nas tabelas |
| `$ICON_SCALE_NODE` | `0.5` | Ícones Font Awesome nos nós `SVC_*` |
| `$ICON_SCALE_LOGO` | `0.5` | Logos nos nós `SVC_*_ICON` |
```plantuml
!$ICON_SCALE_COL = 0.2
!include path/to/style-plantml/themes/light/database.puml
```
Veja [`examples/arch-light-service-icons.puml`](examples/arch-light-service-icons.puml).

---

# 🤝 Contribuidores
<a href="https://github.com/bgluis/style-plantml/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=bgluis/style-plantml" alt="Contribuidores"/>
</a>
