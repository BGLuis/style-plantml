# Contributing to style-plantml / Contribuindo com o style-plantml

[English](#english) • [Português](#português)

---

## English

Thank you for your interest in contributing to **style-plantml**!

### How to Contribute

1. **Fork & Branch**: Create a feature branch (`git checkout -b feature/new-theme-or-fix`).
2. **Make Changes**:
   - Keep styles consistent with existing tokens in `themes/shared/variables-light.puml`.
   - Ensure backwards compatibility with `!define HIDE_SPRITES`.
3. **Verify Render**:
   - Run `make comparison` or `make examples` to ensure diagrams render cleanly.
4. **Submit PR**: Open a Pull Request using the provided PR template.

### Guidelines
- Follow semantic commit messages (`feat:`, `fix:`, `docs:`, `style:`).
- Include rendered preview images in your PR for any style changes.

---

## Português

Obrigado pelo interesse em contribuir com o **style-plantml**!

### Como Contribuir

1. **Fork & Branch**: Crie uma branch para sua alteração (`git checkout -b feature/novo-tema-ou-ajuste`).
2. **Fazer Alterações**:
   - Mantenha consistência com os tokens em `themes/shared/variables-light.puml`.
   - Garanta compatibilidade com o toggle `!define HIDE_SPRITES`.
3. **Validar Renderização**:
   - Execute `make comparison` ou `make examples` para validar a renderização.
4. **Abrir Pull Request**: Abra um PR utilizando o template padrão.

### Diretrizes
- Use commits semânticos (`feat:`, `fix:`, `docs:`, `style:`).
- Inclua imagens de pré-visualização no PR para qualquer alteração visual.
