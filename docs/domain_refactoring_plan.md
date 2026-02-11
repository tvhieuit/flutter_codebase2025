# Domain Package Refactoring Plan

> **Status**: Phase 1, 2, 3 are **DONE**. Phase 4 is OPTIONAL.
> Approach chosen: **Phuong an B** (separate `packages/data` package).

## Muc tieu

Chuan hoa package `domain` theo dung Clean Architecture, dam bao:
- Domain chi chua business logic thuan (pure Dart)
- Tach biet ro rang giua domain layer va data layer
- Nhat quan ve pattern va coding style
- De test, de mo rong

---

## Hien trang va Van de

### Cau truc ban dau (truoc refactoring)

```
packages/domain/lib/src/              # MIX domain + data (VI PHAM Clean Architecture)
├── di/
│   ├── domain_module.dart            # Dio, SharedPrefs providers (infrastructure!)
├── network/
│   └── auth_interceptor.dart         # Dio interceptor (infrastructure!)
├── repositories/
│   ├── impl/                         # IMPLEMENTATIONS trong domain (vi pham!)
│   │   ├── auth_repository_impl.dart     # phu thuoc Dio
│   │   ├── user_repository_impl.dart     # phu thuoc Dio, SharedPreferences
│   │   └── ...
├── use_cases/
│   ├── user_use_case.dart            # Monolithic style (vi pham SRP)
│   └── user/                         # Single Responsibility style
```

### Cau truc sau refactoring (hien tai)

