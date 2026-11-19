import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/custom_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../data/services/supabase_service.dart';
import '../../base/controllers/base_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  User? user;
  bool isCreatingAccount = true;
  bool isBusy = false;
  bool isInitializing = true;
  String? errorMessage;

  bool get isConfigured => SupabaseService.isConfigured;
  bool get isSignedIn => user != null && !user!.isAnonymous;

  @override
  void onInit() {
    super.onInit();
    initializeAuth();
  }

  Future<void> initializeAuth() async {
    if (!isConfigured) {
      isInitializing = false;
      update();
      return;
    }
    try {
      await StoreRepository.ensureUserSession();
      refreshUser();
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isInitializing = false;
      update();
    }
  }

  void refreshUser() {
    user = isConfigured ? AuthRepository.currentUser : null;
    update();
  }

  Future<void> submitAuth() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (isCreatingAccount && name.isEmpty) {
      _showError('Enter your name.');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      _showError('Enter a valid email address.');
      return;
    }
    if (password.length < 8) {
      _showError('Password must be at least 8 characters.');
      return;
    }

    isBusy = true;
    errorMessage = null;
    update();
    try {
      if (isCreatingAccount) {
        await AuthRepository.createAccount(
          name: name,
          email: email,
          password: password,
        );
        CustomSnackBar.showCustomSnackBar(
          title: 'Account created',
          message:
              'Check your email to verify your address if email confirmation is enabled.',
        );
      } else {
        await AuthRepository.signIn(email: email, password: password);
        CustomSnackBar.showCustomSnackBar(
          title: 'Welcome back',
          message: 'You are signed in.',
        );
      }
      refreshUser();
      await Get.find<BaseController>().loadCart();
      if (Get.isRegistered<CalendarController>()) {
        await Get.find<CalendarController>().loadOrders();
      }
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isBusy = false;
      update();
    }
  }

  Future<void> signOut() async {
    isBusy = true;
    update();
    try {
      await AuthRepository.signOut();
      user = AuthRepository.currentUser;
      await Get.find<BaseController>().loadCart();
      if (Get.isRegistered<CalendarController>()) {
        await Get.find<CalendarController>().loadOrders();
      }
    } on Exception catch (error) {
      errorMessage = error.toString();
    } finally {
      isBusy = false;
      update();
    }
  }

  void toggleAuthMode() {
    isCreatingAccount = !isCreatingAccount;
    errorMessage = null;
    update();
  }

  void _showError(String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Check your details',
      message: message,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
