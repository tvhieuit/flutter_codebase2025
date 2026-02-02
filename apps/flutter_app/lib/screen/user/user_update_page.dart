import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../extensions/l10n_extension.dart';
import 'user_bloc.dart';

@RoutePage()
class UserUpdatePage extends StatefulWidget {
  final int userId;
  final UserBloc userBloc;

  const UserUpdatePage({
    super.key,
    required this.userId,
    required this.userBloc,
  });

  @override
  State<UserUpdatePage> createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.updateUser,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.userName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: l10n.userEmail,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => context.router.back(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final data = {
                  'name': nameController.text,
                  'email': emailController.text,
                };

                widget.userBloc.add(
                  UserEvent.updateProfile(widget.userId, data),
                );

                context.router.back();
              },
              child: Text(l10n.update),
            ),
          ],
        ),
      ],
    );
  }
}
