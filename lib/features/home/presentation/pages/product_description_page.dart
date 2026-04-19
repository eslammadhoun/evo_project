import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:flutter/material.dart';

class ProductDescriptionPage extends StatelessWidget {
  final String productName;
  final String productDescription;
  const ProductDescriptionPage({
    super.key,
    required this.productName,
    required this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                firstWidget: FirstWidget.back,
                midWidget: MidWidget.text,
                lastWidget: LastWidget.nothing,
                text: 'Description',
              ),
              const SizedBox(height: 40),
              Text(productName, style: context.textStyles.headlineMedium),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: productDescription
                        .split('. ')
                        .map(
                          (paragraph) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              '${paragraph.trim()}.',
                              style: context.textStyles.bodyMedium!.copyWith(
                                height: 1.6,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
