
import 'package:flutter/material.dart';

class ImageWithShimmerWidget extends StatelessWidget {
final String imageUrl;
final double width;
final double height;
final BoxFit fit;

const ImageWithShimmerWidget({
super.key,
required this.imageUrl,
required this.width,
required this.height,
this.fit = BoxFit.cover,
});

@override
Widget build(BuildContext context) {
return Container(
width: width,
height: height,
decoration: BoxDecoration(
color: Colors.grey[200],
),
child: Image.asset(
imageUrl,
width: width,
height: height,
fit: fit,
errorBuilder: (context, error, stackTrace) {
return Container(
width: width,
height: height,
color: Colors.grey[300],
child: Icon(
Icons.image_not_supported_outlined,
color: Colors.grey[500],
size: 40,
),
);
},
),
);
}
}
