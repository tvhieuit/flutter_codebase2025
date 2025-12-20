# BLoC Pattern Rules

## Required Structure

### 1. Event (Freezed)
```dart
@freezed
class MyFeatureEvent with _$MyFeatureEvent {
  const factory MyFeatureEvent.started() = _Started;
  const factory MyFeatureEvent.loadData() = _LoadData;
}
```

### 2. State (Freezed)
```dart
@freezed
class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default(false) bool isLoading,
    String? data,
    String? error,
  }) = _MyFeatureState;
  
  factory MyFeatureState.initial() => const MyFeatureState();
}
```

### 3. BLoC (Injectable + SafetyNetworkMixin)
```dart
@injectable
class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> 
    with SafetyNetworkMixin {
  final MyFeatureUseCase _useCase;
  
  MyFeatureBloc(this._useCase) : super(MyFeatureState.initial()) {
    on(_onStarted);
    on(_onLoadData);
    
    // Auto-start initialization
    add(const MyFeatureEvent.started());
  }
  
  Future<void> _onStarted(_Started event, emit) async {
    emit(state.copyWith(isLoading: true));
    
    await safeNetworkCall(() async {
      final result = await _useCase.getData();
      emit(state.copyWith(isLoading: false, data: result));
    });
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
- ✅ `@injectable` - For dependency injection
- ✅ `with SafetyNetworkMixin` - For safe API calls
- ✅ Auto-start with `add()` in constructor

### Event & State
- ✅ `@freezed` - For immutability and code generation
- ✅ Factory constructors for all variants

### Page
- ✅ `@RoutePage()` - For auto_route
- ✅ `implements AutoRouteWrapper` - For BLoC provider

## Best Practices

### ✅ DO
- Use `buildWhen` in BlocBuilder
- Use `listenWhen` in BlocListener
- Use `emit` without type annotation
- Use `on()` without type parameter
- Auto-initialize in constructor
- Wrap API calls with `safeNetworkCall()`
- Use `const` for widgets when possible

### ❌ DON'T
- Don't skip `buildWhen`/`listenWhen`
- Don't use `Emitter<State>` type
- Don't use `on<Event>()` with type
- Don't add events in `wrappedRoute()`
- Don't inject Repositories
- Don't make direct API calls

