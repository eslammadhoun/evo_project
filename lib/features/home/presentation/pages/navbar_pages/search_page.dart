import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.menu,
              midWidget: MidWidget.searchField,
              lastWidget: LastWidget.cart,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: Spacing.appPadding,
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,

                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) => ProductCard(cardHeight: 240),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
