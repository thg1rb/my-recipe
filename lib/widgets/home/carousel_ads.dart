import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselAds extends StatefulWidget {
  CarouselAds({super.key});

  @override
  State<CarouselAds> createState() => _CarouselAdsState();
}

class _CarouselAdsState extends State<CarouselAds> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> adsList = [
      'assets/images/ads1.jpeg',
      'assets/images/ads2.jpeg',
      'assets/images/ads3.jpeg',
    ];

    return Column(
      children: [
        // Constrain the width to 400
        SizedBox(
          width: 400, // Set the width here
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 123,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enlargeCenterPage: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: adsList.map((image) => AdsBox(image: image)).toList(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: adsList.map((url) {
            int index = adsList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.blue
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AdsBox extends StatelessWidget {
  const AdsBox({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 400 ,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}