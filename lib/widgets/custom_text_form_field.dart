import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isNumber;
  final String label;
  final String hint;
  final TextEditingController controller;
  final Key formkey;
  const CustomTextFormField(
      {super.key,
      required this.isNumber,
      required this.label,
      required this.hint,
      required this.controller,
      required this.formkey});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        keyboardType:
            widget.isNumber! ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          label: Text(widget.label),
          hintText: widget.hint,
        ),
        controller: widget.controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Cannot be Empty";
          } else {
            null;
          }
        },
      ),
    );
  }
}
