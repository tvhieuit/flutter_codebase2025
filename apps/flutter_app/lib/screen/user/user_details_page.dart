import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../extensions/l10n_extension.dart';

@RoutePage()
class UserDetailsPage extends StatelessWidget {
  final dynamic user;

  const UserDetailsPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name ?? l10n.userDetails,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text('${l10n.userEmail}: ${user.email ?? "N/A"}'),
        const SizedBox(height: 8),
        Text('${l10n.userPhone}: ${user.phone ?? "N/A"}'),
        const SizedBox(height: 8),
        Text('${l10n.userCreated}: ${user.createdAt ?? "N/A"}'),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.router.back(),
              child: Text(l10n.close),
            ),
          ],
        ),
      ],
    );
  }
}
