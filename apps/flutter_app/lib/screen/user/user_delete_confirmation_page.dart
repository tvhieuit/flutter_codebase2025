import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'user_bloc.dart';

@RoutePage()
class UserDeleteConfirmationPage extends StatelessWidget {
  final int userId;
  final UserBloc userBloc;

  const UserDeleteConfirmationPage({
    super.key,
    required this.userId,
    required this.userBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delete User',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text('Are you sure you want to delete this user?'),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.router.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userBloc.add(
                  UserEvent.deleteUser(userId),
                );
                context.router.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}
