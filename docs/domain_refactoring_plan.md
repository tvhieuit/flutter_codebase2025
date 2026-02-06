# Domain Package Refactoring Plan

## Muc tieu

Chuan hoa package `domain` theo dung Clean Architecture, dam bao:
- Domain chi chua business logic thuan (pure Dart)
- Tach biet ro rang giua domain layer va data layer
- Nhat quan ve pattern va coding style
- De test, de mo rong

---

## Hien trang va Van de

### Cau truc hien tai

```
packages/domain/lib/src/
├── di/
│   ├── di.dart
│   ├── domain_module.dart
│   ├── injection.dart
│   └── injection.config.dart
├── entities/
│   ├── entities.dart
│   ├── user_entity.dart              # co @JsonKey, fromJson, toJson
│   ├── product_entity.dart           # co @JsonKey, fromJson, toJson
│   └── auth/
│       ├── auth_token.dart           # co @JsonKey, fromJson, toJson
│       └── auth_credentials.dart
├── network/
│   └── auth_interceptor.dart         # Dio interceptor (infrastructure code)
├── repositories/
│   ├── repositories.dart
│   ├── user_repository.dart          # abstract + cache methods lan lon
│   ├── product_repository.dart       # abstract
│   ├── auth_repository.dart          # abstract
│   ├── impl/                         # IMPLEMENTATIONS trong domain
│   │   ├── auth_repository_impl.dart     # phu thuoc Dio
│   │   ├── user_repository_impl.dart     # phu thuoc Dio, SharedPreferences
│   │   ├── local_storage_impl.dart       # phu thuoc SharedPreferences
│   │   ├── user_local_repository_impl.dart
│   │   ├── app_setting_repository_impl.dart
│   │   └── local_storage_keys.dart
│   └── local/
│       ├── local.dart
│       ├── local_storage.dart        # abstract interface
│       ├── user_local_repository.dart
│       └── app_settings_repository.dart
└── use_cases/
    ├── use_cases.dart
    ├── base_use_case.dart
    ├── user_use_case.dart            # Monolithic style (throw exception)
    ├── user/
    │   ├── user_use_cases.dart
    │   ├── get_user_use_case.dart     # Single Responsibility (return Result)
    │   ├── get_users_use_case.dart
    │   ├── create_user_use_case.dart
    │   ├── update_user_use_case.dart
    │   ├── delete_user_use_case.dart
    │   └── user_input_validators.dart
    └── product/
        ├── product_use_cases.dart
        ├── get_product_use_case.dart
        └── get_products_use_case.dart
```

### Danh sach van de

| # | Van de | Muc do | File lien quan |
|---|--------|--------|----------------|
| 1 | Repository implementations nam trong domain | Nghiem trong | `repositories/impl/*` |
| 2 | Network code (Dio interceptor) trong domain | Nghiem trong | `network/auth_interceptor.dart` |
| 3 | Entity chua JSON serialization (@JsonKey, fromJson) | Trung binh | `entities/*.dart` |
| 4 | Hai kieu use case song song, khong nhat quan | Trung binh | `user_use_case.dart` vs `user/*.dart` |
| 5 | UserUseCase monolithic dung Map<String, dynamic> | Trung binh | `user_use_case.dart:43` |
| 6 | UserRepository chua ca remote + cache methods | Nhe | `user_repository.dart` |
| 7 | Product use cases thieu (Create, Update, Delete) | Nhe | `product/` |
| 8 | domain.dart export auth_interceptor | Nhe | `domain.dart:9` |

---

## Cau truc muc tieu

### Domain package (chi chua pure business logic)

