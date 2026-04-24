import 'package:flutter/material.dart';

import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_field.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                ),
                SizedBox(height: 22),
                WTextField(hintText: "Email", controller: _emailController),
                SizedBox(height: 22),
                WTextField(
                  hintText: "Password",
                  controller: _passwordController,
                ),
                SizedBox(height: 22),
                WTextField(
                  hintText: "Konfirmasi Password",
                  controller: _konfirmasiController,
                  isPassword: true,
                ),

                SizedBox(height: 22),
                WButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
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
    );
  }
}
