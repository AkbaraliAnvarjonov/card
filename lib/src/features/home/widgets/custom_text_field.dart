import 'package:card_input/src/core/utils/widgets/masked_input_formatter.dart';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.textEditingController,
    required this.prefix,
    required this.hintText,
    this.suffix,
    this.maxLength = 19,
    this.maskPattern = '#### #### #### ####',
    super.key,
  });

  final TextEditingController textEditingController;
  final int maxLength;
  final String maskPattern;
  final IconData prefix;
  final String hintText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      autofocus: false,
      obscureText: false,
      inputFormatters: [MaskedInputFormatter(maskPattern: maskPattern)],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
        suffix: suffix,
        prefix: Icon(prefix),
        counterText: '',
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
