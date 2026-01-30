import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../entities/user_model.dart';
import '../../use_case/user_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

/// BLoC for managing user state and operations
@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserUseCase _useCase;
  final AppToast _toast;

  UserBloc(this._useCase, this._toast) : super(UserState.initial()) {
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

    try {
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
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }

  /// Handle load users event
  Future<void> _onLoadUsers(_LoadUsers event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final users = await _useCase.getUsers(forceRefresh: event.forceRefresh);

      emit(
        state.copyWith(
          isLoading: false,
          users: users,
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }

  /// Handle load user profile event
  Future<void> _onLoadUserProfile(_LoadUserProfile event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await _useCase.getUserProfile(event.userId);

      emit(
        state.copyWith(
          isLoading: false,
          currentUser: user,
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }

  /// Handle update profile event
  Future<void> _onUpdateProfile(_UpdateProfile event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
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
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }

  /// Handle delete user event
  Future<void> _onDeleteUser(_DeleteUser event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _useCase.deleteUser(event.userId);

      emit(
        state.copyWith(
          isLoading: false,
          currentUser: null,
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }

  /// Handle logout event
  Future<void> _onLogout(_Logout event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _useCase.logout();

      emit(
        state.copyWith(
          isLoading: false,
          currentUser: null,
          users: [],
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error(e.message);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }
}
