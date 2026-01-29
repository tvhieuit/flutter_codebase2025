# Documentation Index

Complete documentation for the Flutter Clean Architecture Monorepo.

## 📚 Table of Contents

### Getting Started
| Document | Description |
|----------|-------------|
| [QUICK_START.md](./QUICK_START.md) | Setup and run the project |
| [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) | Complete file organization |
| [COMMANDS.md](./COMMANDS.md) | All available Melos scripts |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | How to contribute |

### Monorepo & Packages
| Document | Description |
|----------|-------------|
| [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md) | Working with the workspace |
| [FEATURE_PACKAGES.md](./FEATURE_PACKAGES.md) | Creating feature packages |
| [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md) | Adding new apps |
| [DOMAIN_PACKAGE.md](./DOMAIN_PACKAGE.md) | Core business logic package |
| [AUTH_PACKAGE.md](./AUTH_PACKAGE.md) | Authentication feature package |

### Feature Development
| Document | Description |
|----------|-------------|
| [SCREEN_TEMPLATE.md](./SCREEN_TEMPLATE.md) | Creating new screens |
| [EXAMPLE_USER_FEATURE.md](./EXAMPLE_USER_FEATURE.md) | Complete feature example |
| [SPLASH_SCREEN_SETUP.md](./SPLASH_SCREEN_SETUP.md) | Splash screen implementation |

### Navigation & Routing
| Document | Description |
|----------|-------------|
| [ROUTING.md](./ROUTING.md) | Auto Route setup |
| [NAVIGATION_WITHOUT_CONTEXT.md](./NAVIGATION_WITHOUT_CONTEXT.md) | Navigate from BLoCs/services |
| [GLOBAL_NAVIGATION_EXAMPLES.md](./GLOBAL_NAVIGATION_EXAMPLES.md) | Common navigation patterns |

### Services & Utilities
| Document | Description |
|----------|-------------|
| [SERVICES.md](./SERVICES.md) | Network & permission services |
| [LOCALIZATION.md](./LOCALIZATION.md) | i18n implementation |
| [SHARED_PREFERENCES_ASYNC.md](./SHARED_PREFERENCES_ASYNC.md) | Local storage usage |

### UI & Widgets
| Document | Description |
|----------|-------------|
| [APP_LOADING.md](./APP_LOADING.md) | Loading states & indicators |

## 🗺️ Reading Guide

### New to the Project?
1. Start with [QUICK_START.md](./QUICK_START.md)
2. Understand the structure with [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md)
3. Learn the monorepo with [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md)

### Creating Features?
1. Read [SCREEN_TEMPLATE.md](./SCREEN_TEMPLATE.md)
2. Check [EXAMPLE_USER_FEATURE.md](./EXAMPLE_USER_FEATURE.md)
3. Follow [ROUTING.md](./ROUTING.md) for navigation

### Building a New App?
1. Follow [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md)
2. Understand packages in [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md)
3. Integrate auth with [AUTH_PACKAGE.md](./AUTH_PACKAGE.md)

### Creating a Feature Package?
1. Read [FEATURE_PACKAGES.md](./FEATURE_PACKAGES.md)
2. Use [AUTH_PACKAGE.md](./AUTH_PACKAGE.md) as reference
3. Understand domain with [DOMAIN_PACKAGE.md](./DOMAIN_PACKAGE.md)

## 📁 Documentation Organization

```
docs/
├── README.md                     # This index file
│
├── # Getting Started
├── QUICK_START.md                # Setup guide
├── PROJECT_STRUCTURE.md          # File organization
├── COMMANDS.md                   # Melos scripts
├── CONTRIBUTING.md               # Contribution guide
│
├── # Monorepo & Packages
├── MONOREPO_GUIDE.md             # Workspace guide
├── FEATURE_PACKAGES.md           # Feature package creation
├── NEW_APP_GUIDE.md              # New app creation
├── DOMAIN_PACKAGE.md             # Domain package
├── AUTH_PACKAGE.md               # Auth feature package
│
├── # Feature Development
├── SCREEN_TEMPLATE.md            # Screen creation template
├── EXAMPLE_USER_FEATURE.md       # Complete example
├── SPLASH_SCREEN_SETUP.md        # Splash screen
│
├── # Navigation
├── ROUTING.md                    # Auto Route setup
├── NAVIGATION_WITHOUT_CONTEXT.md # BLoC navigation
├── GLOBAL_NAVIGATION_EXAMPLES.md # Navigation patterns
│
├── # Services
├── SERVICES.md                   # Network & permissions
├── LOCALIZATION.md               # i18n
├── SHARED_PREFERENCES_ASYNC.md   # Local storage
│
└── # UI
    └── APP_LOADING.md            # Loading states
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
2. Add to this index (`docs/README.md`)
3. Update related docs if needed
4. Follow markdown conventions:
   - Use headers for sections
   - Include code examples
   - Add "See Also" references
   - Keep language clear and concise
