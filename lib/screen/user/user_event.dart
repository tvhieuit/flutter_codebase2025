part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadUsers({@Default(false) bool forceRefresh}) = _LoadUsers;
  const factory UserEvent.loadUserProfile(int userId) = _LoadUserProfile;
  const factory UserEvent.updateProfile(int userId, Map<String, dynamic> data) = _UpdateProfile;
  const factory UserEvent.deleteUser(int userId) = _DeleteUser;
  const factory UserEvent.logout() = _Logout;
}
