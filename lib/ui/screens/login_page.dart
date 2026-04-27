import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_field.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      "Log In",
                      style: GoogleFonts.poppins(
                        color: AppColor.primary,
                        fontWeight: .bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "Selamat datang kembali!",
                      style: GoogleFonts.poppins(
                        color: AppColor.text,
                        fontWeight: .w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                WTextField(hintText: "Email", controller: _emailController),
                SizedBox(height: 22),
                WTextField(
                  hintText: "Password",
                  controller: _passwordController,
                  isPassword: true,
                ),

                SizedBox(height: 22),
                WButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, "/main");
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "Sign Up",
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
