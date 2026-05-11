import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String productName;
  final String productDescription;

  const ProductDescriptionSection({
    super.key,
    required this.productName,
    required this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('description'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Description', style: context.textStyles.headlineSmall),
          const SizedBox(height: 12),
          Text(
            productDescription,
            style: context.textStyles.bodyMedium,
            maxLines: 5,
          ),
          InkWell(
            onTap: () => context.pushNamed(
              RouteNames.productDescriptionPage,
              extra: {
                'product_name': productName,
                'product_description': productDescription,
              },
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                'read more  >',
                style: context.textStyles.bodyMedium!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
