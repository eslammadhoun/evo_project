import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key});
  ValueNotifier<int> productImageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.back,
              midWidget: MidWidget.nothing,
              lastWidget: LastWidget.cart,
            ),
            Expanded(
              child: ListView(
                children: [
                  _productImages(context: context),
                  const SizedBox(height: 30),
                  _productDetails(context: context),
                  const SizedBox(height: 20),
                  Padding(
                    padding: Spacing.appPadding,
                    child: GlobalButton(
                      text: '+ ADD TO CART',
                      onTap: () => print('object'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Product Images Section
  Widget _productImages({required BuildContext context}) {
    return Container(
      width: double.infinity,
      height: context.screenSize.height * 0.55,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 222, 227, 235),
        border: BoxBorder.fromLTRB(
          top: BorderSide(width: 1, color: Color(0xffDBE9F5)),
        ),
      ),
      child: Stack(
        children: [
          PageView(
            onPageChanged: (i) => productImageIndex.value = i,
            children: List.generate(
              3,
              (index) =>
                  Image.asset('lib/assets/images/image.png', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: (context.screenSize.width - 44) / 2,
            bottom: 31,
            child: ValueListenableBuilder(
              valueListenable: productImageIndex,
              builder: (context, value, _) {
                return Row(
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
            ),
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: InkWell(
              onTap: () => print('object'),
              child: SvgPicture.asset(
                'lib/assets/icons/heart.svg',
                color: context.colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Product Details
  Widget _productDetails({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Spacing.appPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spring leather coat',
                style: context.textStyles.headlineMedium,
              ),
              Row(
                children: [
                  SvgPicture.asset('lib/assets/icons/star.svg', width: 16),
                  const SizedBox(width: 5),
                  Text('5,0', style: context.textStyles.bodyMedium),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            width: context.screenSize.width - 20,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: BoxBorder.fromLTRB(
                left: BorderSide(color: const Color(0xffDBE9F5), width: 1),
                top: BorderSide(color: const Color(0xffDBE9F5), width: 1),
                right: BorderSide.none,
                bottom: BorderSide(color: const Color(0xffDBE9F5), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$377.0', style: context.textStyles.headlineMedium),
                Row(
                  children: [
                    InkWell(
                      onTap: () => AppLogger.info('-1'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.remove_rounded,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                    Text('1', style: context.textStyles.bodySmall),
                    InkWell(
                      onTap: () => AppLogger.info('+1'),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.add_rounded,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: Spacing.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description', style: context.textStyles.headlineSmall),
              const SizedBox(height: 20),
              Text(
                'Amet amet Lorem eu consectetur in deserunt nostrud dolor culpa ad sint amet. Nostrud deserunt consectetur culpa minim mollit veniam aliquip pariatur exercitation ullamco ea voluptate et. Pariatur ipsum mollit magna proident nisi ipsum.',
                style: context.textStyles.bodyMedium,
              ),

              InkWell(
                onTap: () => print('object'),
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
            ],
          ),
        ),
      ],
    );
  }
}
