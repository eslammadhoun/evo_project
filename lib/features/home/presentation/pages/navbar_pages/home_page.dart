import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/dots_indecator.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HeaderWidget(
                  firstWidget: FirstWidget.menu,
                  midWidget: MidWidget.nothing,
                  lastWidget: LastWidget.cart,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      ...List.generate(
                        3,
                        (index) => SliverFillRemaining(
                          hasScrollBody: true,
                          child: index == 0
                              ? _heroSection(context: context)
                              : _bannerWidget(context: context),
                        ),
                      ),
                      SliverToBoxAdapter(child: _listSection(context)),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: kToolbarHeight + 20,
              right: 20,
              child: SvgPicture.asset('lib/assets/icons/app_logo.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroSection({required BuildContext context}) {
    return Container(
      width: double.infinity,
      color: Color(0xffECF3FA),
      child: Stack(
        children: [
          PageView(
            onPageChanged: (i) => pageIndex.value = i,
            children: List.generate(
              3,
              (index) => _bannerWidget(context: context),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      'SHOP NOW',
                      style: context.textStyles.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: context.colors.primary,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                DotsIndecator(valueListenable: pageIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerWidget({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          top: BorderSide(color: Color(0xffDBE9F5), width: 4),
        ),
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
            bottom: 140,
            left: 20,
            child: Text(
              'Black Friday sale!\nSave up to 25%',
              style: context.textStyles.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listSection(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 50),
        _featuredProducts(context: context),
      ],
    );
  }

  // Featured Products Section
  Widget _featuredProducts({required BuildContext context}) {
    return Column(
      children: [
        Padding(
          padding: Spacing.appPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured products',
                style: context.textStyles.headlineMedium,
              ),
              GestureDetector(
                onTap: () => print('Viewing All'),
                child: Row(
                  children: [
                    Text(
                      'view  all',
                      style: context.textStyles.bodyMedium!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ProductCard(cardHeight: 200),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
