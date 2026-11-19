import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/controllers/base_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: GetBuilder<ProfileController>(
        builder: (_) {
          if (!controller.isConfigured) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Connect Supabase to use accounts and orders. '
                  'See the README for setup instructions.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (controller.isInitializing) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: EdgeInsets.all(24.w),
            children: [
              if (controller.isSignedIn) ...[
                CircleAvatar(
                  radius: 34.r,
                  child: const Icon(Icons.person_outline, size: 32),
                ),
                16.verticalSpace,
                Text(
                  controller.user?.userMetadata?['display_name'] as String? ??
                      controller.user?.email ??
                      'Your account',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                6.verticalSpace,
                Text(
                  controller.user?.email ?? '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                20.verticalSpace,
                OutlinedButton.icon(
                  onPressed: controller.isBusy ? null : controller.signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
                28.verticalSpace,
                FilledButton.icon(
                  onPressed: () => Get.find<BaseController>().changeScreen(3),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('View orders'),
                ),
              ] else ...[
                Text(
                  'Shop with an account',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                8.verticalSpace,
                Text(
                  'Create an account to keep your orders and profile in one place.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                24.verticalSpace,
                if (controller.isCreatingAccount)
                  TextField(
                    controller: controller.nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    helperText: 'At least 8 characters',
                  ),
                ),
                if (controller.errorMessage != null) ...[
                  12.verticalSpace,
                  Text(
                    controller.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                20.verticalSpace,
                FilledButton(
                  onPressed: controller.isBusy ? null : controller.submitAuth,
                  child: controller.isBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          controller.isCreatingAccount
                              ? 'Create account'
                              : 'Sign in',
                        ),
                ),
                TextButton(
                  onPressed:
                      controller.isBusy ? null : controller.toggleAuthMode,
                  child: Text(
                    controller.isCreatingAccount
                        ? 'Already have an account? Sign in'
                        : 'New here? Create an account',
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
