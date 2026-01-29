import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/extensions/context_extensions.dart';
import 'package:flutter_starter_pro/core/utils/validators.dart';
import 'package:flutter_starter_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_starter_pro/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_starter_pro/shared/widgets/inputs/text_input.dart';

import 'package:iconsax/iconsax.dart';

/// Forgot password screen
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authNotifierProvider.notifier)
        .requestPasswordReset(_emailController.text.trim());

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent
              ? _buildSuccessContent()
              : _buildFormContent(authState),
        ),
      ),
    );
  }

  Widget _buildFormContent(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.lock_1,
              size: 40,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Forgot Password?',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Don't worry! Enter your email address and we'll send you a link to reset your password.",
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AppTextInput(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleResetPassword(),
            validator: Validators.email,
          ),
          const SizedBox(height: 24),
          if (authState.hasError && authState.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: context.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.warning_2,
                    color: context.colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      authState.errorMessage!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          PrimaryButton(
            onPressed: _handleResetPassword,
            isLoading: authState.isLoading,
            text: 'Reset Password',
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Iconsax.arrow_left, size: 18),
            label: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconsax.tick_circle,
            size: 50,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Check Your Email',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "We've sent a password reset link to:",
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Didn't receive the email? Check your spam folder or try again.",
                  style: context.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text('Try Another Email'),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Back to Sign In',
        ),
      ],
    );
  }
}
