import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;

  const AppPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(title),
      ),
    );
  }
}