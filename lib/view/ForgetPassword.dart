import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../confi/NavigationServices.dart';
import '../confi/routes/routesname.dart';
import '../widgets/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Reset Your Password',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email and we’ll send reset instructions.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildTextField(controller: emailController, label: 'Email'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  showSnackBar(context, "Please enter your email.",
                      isSuccess: false);
                } else {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                    showSnackBar(
                        context, "Password reset link sent to $email.");
                    NavigatorServices.goBack();
                  } on FirebaseAuthException catch (e) {
                    showSnackBar(
                        context, e.message ?? "Failed to send reset email.",
                        isSuccess: false);
                  } catch (e) {
                    showSnackBar(context, "An unexpected error occurred.",
                        isSuccess: false);
                  }
                }
              },
              child: const Text(
                'Send Reset Link',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                NavigatorServices.NavigationTo(RoutesName.login_route);
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
