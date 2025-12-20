# Project Rules

This directory contains the coding rules and standards for the Flutter project.

## 📋 Available Rules

### Architecture & Patterns
- **[clean_architecture.md](./clean_architecture.md)** - Clean Architecture principles and layer dependencies
- **[bloc_pattern.md](./bloc_pattern.md)** - BLoC pattern implementation rules

### Code Quality
- **[code_style.md](./code_style.md)** - Code formatting, naming conventions, and style guide

## 🎯 Quick Reference

### Key Principles

1. **Clean Architecture**
   - BLoCs → Use Cases → Repositories
   - Never inject Repositories directly in BLoCs
   - Always use abstract interfaces

2. **BLoC Pattern**
   - Use `@freezed` for Events and States
   - Use `@injectable` for BLoCs
   - Auto-initialize in constructor
   - Use `SafetyNetworkMixin` for API calls

3. **Code Style**
   - PascalCase for classes
   - camelCase for variables/methods
   - snake_case for files
   - Use `const` for performance
   - Format before commit

## 📚 Documentation

For implementation guides and templates, see the [docs](../docs/) directory.

## 🔧 Enforcement

These rules are enforced through:
- Linter configuration (`analysis_options.yaml`)
- Code review process
- Pre-commit hooks (recommended)
- CI/CD checks

## 📝 Updates

Rules are living documents and may be updated as the project evolves.
Last updated: Based on project best practices.

