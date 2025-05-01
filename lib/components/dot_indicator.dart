import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotCount;

  const DotIndicator({Key? key, required this.currentIndex, this.dotCount = 2})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color:
                currentIndex == index
                    ? AppColors
                        .primary // Warna oranye untuk titik aktif
                    : AppColors.primary.withOpacity(
                      0.3,
                    ), // Warna oranye transparan
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
