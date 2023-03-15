import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../classes/Categorys.dart';

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.detailPosition,
    required List<Category> categories,
    required this.indexTypeSelected,
    required this.placeName,
    required this.placePrice,
    required this.placeRating,
  }) : _categories = categories;

  final double detailPosition;
  final List<Category> _categories;
  final int indexTypeSelected;
  final String placeName;
  final int placePrice;
  final double placeRating;

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
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: placePrice.toDouble(),
                          minRating: 1,
                          itemSize: 24,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 4,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => const Icon(
                            Icons.attach_money_outlined,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: placeRating,
                          minRating: 1,
                          itemSize: 24,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
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
