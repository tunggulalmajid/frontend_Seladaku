import 'package:flutter/material.dart';
import 'package:seladaku/ui/widgets/w_button.dart';
import 'package:seladaku/ui/widgets/w_failed_dialog.dart';
import 'package:seladaku/ui/widgets/w_success_dialog.dart';
import 'package:seladaku/ui/widgets/w_text.dart';
import 'package:seladaku/ui/widgets/w_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../dto/login_request.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Text(
                  "Log In",
                  style: GoogleFonts.poppins(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                Text(
                  "Selamat datang kembali!",
                  style: GoogleFonts.poppins(
                    color: AppColor.text,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),

                WTextField(
                  hintText: "Email",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    if (!value.contains("@")) {
                      return "Gunakan format email yang benar";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                WTextField(
                  hintText: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                WButton(
                  text: auth.isLoading ? "Loading..." : "Sign In",
                  onPressed: auth.isLoading
                      ? () {}
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final request = LoginRequest(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            try {
                              bool success = await auth.login(request);
                              _emailController.clear();
                              _passwordController.clear();

                              if (!context.mounted) return;
                              if (success) {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (c) => WSuccessDialog(
                                    message: "Login Berhasil",
                                    onOkPressed: () {
                                      Navigator.pop(c);
                                    },
                                  ),
                                );
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.main,
                                    (route) => false,
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (c) => WFailedDialog(
                                    message: "Username atau Password Salah",
                                    onOkPressed: () {
                                      Navigator.pop(c);
                                    },
                                  ),
                                );
                              }
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (c) => WFailedDialog(
                                  message: "error : $e",
                                  onOkPressed: () {
                                    Navigator.pop(c);
                                  },
                                ),
                              );
                            }
                          }
                        },
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        color: AppColor.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
