import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double? min;
  final double? max;
  final bool isDecimal;
  final bool isRequired;
  const NumberField({
    super.key,
    required this.controller,
    required this.label,
    this.min,
    this.max,
    this.isDecimal = false,
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
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (isRequired && (v?.isEmpty ?? true)) return 'required'.tr;
            final text = v ?? '';
            if (text.isEmpty) return null;
            final numVal = double.tryParse(text);
            if (numVal == null) return 'not_double'.tr;
            if (min != null && numVal < (min ?? 0))
              return 'should_be_at_least'.trParams({'min': min.toString()});
            if (max != null && numVal > (max ?? 0))
              return 'should_be_at_most'.trParams({'max': max.toString()});
            return null;
          },
          keyboardType: TextInputType.numberWithOptions(
            decimal: isDecimal,
            signed: false,
          ),
          style: TextStyle(fontSize: 16),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(isDecimal ? r'^\d*\.?\d{0,2}' : r"[0-9]"),
            ),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              if (text.isEmpty) return newValue;
              final numVal = double.tryParse(text);
              if (numVal == null) return oldValue;
              if (min != null && numVal < (min ?? 0)) return oldValue;
              if (max != null && numVal > (max ?? 0)) return oldValue;
              return newValue;
            }),
          ],
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
