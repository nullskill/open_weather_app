import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool inverted;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.inverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: inverted ? Colors.grey[200] : const Color(0xFF0700FF),
        foregroundColor: inverted ? const Color(0xFF0700FF) : Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(text),
    );
  }
}
