import 'package:auto_route/auto_route.dart';
import 'package:feature_app_settings/app_settings.dart';
import '../../app/app_router.gr.dart';
import '../../app/settings_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../extensions/l10n_extension.dart';
import 'user_bloc.dart';

@RoutePage()
class UserPage extends StatelessWidget implements AutoRouteWrapper {
  const UserPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userList),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(
                const UserEvent.loadUsers(forceRefresh: true),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.users != current.users ||
            previous.currentUser != current.currentUser,
        builder: (context, state) {
          if (state.isLoading && state.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noUsersFound,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(
                        const UserEvent.loadUsers(forceRefresh: true),
                      );
                    },
                    child: Text(l10n.reload),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserBloc>().add(
                const UserEvent.loadUsers(forceRefresh: true),
              );
            },
            child: ListView.builder(
              itemCount: state.users.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
                      child: user.avatar == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(user.name ?? l10n.unknown),
                    subtitle: Text(user.email ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showUpdateDialog(context, user.id!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, user.id!);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.read<UserBloc>().add(
                        UserEvent.loadUserProfile(user.id!),
                      );
                      _showUserDetails(context, user);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUpdateDialog(context, 1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    await context.router.push(
      AppSettingsRoute(
        strings: AppSettingsSheetStrings(
          title: l10n.settings,
          themeTitle: l10n.themeModeTitle,
          themeSystem: l10n.themeModeSystem,
          themeLight: l10n.themeModeLight,
          themeDark: l10n.themeModeDark,
          languageTitle: l10n.languageTitle,
          languageSystem: l10n.languageSystem,
          languageEnglish: l10n.languageEnglish,
          languageKorean: l10n.languageKorean,
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int userId) {
    context.router.push(
      UserUpdateRoute(
        userId: userId,
        userBloc: context.read<UserBloc>(),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int userId) {
    context.router.push(
      UserDeleteConfirmationRoute(
        userId: userId,
        userBloc: context.read<UserBloc>(),
      ),
    );
  }

  void _showUserDetails(BuildContext context, user) {
    context.router.push(UserDetailsRoute(user: user));
  }
}
