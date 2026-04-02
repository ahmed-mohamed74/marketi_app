import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 120.0),
      items:
          [
            'assets/images/caroasel_image.jpg',
            'assets/images/caroasel_image.jpg',
            'assets/images/caroasel_image.jpg',
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    child: Image.asset(i, fit: BoxFit.cover),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
