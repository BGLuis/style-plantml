<div align="center">

<!-- GitHub Status Badges -->
![GitHub Stars](https://www.shieldcn.dev/github/stars/bgluis/style-plantml.svg?variant=secondary&size=sm)
![GitHub Forks](https://www.shieldcn.dev/github/forks/bgluis/style-plantml.svg?variant=secondary&size=sm)
![Watchers](https://www.shieldcn.dev/github/watchers/bgluis/style-plantml.svg?variant=secondary&size=sm)
![Contributors](https://www.shieldcn.dev/github/contributors/bgluis/style-plantml.svg?theme=emerald&size=sm)
![License](https://www.shieldcn.dev/github/license/bgluis/style-plantml.svg?variant=ghost&size=sm)

<br/>

<!-- Technology Badges -->
![PlantUML](https://www.shieldcn.dev/badge/PlantUML-Theme-3178C6.svg?variant=branded&size=sm)
![Java](https://www.shieldcn.dev/badge/OpenJDK-17+-ED8B00.svg?variant=branded&size=sm)

  <h3>style-plantml</h3>
  Figma-inspired styling and clean component tokens for modern PlantUML diagrams.
</div>

<div align="center">
  <strong>English</strong> • <a href="README.pt.md">Português</a>
</div>

---

# 📖 About
**style-plantml** provides clean, modern, Figma-inspired themes for PlantUML diagrams. It brings contemporary visual design (subtle palettes, distinct category colors, rounded borders, clean table headers, and optional Font Awesome 5 icons) to Architecture, Entity-Relationship (Database), and Sequence diagrams.

# ⚡ Visual Comparison (Before vs After)

### Architecture Diagram
| Default PlantUML (Unstyled) | style-plantml (Styled) |
|:---:|:---:|
| <img src="comparison/architecture/unstyled.png" width="380" alt="Architecture Unstyled"/> | <img src="comparison/architecture/styled.png" width="380" alt="Architecture Styled"/> |

### Relational Database / ER Diagram
| Default PlantUML (Unstyled) | style-plantml (Styled) |
|:---:|:---:|
| <img src="comparison/database/unstyled.png" width="380" alt="Database Unstyled"/> | <img src="comparison/database/styled.png" width="380" alt="Database Styled"/> |

### Sequence Diagram
| Default PlantUML (Unstyled) | style-plantml (Styled) |
|:---:|:---:|
| <img src="comparison/sequence/unstyled.png" width="440" alt="Sequence Unstyled"/> | <img src="comparison/sequence/styled.png" width="440" alt="Sequence Styled"/> |

# 💻 Getting Started

### Requirements
- [Java OpenJDK](https://openjdk.org/) (>= 11)
- [PlantUML](https://plantuml.com/download) (>= 1.2024.x)
- [Graphviz](https://graphviz.org/download/) *(Optional — Smetana internal layout engine is pre-configured)*

### Installation & Usage

#### Option A: Local Include
Clone the repository:
```sh
git clone https://github.com/bgluis/style-plantml.git
```

Include the desired theme:
```plantuml
@startuml
!include path/to/style-plantml/themes/light/architecture.puml

SVC_ACTOR(user, "User")
SVC_COMPUTE(api, "API Service")
user --> api
@enduml
```

#### Option B: Direct GitHub URL
```plantuml
@startuml
!define STYLE_PLANTML https://raw.githubusercontent.com/bgluis/style-plantml/main
!include STYLE_PLANTML/themes/light/architecture.puml

SVC_ACTOR(user, "User")
SVC_COMPUTE(api, "API Service")
user --> api
@enduml
```

### Toggle Sprites (Icons)
Sprites are enabled by default. To remove icons, add `!define HIDE_SPRITES` **before** the `!include`:
```plantuml
!define HIDE_SPRITES
!include ../themes/light/architecture.puml
```

---

# 🤝 Contributors
<a href="https://github.com/bgluis/style-plantml/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=bgluis/style-plantml"/>
</a>
