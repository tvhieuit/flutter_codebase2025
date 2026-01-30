# BLoC Pattern Rules

## Required Structure

### 1. Event (Freezed)
```dart
@eventFreezed
sealed class MyFeatureEvent with _$MyFeatureEvent {
  const factory MyFeatureEvent.started() = _Started;
  const factory MyFeatureEvent.loadData() = _LoadData;
}
```

### 2. State (Freezed)
```dart
@stateFreezed
sealed class MyFeatureState with _$MyFeatureState {
  const MyFeatureState._();

  const factory MyFeatureState({
    @Default(false) bool isLoading,
    String? data,
  }) = _MyFeatureState;

  factory MyFeatureState.initial() => const MyFeatureState();
}
```

### 3. BLoC (Injectable + Router + AppToast)
```dart
@injectable
class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> {
  final MyFeatureUseCase _useCase;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  MyFeatureBloc(
    this._useCase,
    this._router,
    this._appRoute,
    this._toast,
  ) : super(MyFeatureState.initial()) {
    on(_onStarted);
    on(_onLoadData);

    // Auto-start initialization
    add(const MyFeatureEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _useCase.getData();
      emit(state.copyWith(isLoading: false, data: result));
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }
}
```

### 4. Page (AutoRouteWrapper)
```dart
@RoutePage()
class MyFeaturePage extends StatelessWidget implements AutoRouteWrapper {
  const MyFeaturePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyFeatureBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFeatureBloc, MyFeatureState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Scaffold(/* UI */);
      },
    );
  }
}
```

## Required Annotations

### BLoC
- `@injectable` - For dependency injection
- Inject `StackRouter` for navigation
- Inject `AppRoute` for route definitions
- Inject `AppToast` for error/success messages
- Auto-start with `add()` in constructor

### Event & State
- `@eventFreezed` - For event classes
- `@stateFreezed` - For state classes
- `sealed class` for both Event and State
- Factory constructors for all variants

### Page
- `@RoutePage()` - For auto_route
- `implements AutoRouteWrapper` - For BLoC provider

## Navigation & Error Handling

### Navigation
- Inject `StackRouter` and `AppRoute` into the BLoC via constructor
- Navigate directly in the BLoC: `_router.replaceAll([_appRoute.home])`
- Do NOT use `BlocListener` for navigation
- Do NOT use `context.router` from the UI layer for bloc-driven navigation

### Error Handling
- Use `try/catch` with `_toast` for showing errors
- Catch `Failure` first, then generic `catch` for unexpected errors
- Do NOT store `error` in state for display via `BlocListener`
- Do NOT use `ScaffoldMessenger`/`SnackBar` for errors; use `AppToast`

## Best Practices

### DO
- Use `buildWhen` in BlocBuilder
- Use `emit` without type annotation
- Use `on()` without type parameter
- Auto-initialize in constructor
- Use `try/catch` + `_toast` for error handling
- Use `const` for widgets when possible
- Navigate via injected `StackRouter` in the BLoC
- Show errors via injected `AppToast` in the BLoC

### DON'T
- Don't skip `buildWhen`
- Don't use `Emitter<State>` type
- Don't use `on<Event>()` with type
- Don't add events in `wrappedRoute()`
- Don't inject Repositories directly
- Don't make direct API calls
- Don't use `BlocListener` for navigation
- Don't use `BlocListener` + `SnackBar` for errors
- Don't store `error` in state for UI display
- Don't use `SafetyNetworkMixin` with `safeNetworkCall` (use try/catch + _toast)
