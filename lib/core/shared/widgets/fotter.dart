import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:evo_project/core/constants/spacing.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

enum FirstWidget { menu, back }

enum MidWidget { nothing, searchField, text }

enum LastWidget { cart, nothing }

class FotterWidget extends StatelessWidget {
  final FirstWidget firstWidget;
  final MidWidget midWidget;
  final LastWidget lastWidget;
  final String? text;

  const FotterWidget({
    super.key,
    required this.firstWidget,
    required this.midWidget,
    required this.lastWidget,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(width: 1, color: Color(0xffDBE9F5)),
        ),
      ),
      width: context.screenSize.width,
      height: kToolbarHeight,
      child: Padding(
        padding: Spacing.appPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            switch (firstWidget) {
              FirstWidget.menu => InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: SvgPicture.asset('lib/assets/icons/menu.svg'),
              ),
              FirstWidget.back => InkWell(
                onTap: () => context.pop(),
                child: Icon(Icons.arrow_back_ios),
              ),
            },
            switch (midWidget) {
              MidWidget.nothing => const SizedBox(),
              MidWidget.searchField => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.colors.secondary,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle: context.textStyles.bodyMedium,
                    ),
                  ),
                ),
              ),
              MidWidget.text => Text(text!),
            },
            switch (lastWidget) {
              LastWidget.cart => Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.primary,
                    ),
                    child: Center(
                      child: Text(
                        '0',
                        style: context.textStyles.headlineLarge!.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset('lib/assets/icons/cart.svg'),
                  ),
                ],
              ),
              LastWidget.nothing => const SizedBox(width: 30),
            },
          ],
        ),
      ),
    );
  }
}