```
packages/domain/lib/src/
├── di/
│   ├── di.dart
│   ├── domain_module.dart
│   ├── injection.dart
│   └── injection.config.dart
├── entities/
│   ├── entities.dart
│   ├── user_entity.dart              # pure Dart, KHONG co @JsonKey
│   ├── product_entity.dart
│   └── auth/
│       ├── auth_token.dart
│       └── auth_credentials.dart
├── repositories/                     # CHI abstract interfaces
│   ├── repositories.dart
│   ├── remote/                       # Remote repository interfaces
│   │   ├── remote.dart
│   │   ├── user_repository.dart
│   │   ├── product_repository.dart
│   │   └── auth_repository.dart
│   └── local/                        # Local repository interfaces
│       ├── local.dart
│       ├── local_storage.dart
│       ├── local_storage_keys.dart   # Keys la domain concept
│       ├── user_local_repository.dart
│       └── app_settings_repository.dart
├── use_cases/                        # CHI Single Responsibility pattern
│   ├── use_cases.dart
│   ├── base_use_case.dart
│   ├── auth/
│   │   ├── auth_use_cases.dart
│   │   ├── login_use_case.dart
│   │   ├── register_use_case.dart
│   │   ├── logout_use_case.dart
│   │   └── auth_input_validators.dart
│   ├── user/
│   │   ├── user_use_cases.dart
│   │   ├── get_user_use_case.dart
│   │   ├── get_users_use_case.dart
│   │   ├── create_user_use_case.dart
│   │   ├── update_user_use_case.dart
│   │   ├── delete_user_use_case.dart
│   │   └── user_input_validators.dart
│   └── product/
│       ├── product_use_cases.dart
│       ├── get_product_use_case.dart
│       ├── get_products_use_case.dart
│       ├── create_product_use_case.dart
│       ├── update_product_use_case.dart
│       └── delete_product_use_case.dart
└── validators/                       # Shared validators (optional)
    └── input_validators.dart
```

### Data layer (nhan implementations tu domain)

```
packages/domain/lib/src/
├── data/                             # HOAC tao package rieng
│   ├── models/                       # DTOs voi @JsonKey, fromJson
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   └── auth_token_model.dart
│   ├── repositories/                 # Repository implementations
│   │   ├── auth_repository_impl.dart
│   │   ├── user_repository_impl.dart
│   │   ├── local_storage_impl.dart
│   │   ├── user_local_repository_impl.dart
│   │   └── app_setting_repository_impl.dart
│   └── network/
│       └── auth_interceptor.dart
```

> **Ghi chu**: Co 2 huong tiep can cho data layer:
> - **Phuong an A**: Tao folder `data/` trong package `domain` (don gian, it breaking changes)
> - **Phuong an B**: Tao package `data` rieng (chuan hon, nhung nhieu thay doi)
> Khuyen nghi: Bat dau voi **Phuong an A**, sau do tach ra package rieng khi can.

---

## Huong tiep can: Refactor theo Phase

### Phase 1: Don dep Use Cases (It rui ro, lam truoc)

**Muc tieu**: Thong nhat ve mot pattern duy nhat cho use cases.

**Ly do lam truoc**: Khong anh huong den cac package khac, chi trong domain.

#### Checklist Phase 1

- [ ] **1.1** Xoa `user_use_case.dart` (monolithic style)
  - File: `lib/src/use_cases/user_use_case.dart`
  - Kiem tra: Tim tat ca noi import/su dung `UserUseCase`, `UserUseCaseImpl`
  - Cap nhat: Chuyen sang dung individual use cases tuong ung
  - Luu y: BLoC nao dang inject `UserUseCase` phai doi sang inject individual use cases

- [ ] **1.2** Xoa export `user_use_case.dart` trong barrel file
  - File: `lib/src/use_cases/use_cases.dart`
  - Xoa dong: `export 'user_use_case.dart';`

- [ ] **1.3** Bo sung auth use cases
  - Tao folder: `lib/src/use_cases/auth/`
  - Tao files:
    - `login_use_case.dart` - validate credentials truoc khi goi repository
    - `register_use_case.dart` - validate registration data
    - `logout_use_case.dart` - clear tokens + user data
    - `refresh_token_use_case.dart` - refresh logic
    - `auth_input_validators.dart` - email, password validators
    - `auth_use_cases.dart` - barrel export

