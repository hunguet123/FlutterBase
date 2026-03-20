import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/l10n/strings.g.dart';
import 'package:flutter_base/shared/widgets/app_button.dart';
import 'package:flutter_base/shared/widgets/app_text_field.dart';
import 'package:flutter_base/shared/widgets/app_bar.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/features/auth/providers/auth_provider.dart';

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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final authAsync = ref.read(authNotifierProvider);
    final isLoading =
        authAsync.isLoading || (authAsync.asData?.value.isLoading ?? false);
    if (_formKey.currentState?.validate() != true || isLoading) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    try {
      await ref.read(authNotifierProvider.notifier).login(username, password);
    } on MaintenanceException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context).login.maintenanceError),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${Translations.of(context).login.errorLogin}: ${e.message}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);
    final isLoading =
        authAsync.isLoading || (authAsync.asData?.value.isLoading ?? false);
    final translations = Translations.of(context);

    return Scaffold(
      appBar: AppAppBar(title: translations.login.title),
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
                  labelText: translations.login.username,
                  hintText: translations.login.hintUsername,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? translations.login.hintUsername
                              : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: translations.login.password,
                  hintText: translations.login.hintPassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) => _onSubmit(),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? translations.login.hintPassword
                              : null,
                ),
                const SizedBox(height: 24),
                AppButton(
                  onPressed: _onSubmit,
                  text: translations.login.submit,
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
