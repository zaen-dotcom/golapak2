import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: isLoading
          ? const SizedBox(
              key: ValueKey('loading'),
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              text.toUpperCase(),
              key: ValueKey('text'),
              style: TextStyle(
                color: isOutlined ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: button,
    );
  }
}
