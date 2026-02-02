import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'register_bloc.dart';
import '../../l10n/l10n.dart';

/// Register page
@RoutePage()
class RegisterPage extends StatelessWidget implements AutoRouteWrapper {
  const RegisterPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<RegisterBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _RegisterView();
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.authL10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Title
                const Icon(
                  Icons.person_add_outlined,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),

                // Name field
                _nameField(l10n),
                const SizedBox(height: 16),

                // Email field
                _emailField(l10n),
                const SizedBox(height: 16),

                // Phone field (optional)
                _phoneField(l10n),
                const SizedBox(height: 16),

                // Password field
                _passwordField(l10n),
                const SizedBox(height: 16),

                // Confirm Password field
                _confirmPasswordField(l10n),
                const SizedBox(height: 32),

                // Register button
                SizedBox(height: 50, child: _registerButton(l10n)),
                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount),
                    TextButton(
                      onPressed: _login,
                      child: Text(l10n.loginButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerButton(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isLoading ? null : _register,
          child: state.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.registerButton),
        );
      },
    );
  }

  Widget _nameField(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError || prev.error != curr.error,
      builder: (context, state) {
        return TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.fullNameLabel,
            hintText: l10n.fullNameHint,
            prefixIcon: const Icon(Icons.person_outline),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'name' ? state.error : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.fullNameRequired;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _emailField(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError || prev.error != curr.error,
      builder: (context, state) {
        return TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            hintText: l10n.emailHint,
            prefixIcon: const Icon(Icons.email_outlined),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'email' ? state.error : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.emailRequired;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _phoneField(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError || prev.error != curr.error,
      builder: (context, state) {
        return TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.phoneLabel,
            hintText: l10n.phoneHint,
            prefixIcon: const Icon(Icons.phone_outlined),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'phone' ? state.error : null,
          ),
        );
      },
    );
  }

  Widget _passwordField(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError ||
          prev.error != curr.error ||
          prev.obscurePassword != curr.obscurePassword,
      builder: (context, state) {
        return TextFormField(
          controller: _passwordController,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'password' ? state.error : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: _obscurePasswordToggle,
            ),
            helperText: l10n.passwordHelper,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.passwordRequired;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _confirmPasswordField(AuthLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError ||
          prev.error != curr.error ||
          prev.obscureConfirmPassword != curr.obscureConfirmPassword,
      builder: (context, state) {
        return TextFormField(
          controller: _confirmPasswordController,
          obscureText: state.obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.confirmPasswordLabel,
            hintText: l10n.confirmPasswordHint,
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'confirmPassword'
                ? state.error
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: _obscureConfirmPasswordToggle,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.confirmPasswordRequired;
            }
            if (value != _passwordController.text) {
              return l10n.passwordsDoNotMatch;
            }
            return null;
          },
          onFieldSubmitted: (_) => _register(),
        );
      },
    );
  }

  void _login() {
    context.read<RegisterBloc>().add(const RegisterEvent.login());
  }

  void _obscurePasswordToggle() {
    context.read<RegisterBloc>().add(
      const RegisterEvent.obscurePasswordToggle(),
    );
  }

  void _obscureConfirmPasswordToggle() {
    context.read<RegisterBloc>().add(
      const RegisterEvent.obscureConfirmPasswordToggle(),
    );
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterBloc>().add(
        RegisterEvent.submit(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        ),
      );
    }
  }
}
