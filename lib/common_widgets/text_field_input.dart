import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final bool isPass;
  const TextFieldInput({
    super.key,
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 243, 171, 182), width: 1),
        borderRadius: BorderRadius.circular(50));

    final outputBorder = OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 244, 219, 224), width: 1),
        borderRadius: BorderRadius.circular(50));

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: outputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      cursorColor: const Color.fromARGB(255, 251, 159, 182),
      cursorWidth: 2,
      cursorHeight: 19,
    );
  }
}
