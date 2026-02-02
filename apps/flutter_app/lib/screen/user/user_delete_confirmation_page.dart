import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../extensions/l10n_extension.dart';
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
        Text(
          l10n.deleteUser,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(l10n.deleteConfirmation),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.router.back(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                userBloc.add(
                  UserEvent.deleteUser(userId),
                );
                context.router.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}
