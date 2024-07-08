import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/presentacion/paginas/registrar_pagina.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc_provider.dart';
import 'package:restaurant_app/features/menu/view/widget/blur_card.dart';
import 'package:restaurant_app/features/mesa/presentacion/pages/seleccionar_mesa.dart';
import 'package:restaurant_app/features/productos/presentacion/pages/registrar_productos.dart';

class InstagramNavigationScreen extends StatefulWidget {
  const InstagramNavigationScreen({super.key});

  @override
  InstagramNavigationScreenState createState() =>
      InstagramNavigationScreenState();
}

class InstagramNavigationScreenState extends State<InstagramNavigationScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final instagramBloc = MenuBlocProvider.of(context)!.instagramBloc;
    final topInset = MediaQuery.of(context).padding.top;
    final settingsHeight = MediaQuery.of(context).size.height * .25 + topInset;

    return Scaffold(
      body: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: [
                const SeleccionarMesaPage(),
                const Scaffold(body: Center(child: Text('Explore'))),
                const Scaffold(body: Center(child: Text('Add'))),
                const RegistrarEmpleadoPagina(),
                const RegistrarProductoPage(),
              ][index],
            ),

            //------------------------------
            // SETTINGS BLUR CARD
            //------------------------------
            AnimatedBuilder(
              animation: instagramBloc,
              builder: (context, settingsCard) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  top: instagramBloc.settingState == SettingsState.visible
                      ? 0
                      : -settingsHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Stack(
                    children: [
                      //--------------------------
                      // HIDE SETTINGS ZONE
                      //--------------------------
                      if (instagramBloc.settingState == SettingsState.visible)
                        Positioned.fill(
                          child: GestureDetector(
                            onPanDown: (details) {
                              instagramBloc.hideSettings();
                            },
                          ),
                        )
                      else
                        const SizedBox(),
                      settingsCard!,
                    ],
                  ),
                );
              },
              child: SettingsBlurCard(height: settingsHeight),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RoundedNavigationBar(
        selectedColor: Theme.of(context).colorScheme.onBackground,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        items: const [
          RoundedNavigationBarItem(
            selectedIconData: Icons.home_rounded,
            iconData: Icons.home_outlined,
            hasNotification: false,
          ),
          RoundedNavigationBarItem(
            iconData: Icons.search,
            hasNotification: false,
          ),
          RoundedNavigationBarItem(
            iconData: Icons.add_box_outlined,
            hasNotification: false,
          ),
          RoundedNavigationBarItem(
            iconData: Icons.favorite_border,
            selectedIconData: Icons.favorite,
            hasNotification: true,
          ),
          RoundedNavigationBarItem(
            iconData: Icons.person_outlined,
            selectedIconData: Icons.person,
            hasNotification: false,
          ),
        ],
      ),
    );
  }
}

class RoundedNavigationBar extends StatelessWidget {
  const RoundedNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.unselectedColor = const Color(0xffa9a9a9),
    this.selectedColor = const Color(0xff000000),
    this.currentIndex = 0,
  });

  final List<RoundedNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final Color unselectedColor;
  final Color selectedColor;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.bottom,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return IconButton(
            onPressed: () => onTap?.call(index),
            color: index == currentIndex ? selectedColor : unselectedColor,
            icon: Stack(
              alignment: const Alignment(1, .5),
              children: [
                Icon(
                  index == currentIndex
                      ? item.selectedIconData ?? item.iconData
                      : item.iconData,
                ),
                if (item.hasNotification) const RedDot()
              ],
            ),
          );
        }),
      ),
    );
  }
}

class RoundedNavigationBarItem {
  const RoundedNavigationBarItem({
    required this.iconData,
    required this.hasNotification,
    this.selectedIconData,
  });

  final IconData iconData;
  final bool hasNotification;
  final IconData? selectedIconData;
}

class RedDot extends StatelessWidget {
  const RedDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        boxShadow: [BoxShadow(color: Colors.redAccent.shade100, blurRadius: 5)],
        shape: BoxShape.circle,
      ),
    );
  }
}
