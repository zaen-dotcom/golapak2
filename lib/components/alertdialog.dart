import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const CustomAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(message, style: theme.textTheme.bodyLarge),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(cancelText!, style: TextStyle(color: Colors.black)),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Ya',
  String cancelText = 'Batal',
}) async {
  bool confirmed = false;

  await showDialog(
    context: context,
    builder: (context) => CustomAlert(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: () {
        confirmed = true;
        Navigator.of(context).pop();
      },
      onCancel: () => Navigator.of(context).pop(),
    ),
  );

  return confirmed;
}

