import 'package:auto_route/auto_route.dart';
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
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) => previous.error != current.error && current.error != null,
      listener: (context, state) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User List'),
          actions: [
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
                      'No users found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          const UserEvent.loadUsers(forceRefresh: true),
                        );
                      },
                      child: const Text('Reload'),
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
                      title: Text(user.name ?? 'Unknown'),
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
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int userId) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final data = {
                'name': nameController.text,
                'email': emailController.text,
              };

              context.read<UserBloc>().add(
                UserEvent.updateProfile(userId, data),
              );

              Navigator.pop(dialogContext);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(
                UserEvent.deleteUser(userId),
              );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name ?? 'User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email ?? "N/A"}'),
            const SizedBox(height: 8),
            Text('Phone: ${user.phone ?? "N/A"}'),
            const SizedBox(height: 8),
            Text('Created: ${user.createdAt ?? "N/A"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
