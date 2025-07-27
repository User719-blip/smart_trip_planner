import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final bool isObscureText;
  final TextEditingController? controller; 

  const AuthField({
    super.key,
    required this.hintText,
    this.isObscureText = false,
    required this.icon, 
    required this.controller,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isObscureText;
    super.initState();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller : widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        suffixIcon: widget.isObscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _toggleVisibility,
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.hintText} cannot be empty';
        }
        return null;
      },
    );
  }
}
