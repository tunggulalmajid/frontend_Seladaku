import 'package:flutter/material.dart';
import 'package:frontend_ambilin/dto/register_request.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';

import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_field.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 60),
                      Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          color: AppColor.primary,
                          fontWeight: .bold,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "Buat akun untuk melanjutkan",
                        style: GoogleFonts.poppins(
                          color: AppColor.text,
                          fontWeight: .w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  WTextField(
                    hintText: "Nama lengkap",
                    controller: _namaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      if (value.length < 4) {
                        return "Nama Tidak Boleh Kurang dari 4 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 22),
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
                  SizedBox(height: 22),
                  WTextField(
                    hintText: "Password",
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 8) {
                        return "Password Tidak Boleh Kurang dari 8 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 22),
                  WTextField(
                    hintText: "Konfirmasi Password",
                    controller: _konfirmasiController,
                    isPassword: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Password Tidak Sama";
                      }
                      if (value == null || value.isEmpty) {
                        return "Konfirmasi Password tidak boleh kosong";
                      }
                      if (value.length < 8) {
                        return "Konfirmasi Password Tidak Boleh Kurang dari 8 karakter";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 22),
                  WButton(
                    text: auth.isLoading ? "Loading..." : "Sign Up",
                    onPressed: auth.isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              // Buat objek request-nya
                              final request = RegisterRequest(
                                nama: _namaController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              // Kirim ke provider
                              bool success = await auth.register(request);

                              if (!context.mounted) return;
                              _namaController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _konfirmasiController.clear();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Registrasi Berhasil! Silakan Login",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                      child: Text(
                                        "Registrasi Gagal! Cek koneksi atau email sudah ada",
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                            color: AppColor.primary,
                            fontSize: 15,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
