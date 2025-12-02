import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageShowPage extends StatefulWidget {
  const ImageShowPage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<ImageShowPage> createState() => _ImageShowPageState();
}

class _ImageShowPageState extends State<ImageShowPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 61, 61, 61),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "çıkmak için herhangi bir yere tıklayın.",
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
