import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:domain/domain.dart';
import 'package:flutter_app/app/app_router.dart';
import 'package:flutter_app/app/app_router.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_event.dart';

part 'user_state.dart';

part 'user_bloc.freezed.dart';

/// BLoC for managing user state and operations
@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final GetUsersUseCase _getUsers;
  final GetUserUseCase _getUser;
  final UpdateUserUseCase _updateUser;
  final DeleteUserUseCase _deleteUser;
  final UserLocalRepository _userLocalRepo;
  final AppToast _toast;
  final AppRouter _route;

  UserBloc(
    this._getCurrentUser,
    this._getUsers,
    this._getUser,
    this._updateUser,
    this._deleteUser,
    this._userLocalRepo,
    this._toast,
    this._route,
  ) : super(UserState.initial()) {
    on(_onStarted);
    on(_onLoadUsers);
    on(_onLoadUserProfile);
    on(_onUpdateProfile);
    on(_onDeleteUser);
    on(_onLogout);

    // Auto-start initialization
    add(const UserEvent.started());
  }

  /// Handle started event - load cached data
  Future<void> _onStarted(_Started event, emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getCurrentUser();
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(isLoading: false));
      _toast.error(failure.message);
      return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        isInitialized: true,
        currentUser: result.dataOrNull,
      ),
    );

    // Load users in background
    add(const UserEvent.loadUsers());
  }

  /// Handle load users event
  Future<void> _onLoadUsers(_LoadUsers event, emit) async {
    emit(state.copyWith(isLoading: true));

    // Check cache first unless force refresh
    if (!event.forceRefresh) {
      final cachedResult = await _userLocalRepo.getCachedUsers();
      final cachedUsers = cachedResult.dataOrNull;
      if (cachedUsers != null && cachedUsers.isNotEmpty) {
        emit(state.copyWith(isLoading: false, users: cachedUsers));
        return;
      }
    }

    final result = await _getUsers(const GetUsersParams());
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(isLoading: false));
      _toast.error(failure.message);
      return;
    }

    emit(state.copyWith(isLoading: false, users: result.dataOrThrow));
  }

  /// Handle load user profile event
  Future<void> _onLoadUserProfile(_LoadUserProfile event, emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getUser(event.userId);
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(isLoading: false));
      _toast.error(failure.message);
      return;
    }

    emit(state.copyWith(isLoading: false, currentUser: result.dataOrThrow));
  }

  /// Handle update profile event
  Future<void> _onUpdateProfile(_UpdateProfile event, emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _updateUser(
      UpdateUserParams(
        id: event.userId,
        name: event.data['name'] as String?,
        email: event.data['email'] as String?,
        phone: event.data['phone'] as String?,
      ),
    );
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(isLoading: false));
      _toast.error(failure.message);
      return;
    }

    emit(state.copyWith(isLoading: false, currentUser: result.dataOrThrow));
  }

  /// Handle delete user event
  Future<void> _onDeleteUser(_DeleteUser event, emit) async {
    final confirmResult = await _route.push(const UserDeleteConfirmationRoute());
    if (confirmResult == false) {
      return;
    }
    emit(state.copyWith(isLoading: true));

    final result = await _deleteUser(event.userId);
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(isLoading: false));
      _toast.error(failure.message);
      return;
    }

    emit(state.copyWith(isLoading: false, currentUser: null));
    //todo navigate to login again
  }

  /// Handle logout event
  Future<void> _onLogout(_Logout event, emit) async {
    emit(state.copyWith(isLoading: true));

    await _userLocalRepo.clearAllUserData();

    emit(
      state.copyWith(
        isLoading: false,
        currentUser: null,
        users: [],
      ),
    );
  }
}
