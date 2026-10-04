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
| <img src="comparison/architecture/architecture-unstyled.png?v=1.0.0" width="380" alt="Arquitetura sem estilo"/> | <img src="comparison/architecture/architecture-styled.png?v=1.0.0" width="380" alt="Arquitetura estilizada"/> |

### Banco de Dados Relacional / ER
| Padrão PlantUML (Sem estilo) | style-plantml (Com estilo) |
|:---:|:---:|
| <img src="comparison/database/database-unstyled.png?v=1.0.0" width="380" alt="Banco de dados sem estilo"/> | <img src="comparison/database/database-styled.png?v=1.0.0" width="380" alt="Banco de dados estilizado"/> |

### Diagrama de Sequência
| Padrão PlantUML (Sem estilo) | style-plantml (Com estilo) |
|:---:|:---:|
| <img src="comparison/sequence/sequence-unstyled.png?v=1.0.0" width="440" alt="Sequência sem estilo"/> | <img src="comparison/sequence/sequence-styled.png?v=1.0.0" width="440" alt="Sequência estilizada"/> |

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

---

# 🤝 Contribuidores
<a href="https://github.com/bgluis/style-plantml/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=bgluis/style-plantml" alt="Contribuidores"/>
</a>
