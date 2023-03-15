import 'package:flutter/material.dart';

import '../../../classes/Categorys.dart';

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.detailPosition,
    required List<Category> categories,
    required this.indexTypeSelected,
    required this.placeName,
    required this.placePrice,
  }) : _categories = categories;

  final double detailPosition;
  final List<Category> _categories;
  final int indexTypeSelected;
  final String placeName;
  final int placePrice;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 0,
      right: 0,
      bottom: detailPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset.zero,
              )
            ]),
        child: Column(
          children: [
            FittedBox(
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(
                      _categories[indexTypeSelected].icon,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          placePrice.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Text(
                          'Localização',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}