```
packages/domain/lib/src/              # CHI PURE BUSINESS LOGIC
├── di/
│   ├── injection.dart                # Only use case registrations
├── entities/                         # Business models
├── repositories/                     # INTERFACES ONLY (no impl/)
│   ├── user_repository.dart          # Remote methods only (no cache methods)
│   └── local/                        # Local interfaces
└── use_cases/                        # Single Responsibility pattern only
    ├── auth/                         # login, register, logout, refresh_token
    ├── user/                         # get, getAll, create, update, delete, getCached, clearData
    └── product/                      # get, getAll

packages/data/lib/src/                # INFRASTRUCTURE / DATA LAYER
├── di/
│   ├── data_module.dart              # Dio, SharedPrefs providers
│   └── injection.dart                # Repo impl registrations
├── network/
│   └── auth_interceptor.dart         # Dio interceptor
├── repositories/                     # All implementations
│   ├── auth_repository_impl.dart
│   ├── user_repository_impl.dart
│   ├── local_storage_impl.dart
│   ├── user_local_repository_impl.dart
│   └── app_setting_repository_impl.dart
└── storage/
    └── storage_keys.dart             # Storage key constants
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

## Cau truc muc tieu (DA HOAN THANH)

Da chon **Phuong an B**: Tao `packages/data` rieng.

Xem cau truc chi tiet tai:
- [project_structure.md](./project_structure.md) - Cau truc project day du
- [data_package.md](./data_package.md) - Data package documentation

---

## Huong tiep can: Refactor theo Phase

### Phase 1: Don dep Use Cases (It rui ro, lam truoc) - DONE

**Muc tieu**: Thong nhat ve mot pattern duy nhat cho use cases.

**Ly do lam truoc**: Khong anh huong den cac package khac, chi trong domain.

#### Checklist Phase 1

- [x] **1.1** Xoa `user_use_case.dart` (monolithic style)
  - File: `lib/src/use_cases/user_use_case.dart`
  - Kiem tra: Tim tat ca noi import/su dung `UserUseCase`, `UserUseCaseImpl`
  - Cap nhat: Chuyen sang dung individual use cases tuong ung
  - Luu y: BLoC nao dang inject `UserUseCase` phai doi sang inject individual use cases

- [x] **1.2** Xoa export `user_use_case.dart` trong barrel file
  - File: `lib/src/use_cases/use_cases.dart`
  - Xoa dong: `export 'user_use_case.dart';`

- [x] **1.3** Bo sung auth use cases
  - Tao folder: `lib/src/use_cases/auth/`
  - Tao files:
    - `login_use_case.dart` - validate credentials truoc khi goi repository
    - `register_use_case.dart` - validate registration data
    - `logout_use_case.dart` - clear tokens + user data
    - `refresh_token_use_case.dart` - refresh logic
    - `auth_input_validators.dart` - email, password validators
    - `auth_use_cases.dart` - barrel export

- [x] **1.4** Bo sung product use cases con thieu
  - Tao files trong `lib/src/use_cases/product/`:
    - `create_product_use_case.dart`
    - `update_product_use_case.dart`
    - `delete_product_use_case.dart`
  - Cap nhat `product_use_cases.dart` barrel export

- [x] **1.5** Chay build_runner va verify
  - `fvm dart run melos run brd`
  - `fvm dart run melos run analyze`

---

### Phase 2: Tach Repository Interface (Trung binh rui ro) - DONE

**Muc tieu**: Repository interfaces ro rang, tach remote vs local.

#### Checklist Phase 2

- [x] **2.1** Tach `UserRepository` thanh remote-only
  - File: `lib/src/repositories/user_repository.dart`
  - Xoa cac cache methods: `getCachedUser`, `cacheUser`, `clearCachedUser`, `cacheUserList`, `getCachedUserList`
  - Giu lai chi remote methods: `getUserById`, `getUsers`, `createUser`, `updateUser`, `deleteUser`, `searchUsers`
  - Luu y: `UserLocalRepository` da co san, dung no cho local operations

- [x] **2.2** To chuc lai folder repositories
  - Tao folder `repositories/remote/` cho remote interfaces
  - Di chuyen: `user_repository.dart`, `product_repository.dart`, `auth_repository.dart` vao `remote/`
  - Tao `remote/remote.dart` barrel export
  - Cap nhat `repositories/repositories.dart`

- [x] **2.3** Di chuyen `local_storage_keys.dart` tu `impl/` vao `local/`
  - Day la domain concept (key names), khong phai implementation
  - File: `impl/local_storage_keys.dart` -> `local/local_storage_keys.dart`
  - Cap nhat imports trong `user_local_repository.dart`, `app_settings_repository.dart`

- [x] **2.4** Cap nhat tat ca imports lien quan
  - Tim va thay the imports trong: use cases, BLoCs, feature packages
  - Chay: `fvm dart run melos run analyze` de tim loi

- [x] **2.5** Cap nhat `UserRepositoryImpl`
  - Xoa cache methods khoi impl
  - Dam bao impl chi implement remote interface moi

---

### Phase 3: Di chuyen Implementations ra khoi domain (Rui ro cao) - DONE

**Muc tieu**: Domain khong con chua implementation code.

**Approach**: Da chon **Phuong an B** - tao `packages/data` rieng (chuan hon).

#### Checklist Phase 3

- [x] **3.1** Tao package `packages/data/` (Phuong an B)
  - Tao: `packages/data/lib/src/di/` (injection, data_module)
  - Tao: `packages/data/lib/src/repositories/`
  - Tao: `packages/data/lib/src/network/`
  - Tao: `packages/data/lib/src/storage/`

- [x] **3.2** Di chuyen repository implementations sang `packages/data`
  - `domain/repositories/impl/auth_repository_impl.dart` -> `data/repositories/auth_repository_impl.dart`
  - `domain/repositories/impl/user_repository_impl.dart` -> `data/repositories/user_repository_impl.dart`
  - `domain/repositories/impl/local_storage_impl.dart` -> `data/repositories/local_storage_impl.dart`
  - `domain/repositories/impl/user_local_repository_impl.dart` -> `data/repositories/user_local_repository_impl.dart`
  - `domain/repositories/impl/app_setting_repository_impl.dart` -> `data/repositories/app_setting_repository_impl.dart`

- [x] **3.3** Di chuyen network code
  - `domain/network/auth_interceptor.dart` -> `data/network/auth_interceptor.dart`

- [x] **3.4** Di chuyen DI module
  - `domain/di/domain_module.dart` -> `data/di/data_module.dart` (rename class DataModule)

- [x] **3.5** Xoa folder cu trong domain
  - Xoa: `repositories/impl/` (da di chuyen)
  - Xoa: `network/` (da di chuyen)
  - Xoa: `di/domain_module.dart` (da di chuyen)

- [x] **3.6** Cap nhat domain
  - Xoa: `export 'src/network/auth_interceptor.dart';` tu domain.dart
  - Xoa: `dio`, `shared_preferences` tu domain/pubspec.yaml

- [x] **3.7** Cap nhat app DI
  - Them `data: any` vao flutter_app/pubspec.yaml
  - Them `initDataPackage()` vao injection.dart
  - Them `packages/data` vao root workspace

- [x] **3.8** Verify toan bo
  - Build runner: data, domain, flutter_app all pass
  - Analyze: all packages pass (0 errors)

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
Phase 1 (Use Cases)     -----> DONE
    |
Phase 2 (Repositories)  -----> DONE
    |
Phase 3 (Impl di chuyen) ----> DONE (Phuong an B - packages/data)
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
