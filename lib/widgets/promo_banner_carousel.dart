
import 'dart:async';
import 'package:flutter/material.dart';

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() =>
      _PromoBannerCarouselState();
}

class _PromoBannerCarouselState
    extends State<PromoBannerCarousel> {

  final PageController _controller = PageController();

  Timer? _autoPlayTimer;

  int currentIndex = 0;

  final List<Map<String, String>> banners = [
    {
      'title': 'Super Sale\nDiscount',
      'discount': '50%',
      'subtitle': 'Up to',
      'button': 'Shop Now',
      'image': 'assets/images/mode1.png',
    },
    {
      'title': 'New Fashion\nCollection',
      'discount': '40%',
      'subtitle': 'Up to',
      'button': 'Explore Now',
      'image': 'assets/images/model.png',
    },
    {
      'title': 'Summer Style\nSale',
      'discount': '30%',
      'subtitle': 'Up to',
      'button': 'Buy Now',
      'image': 'assets/images/model3.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    _startAutoPlay();
  }

  // Automatic banner sliding
  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(
      const Duration(seconds: 10),
          (timer) {
        if (!_controller.hasClients) return;

        int nextIndex = currentIndex + 1;

        if (nextIndex >= banners.length) {
          nextIndex = 0;
        }

        _controller.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,

            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            itemBuilder: (context, index) {
              final banner = banners[index];

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF202320),
                  borderRadius: BorderRadius.circular(24),
                ),

                clipBehavior: Clip.antiAlias,

                child: Stack(
                  children: [

                    // Background circle decoration
                    Positioned(
                      right: 45,
                      top: 15,
                      child: Container(
                        height: 145,
                        width: 145,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF75F54A)
                                .withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    // Banner Text and Button
                    Positioned(
                      left: 22,
                      top: 25,
                      bottom: 20,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                '${banner['subtitle']} ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),

                              Text(
                                banner['discount']!,
                                style: const TextStyle(
                                  color: Color(0xFF75F54A),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${banner['button']} clicked!',
                                  ),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF75F54A),
                              foregroundColor: Colors.black,

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                            ),

                            child: Text(
                              banner['button']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Model Image
                    Positioned(
                      right: 0,
                      bottom: 0,
                      width: 165,
                      height: 185,

                      child: Image.asset(
                        banner['image']!,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),

                    // Page Indicators
                    Positioned(
                      bottom: 12,
                      right: 18,

                      child: Row(
                        children: List.generate(
                          banners.length,
                              (dotIndex) {

                            return AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 250,
                              ),

                              margin:
                              const EdgeInsets.only(left: 5),

                              width: currentIndex == dotIndex
                                  ? 18
                                  : 7,

                              height: 7,

                              decoration: BoxDecoration(
                                color: currentIndex == dotIndex
                                    ? const Color(0xFF75F54A)
                                    : Colors.white54,

                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
