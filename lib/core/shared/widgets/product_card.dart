import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenSize.width * 0.36,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'lib/assets/images/image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => AppLogger.info('added to fav'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          'lib/assets/icons/heart.svg',
                          color: context.colors.secondary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => print('Tapped'),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Long summer dress', style: context.textStyles.bodySmall),
          const SizedBox(height: 4),
          Text('\$245.9', style: context.textStyles.labelMedium),
        ],
      ),
    );
  }
}
