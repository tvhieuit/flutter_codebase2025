# Documentation Index

Complete documentation for the Flutter Clean Architecture Monorepo.

## 📚 Table of Contents

### Getting Started
| Document | Description |
|----------|-------------|
| [quick_start.md](./quick_start.md) | Setup and run the project |
| [project_structure.md](./project_structure.md) | Complete file organization |
| [commands.md](./commands.md) | All available Melos scripts |
| [contributing.md](./contributing.md) | How to contribute |

### Monorepo & Packages
| Document | Description |
|----------|-------------|
| [monorepo_guide.md](./monorepo_guide.md) | Working with the workspace |
| [feature_packages.md](./feature_packages.md) | Creating feature packages |
| [new_app_guide.md](./new_app_guide.md) | Adding new apps |
| [domain_package.md](./domain_package.md) | Core business logic package |
| [auth_package.md](./auth_package.md) | Authentication feature package |

### Feature Development
| Document | Description |
|----------|-------------|
| [screen_template.md](./screen_template.md) | Creating new screens |
| [example_user_feature.md](./example_user_feature.md) | Complete feature example |
| [splash_screen_setup.md](./splash_screen_setup.md) | Splash screen implementation |

### Navigation & Routing
| Document | Description |
|----------|-------------|
| [routing.md](./routing.md) | Auto Route setup |
| [navigation_without_context.md](./navigation_without_context.md) | Navigate from BLoCs/services |
| [global_navigation_examples.md](./global_navigation_examples.md) | Common navigation patterns |

### Services & Utilities
| Document | Description |
|----------|-------------|
| [services.md](./services.md) | Network & permission services |
| [localization.md](./localization.md) | i18n implementation |
| [shared_preferences_async.md](./shared_preferences_async.md) | Local storage usage |

### UI & Widgets
| Document | Description |
|----------|-------------|
| [app_loading.md](./app_loading.md) | Loading states & indicators |

## 🗺️ Reading Guide

### New to the Project?
1. Start with [quick_start.md](./quick_start.md)
2. Understand the structure with [project_structure.md](./project_structure.md)
3. Learn the monorepo with [monorepo_guide.md](./monorepo_guide.md)

### Creating Features?
1. Read [screen_template.md](./screen_template.md)
2. Check [example_user_feature.md](./example_user_feature.md)
3. Follow [routing.md](./routing.md) for navigation

### Building a New App?
1. Follow [new_app_guide.md](./new_app_guide.md)
2. Understand packages in [monorepo_guide.md](./monorepo_guide.md)
3. Integrate auth with [auth_package.md](./auth_package.md)

### Creating a Feature Package?
1. Read [feature_packages.md](./feature_packages.md)
2. Use [auth_package.md](./auth_package.md) as reference
3. Understand domain with [domain_package.md](./domain_package.md)

## 📁 Documentation Organization

```
docs/
├── readme.md                     # This index file
│
├── # Getting Started
├── quick_start.md                # Setup guide
├── project_structure.md          # File organization
├── commands.md                   # Melos scripts
├── contributing.md               # Contribution guide
│
├── # Monorepo & Packages
├── monorepo_guide.md             # Workspace guide
├── feature_packages.md           # Feature package creation
├── new_app_guide.md              # New app creation
├── domain_package.md             # Domain package
├── auth_package.md               # Auth feature package
│
├── # Feature Development
├── screen_template.md            # Screen creation template
├── example_user_feature.md       # Complete example
├── splash_screen_setup.md        # Splash screen
│
├── # Navigation
├── routing.md                    # Auto Route setup
├── navigation_without_context.md # BLoC navigation
├── global_navigation_examples.md # Navigation patterns
│
├── # Services
├── services.md                   # Network & permissions
├── localization.md               # i18n
├── shared_preferences_async.md   # Local storage
│
└── # UI
    └── app_loading.md            # Loading states
```

## 🔗 Quick Links

### Architecture Rules (in `rules/`)
- [clean_architecture.md](../rules/clean_architecture.md) - Architecture principles
- [bloc_pattern.md](../rules/bloc_pattern.md) - BLoC rules
- [code_style.md](../rules/code_style.md) - Formatting & naming

### Key Files
- [pubspec.yaml](../pubspec.yaml) - Workspace & Melos config
- [.fvmrc](../.fvmrc) - Flutter version
- [analysis_options.yaml](../analysis_options.yaml) - Linter config

## ✏️ Contributing to Docs

When adding new documentation:

1. Create `.md` file in appropriate section
2. Add to this index (`docs/readme.md`)
3. Update related docs if needed
4. Follow markdown conventions:
   - Use headers for sections
   - Include code examples
   - Add "See Also" references
   - Keep language clear and concise
