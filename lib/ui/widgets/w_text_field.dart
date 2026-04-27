import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class WTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const WTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: GoogleFonts.poppins(color: AppColor.text),
      decoration: InputDecoration(
        //label text belum dimasukkan
        hintText: widget.hintText,
        fillColor: AppColor.primaryAccent,
        filled: true,

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.text,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: AppColor.primary, width: 2.0),
        ),
      ),
    );
  }
}
