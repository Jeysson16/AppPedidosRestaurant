import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BackgroundSliver extends StatelessWidget {
  final List<String> bannerUrls;

  const BackgroundSliver({
    super.key,
    required this.bannerUrls,
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
        items: bannerUrls.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return Image.network(
                url,
                fit: BoxFit.fill,
                width: double.infinity,
                colorBlendMode: BlendMode.darken,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}