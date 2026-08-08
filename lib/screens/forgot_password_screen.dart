import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().resetPassword(
        emailController.text.trim(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text(
              "Password reset link has been sent to your email.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      String message = "Something went wrong";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "invalid-email":
            message = "Please enter a valid email.";
            break;

          case "user-not-found":
            message = "No account found with this email.";
            break;

          case "network-request-failed":
            message =
            "No internet connection.";
            break;

          default:
            message =
                e.message ?? "Password reset failed.";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(
                Icons.lock_reset,
                size: 90,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter your email";
                  }

                  final regex = RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (!regex.hasMatch(value.trim())) {
                    return "Enter a valid email";
                  }

                  return null;
                },
                decoration:
                const InputDecoration(
                  labelText: "Email",
                  prefixIcon:
                  Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : resetPassword,
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Send Reset Link",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}