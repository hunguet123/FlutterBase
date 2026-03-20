import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/shared/widgets/app_bar.dart';
import 'package:flutter_base/shared/widgets/app_button.dart';
import 'package:flutter_base/shared/widgets/app_text_field.dart';
import 'package:flutter_base/features/auth/presentation/providers/login_notifier.dart';

/// Login screen. On successful API login navigates to Home.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listen(loginNotifierProvider, (previous, next) {
      final error = next.error;
      if (error == null || error == previous?.error) return;

      // Ensure the snackbar is shown after the current frame renders.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final t = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage(error, t))),
        );
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() != true) return;
    await ref.read(loginNotifierProvider.notifier).login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
  }

  String _errorMessage(AppException error, Translations t) {
    return switch (error) {
      ValidationException e => e.message,
      MaintenanceException() => t.login.maintenanceError,
      NetworkException e => '${t.login.errorLogin}: ${e.message}',
      _ => error.message,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isLoading = ref.watch(loginNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppAppBar(title: t.login.title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: _usernameController,
                  labelText: t.login.username,
                  hintText: t.login.hintUsername,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? t.login.hintUsername : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: t.login.password,
                  hintText: t.login.hintPassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) => _onSubmit(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? t.login.hintPassword : null,
                ),
                const SizedBox(height: 24),
                AppButton(
                  onPressed: _onSubmit,
                  text: t.login.submit,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