- [ ] **1.4** Bo sung product use cases con thieu
  - Tao files trong `lib/src/use_cases/product/`:
    - `create_product_use_case.dart`
    - `update_product_use_case.dart`
    - `delete_product_use_case.dart`
  - Cap nhat `product_use_cases.dart` barrel export

- [ ] **1.5** Chay build_runner va verify
  - `fvm dart run melos run brd`
  - `fvm dart run melos run analyze`

---

### Phase 2: Tach Repository Interface (Trung binh rui ro)

**Muc tieu**: Repository interfaces ro rang, tach remote vs local.

#### Checklist Phase 2

- [ ] **2.1** Tach `UserRepository` thanh remote-only
  - File: `lib/src/repositories/user_repository.dart`
  - Xoa cac cache methods: `getCachedUser`, `cacheUser`, `clearCachedUser`, `cacheUserList`, `getCachedUserList`
  - Giu lai chi remote methods: `getUserById`, `getUsers`, `createUser`, `updateUser`, `deleteUser`, `searchUsers`
  - Luu y: `UserLocalRepository` da co san, dung no cho local operations

- [ ] **2.2** To chuc lai folder repositories
  - Tao folder `repositories/remote/` cho remote interfaces
  - Di chuyen: `user_repository.dart`, `product_repository.dart`, `auth_repository.dart` vao `remote/`
  - Tao `remote/remote.dart` barrel export
  - Cap nhat `repositories/repositories.dart`

- [ ] **2.3** Di chuyen `local_storage_keys.dart` tu `impl/` vao `local/`
  - Day la domain concept (key names), khong phai implementation
  - File: `impl/local_storage_keys.dart` -> `local/local_storage_keys.dart`
  - Cap nhat imports trong `user_local_repository.dart`, `app_settings_repository.dart`

- [ ] **2.4** Cap nhat tat ca imports lien quan
  - Tim va thay the imports trong: use cases, BLoCs, feature packages
  - Chay: `fvm dart run melos run analyze` de tim loi

- [ ] **2.5** Cap nhat `UserRepositoryImpl`
  - Xoa cache methods khoi impl
  - Dam bao impl chi implement remote interface moi

---

### Phase 3: Di chuyen Implementations ra khoi domain (Rui ro cao)

**Muc tieu**: Domain khong con chua implementation code.

#### Checklist Phase 3

- [ ] **3.1** Tao folder `data/` trong domain package
  - Tao: `lib/src/data/`
  - Tao: `lib/src/data/repositories/`
  - Tao: `lib/src/data/network/`

- [ ] **3.2** Di chuyen repository implementations
  - `repositories/impl/auth_repository_impl.dart` -> `data/repositories/auth_repository_impl.dart`
  - `repositories/impl/user_repository_impl.dart` -> `data/repositories/user_repository_impl.dart`
  - `repositories/impl/local_storage_impl.dart` -> `data/repositories/local_storage_impl.dart`
  - `repositories/impl/user_local_repository_impl.dart` -> `data/repositories/user_local_repository_impl.dart`
  - `repositories/impl/app_setting_repository_impl.dart` -> `data/repositories/app_setting_repository_impl.dart`

- [ ] **3.3** Di chuyen network code
  - `network/auth_interceptor.dart` -> `data/network/auth_interceptor.dart`

- [ ] **3.4** Xoa folder cu
  - Xoa: `repositories/impl/` (da di chuyen)
  - Xoa: `network/` (da di chuyen)

- [ ] **3.5** Cap nhat `domain.dart` main export
  - Xoa: `export 'src/network/auth_interceptor.dart';`
  - Them export cho data layer (tam thoi)

- [ ] **3.6** Cap nhat DI registration
  - Cap nhat `domain_module.dart` neu can
  - Cap nhat `injection.dart` / `injection.config.dart`
  - Chay: `fvm dart run melos run brd`

