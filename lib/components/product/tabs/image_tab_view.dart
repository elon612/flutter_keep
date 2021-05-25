import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

class ImageTabView extends StatelessWidget {
  const ImageTabView({Key key, this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) => FadeInImage(
          placeholder: R.assets.imagePlaceholder,
          fit: BoxFit.cover,
          image: AssetImage(images[index]),
        ),
      ),
    );
  }
}
