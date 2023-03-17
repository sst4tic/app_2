import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageList extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> fullImageUrl;
  const ImageList({super.key, required this.imageUrls, required this.fullImageUrl});

  @override
  ImageListState createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  final _controller = PageController();
  int _currentIndex = 0;
  List<String> _imageUrls = [];
  List<String> _fullImageUrl = [];
  static const String _noPhotoImage = 'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg';
  bool noImage = false;

  @override
  void initState() {
    super.initState();
    _imageUrls = widget.imageUrls;
    _fullImageUrl = widget.fullImageUrl;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkNoImage();
  }

  void checkNoImage() {
    if (_imageUrls.length == 1 && _imageUrls[0] == _noPhotoImage) {
      noImage = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: _imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  noImage ? null :
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: Stack(
                          children: [
                            PhotoViewGallery.builder(
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              itemCount: _imageUrls.length,
                              builder: (BuildContext context, int index) {
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: NetworkImage(_fullImageUrl[index]),
                                  heroAttributes: PhotoViewHeroAttributes(
                                    tag: _imageUrls[index],
                                  ),
                                );
                              },
                              pageController: PageController(
                                initialPage: _currentIndex,
                              ),
                            ),
                            Positioned(
                              top: 60,
                              right: 0,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close, color: Colors.black,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
       noImage ? Container() : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            _imageUrls.length,
                (int index) {
              return GestureDetector(
                onTap: () {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: REdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.red : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}