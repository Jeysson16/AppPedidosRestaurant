import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/banner.dart';


class BackgroundSliver extends StatelessWidget {
  final List<BannerOfertas> banners;
  final Function(String? categoryId, String? productId) onBannerTap;

  const BackgroundSliver({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          autoPlayInterval: const Duration(seconds: 10),
          enlargeCenterPage: true,
        ),
        items: banners.map((banner) {
          return GestureDetector(
            onTap: () => onBannerTap(banner.categoriaId, banner.productoId),
            child: Image.network(
              banner.url ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              colorBlendMode: BlendMode.darken,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
            ),
          );
        }).toList(),
      ),
    );
  }
}