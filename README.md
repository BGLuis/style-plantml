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
![Java](https://www.shieldcn.dev/badge/OpenJDK-11+-ED8B00.svg?variant=branded&size=sm)

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
| <img src="comparison/architecture/architecture-unstyled.png?v=1.1.0" width="380" alt="Architecture Unstyled"/> | <img src="comparison/architecture/architecture-styled.png?v=1.1.0" width="380" alt="Architecture Styled"/> |

### Relational Database / ER Diagram
| Default PlantUML (Unstyled) | style-plantml (Styled) |
|:---:|:---:|
| <img src="comparison/database/database-unstyled.png?v=1.1.0" width="380" alt="Database Unstyled"/> | <img src="comparison/database/database-styled.png?v=1.1.0" width="380" alt="Database Styled"/> |

### Sequence Diagram
| Default PlantUML (Unstyled) | style-plantml (Styled) |
|:---:|:---:|
| <img src="comparison/sequence/sequence-unstyled.png?v=1.1.0" width="440" alt="Sequence Unstyled"/> | <img src="comparison/sequence/sequence-styled.png?v=1.1.0" width="440" alt="Sequence Styled"/> |

# 💻 Getting Started

### Requirements
- [Java OpenJDK](https://openjdk.org/) (>= 11)
- [PlantUML](https://plantuml.com/download) (>= 1.2024.8)
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
!define STYLE_PLANTML https://raw.githubusercontent.com/bgluis/style-plantml/v1.0.0
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
!include path/to/style-plantml/themes/light/architecture.puml
```

### Original Service Logos
Include any logo from the PlantUML stdlib (`logos`, `awslib`, `azure`, `gcp`, `k8s`) and pass its sprite name to the `SVC_<CATEGORY>_ICON` macros. The category color is kept; with `HIDE_SPRITES` the logo is dropped.
```plantuml
!include path/to/style-plantml/themes/light/architecture.puml
!include <logos/postgresql>

SVC_STORAGE_ICON(pg, "PostgreSQL", postgresql)
```

Logos have different proportions, so `SVC_<CATEGORY>_ICON` accepts an optional 4th argument with the scale for that logo (default `0.5`). Avoid exactly `1.0`: PlantUML 1.2026.8 crashes on some logos at that value.
```plantuml
SVC_EXTERNAL_ICON(payment, "Stripe API", stripe, 0.7)
```

### Icon Sizes
Define these **before** the `!include` to change the defaults:

| Variable | Default | Affects |
|---|---|---|
| `$ICON_SCALE_COL` | `0.25` | PK / FK / IDX icons in tables |
| `$ICON_SCALE_NODE` | `0.5` | Font Awesome icons in `SVC_*` nodes |
| `$ICON_SCALE_LOGO` | `0.5` | Logos in `SVC_*_ICON` nodes |
```plantuml
!$ICON_SCALE_COL = 0.2
!include path/to/style-plantml/themes/light/database.puml
```
See [`examples/arch-light-service-icons.puml`](examples/arch-light-service-icons.puml).

---

# 🤝 Contributors
<a href="https://github.com/bgluis/style-plantml/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=bgluis/style-plantml" alt="Contributors"/>
</a>
