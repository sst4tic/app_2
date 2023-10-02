import 'package:flutter/material.dart';
typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final double? size;

  const StarRating({super.key, this.starCount = 5, this.rating = .0,  this.onRatingChanged, this.color, this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon =  Icon(
        Icons.star_border_rounded,
        color: const Color.fromRGBO(255, 185, 4, 1),
        size: size ?? 16,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half_rounded,
        color: color ?? const Color.fromRGBO(255, 185, 4, 1),
        size: size ?? 16,
      );
    } else {
      icon = Icon(
        Icons.star_rounded,
        color: color ?? const Color.fromRGBO(255, 185, 4, 1),
        size: size ?? 16,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}