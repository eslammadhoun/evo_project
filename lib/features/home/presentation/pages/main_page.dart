import 'package:evo_project/core/shared/widgets/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          gradient: LinearGradient(
            colors: [const Color(0xFF0F2A3C), const Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: CustomNavBar(
            selectedIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(index);
            },
          ),
        ),
      ),
    );
  }
}
