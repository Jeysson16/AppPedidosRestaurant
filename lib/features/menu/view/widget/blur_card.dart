import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc_provider.dart';

class SettingsBlurCard extends StatelessWidget {
  const SettingsBlurCard({
    super.key,
    this.height = 0,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final instagramBloc = MenuBlocProvider.of(context)!.menuBloc;
    PreferenciasUsuario.init();
    PreferenciasUsuario prefs = PreferenciasUsuario();
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.blueGrey[300]!.withOpacity(.7),
          child: SafeArea(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: instagramBloc,
                  builder: (context, child) {
                    return Row(
                      children: [
                        const SizedBox(height: 40),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sucursal: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${prefs.sucursalId}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 10),
                            child: Column(
                              children: [
                                _SettingsSwitcher(
                                  label: 'Modo Oscuro',
                                  value:
                                      instagramBloc.themeMode == ThemeMode.dark,
                                  onChanged: (val) {
                                    if (val) {
                                      instagramBloc
                                          .setThemeMode(ThemeMode.dark);
                                    } else {
                                      instagramBloc
                                          .setThemeMode(ThemeMode.light);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: instagramBloc.hideSettings,
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitcher extends StatelessWidget {
  const _SettingsSwitcher({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              onChanged(!value);
            },
            child: AnimatedContainer(
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              width: 50,
              padding: const EdgeInsets.all(3),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: value ? Colors.white38 : Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
