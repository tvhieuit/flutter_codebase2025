part of 'user_bloc.dart';

@eventFreezed
sealed class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default([]) List<UserModel> users,
    UserModel? currentUser,
  }) = _UserState;

  factory UserState.initial() => const UserState();
}