- [ ] **3.7** Cap nhat tat ca imports o cac package khac
  - `apps/flutter_app/`
  - `packages/feature/auth/`
  - `packages/feature/app_settings/`

- [ ] **3.8** Verify toan bo
  - `fvm dart run melos run brd`
  - `fvm dart run melos run analyze`

---

### Phase 4: Tach Entity va DTO (Tuy chon, lam sau)

**Muc tieu**: Entity la pure Dart, DTO xu ly JSON mapping.

> **Luu y**: Phase nay la OPTIONAL. Neu entity hien tai dang hoat dong tot va team
> khong gap van de, co the bo qua phase nay. Chi thuc hien khi:
> - API response structure khac voi domain entity
> - Can map/transform data giua API va domain
> - Can ho tro nhieu data sources voi format khac nhau

#### Checklist Phase 4

- [ ] **4.1** Tao models (DTOs) trong data layer
  - Tao: `lib/src/data/models/`
  - Tao `user_model.dart`:
    ```dart
    @modelFreezed
    sealed class UserModel with _$UserModel {
      const factory UserModel({
        @Default(0) int id,
        @Default('') String name,
        @Default('') String email,
        String? phone,
        @JsonKey(name: 'avatar_url') String? avatarUrl,
        @Default(true) @JsonKey(name: 'is_active') bool isActive,
        @JsonKey(name: 'created_at') DateTime? createdAt,
      }) = _UserModel;

      factory UserModel.fromJson(Map<String, dynamic> json) =>
          _$UserModelFromJson(json);
    }

    // Extension de convert sang Entity
    extension UserModelMapper on UserModel {
      UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        isActive: isActive,
        createdAt: createdAt,
      );
    }
    ```

- [ ] **4.2** Chuyen Entity thanh pure Dart
  - Xoa `@JsonKey`, `fromJson`, `toJson`, `.g.dart` khoi entities
  - Giu lai cac computed properties (hasValidEmail, isInStock...)
  - Entity chi dung `@freezed` don gian hoac manual class

- [ ] **4.3** Cap nhat repository implementations dung Model
  - Api response -> `Model.fromJson()` -> `model.toEntity()` -> return Entity
  - Cache: `entity.toModel().toJson()` -> save

- [ ] **4.4** Xoa generated files cu
  - Xoa: `user_entity.g.dart`, `product_entity.g.dart`, `auth_token.g.dart`

- [ ] **4.5** Chay build_runner va verify
  - `fvm dart run melos run brd`
  - `fvm dart run melos run analyze`

---

## Thu tu uu tien thuc hien

```
Phase 1 (Use Cases)     -----> An toan nhat, lam ngay
    |
Phase 2 (Repositories)  -----> Sau Phase 1, trung binh
    |
Phase 3 (Impl di chuyen) ----> Sau Phase 2, can than
    |
Phase 4 (Entity/DTO)    -----> Optional, lam khi can
```

## Quy tac khi Refactor

1. **Moi phase tao 1 branch rieng** va merge xong truoc khi lam phase tiep
2. **Chay analyze sau moi buoc** de phat hien loi som
3. **Khong doi nhieu thu cung luc** - tung buoc nho, commit thuong xuyen
4. **Uu tien backward compatibility** - them truoc, xoa sau
5. **Test lai feature sau moi phase** de dam bao khong break

## Cac lenh can dung

```bash
# Kiem tra loi
fvm dart run melos run analyze

# Build runner
fvm dart run melos run brd

# Format code
fvm dart run melos run fm

# Tim import bi loi
fvm dart run melos run pg

# Chay test
fvm dart run melos run test
```

## Tham khao

- [clean_architecture.md](./clean_architecture.md) - Quy tac Clean Architecture hien tai
- [domain_package.md](./domain_package.md) - Huong dan domain package
- [project_structure.md](./project_structure.md) - Cau truc project
