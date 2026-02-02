part of 'user_bloc.dart';

@stateFreezed
sealed class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default([]) List<UserEntity> users,
    UserEntity? currentUser,
  }) = _UserState;

  factory UserState.initial() => const UserState();
}
