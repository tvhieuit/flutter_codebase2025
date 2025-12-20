import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../app_mixin/safety_network_mixin.dart';
import '../../entities/user_model.dart';
import '../../use_case/user_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

/// BLoC for managing user state and operations
@injectable
class UserBloc extends Bloc<UserEvent, UserState> with SafetyNetworkMixin {
  final UserUseCase _useCase;

  UserBloc(this._useCase) : super(UserState.initial()) {
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
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        // Try to load cached user
        final cachedUser = await _useCase.getCachedUser();

        emit(
          state.copyWith(
            isLoading: false,
            isInitialized: true,
            currentUser: cachedUser,
          ),
        );

        // Load users in background
        add(const UserEvent.loadUsers());
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  /// Handle load users event
  Future<void> _onLoadUsers(_LoadUsers event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        final users = await _useCase.getUsers(forceRefresh: event.forceRefresh);

        emit(
          state.copyWith(
            isLoading: false,
            users: users,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  /// Handle load user profile event
  Future<void> _onLoadUserProfile(_LoadUserProfile event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        final user = await _useCase.getUserProfile(event.userId);

        emit(
          state.copyWith(
            isLoading: false,
            currentUser: user,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  /// Handle update profile event
  Future<void> _onUpdateProfile(_UpdateProfile event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        final updatedUser = await _useCase.updateUserProfile(
          event.userId,
          event.data,
        );

        emit(
          state.copyWith(
            isLoading: false,
            currentUser: updatedUser,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  /// Handle delete user event
  Future<void> _onDeleteUser(_DeleteUser event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        await _useCase.deleteUser(event.userId);

        emit(
          state.copyWith(
            isLoading: false,
            currentUser: null,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  /// Handle logout event
  Future<void> _onLogout(_Logout event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      call: () async {
        await _useCase.logout();

        emit(
          state.copyWith(
            isLoading: false,
            currentUser: null,
            users: [],
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }
}
