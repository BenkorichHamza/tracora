import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool autoFocus;
  final bool isRequired;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.autoFocus = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final filled = value.text.isEmpty;
        return TextFormField(
          controller: controller,
          autofocus: autoFocus,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            labelText: label,
            labelStyle: TextStyle(fontSize: 14),
            filled: filled,
            fillColor: Colors.yellow.withAlpha(25),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: isRequired ? Icon(Icons.star, color: Colors.red) : null,
          ),
        );
      },
    );
  }
}
