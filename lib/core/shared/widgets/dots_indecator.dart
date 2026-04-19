import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DotsIndecator extends StatelessWidget {
  final ValueListenable<int> valueListenable;
  const DotsIndecator({super.key, required this.valueListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: valueListenable,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (dotIndex) => Container(
              margin: const EdgeInsets.only(right: 6),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: dotIndex == value
                    ? context.colors.primary
                    : context.colors.tertiary,
              ),
            ),
          ),
        );
      },
    );
  }
}
