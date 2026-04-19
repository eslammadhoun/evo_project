import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

enum FirstWidget { menu, back }

enum MidWidget { nothing, searchField, text }

enum LastWidget { cart, nothing }

class HeaderWidget extends StatelessWidget {
  final FirstWidget firstWidget;
  final MidWidget midWidget;
  final LastWidget lastWidget;
  final String? text;

  const HeaderWidget({
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
        border:
            (firstWidget == FirstWidget.back &&
                midWidget == MidWidget.text &&
                lastWidget == LastWidget.nothing)
            ? null
            : BoxBorder.fromLTRB(
                bottom: BorderSide(width: 1, color: Color(0xffDBE9F5)),
              ),
      ),
      width: context.screenSize.width,
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            switch (firstWidget) {
              FirstWidget.menu => InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset('lib/assets/icons/menu.svg'),
                ),
              ),
              FirstWidget.back => InkWell(
                onTap: () => context.pop(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            },
            switch (midWidget) {
              MidWidget.nothing => const SizedBox(),
              MidWidget.searchField => Expanded(
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
              MidWidget.text => Text(
                text!,
                style: context.textStyles.bodyLarge,
              ),
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
                        '9',
                        style: context.textStyles.headlineLarge!.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => context.go(RoutePaths.cart),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('lib/assets/icons/cart.svg'),
                    ),
                  ),
                ],
              ),
              LastWidget.nothing => const SizedBox(width: 40),
            },
          ],
        ),
      ),
    );
  }
}
