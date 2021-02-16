part of 'widgets.dart';

class CacheImage extends StatelessWidget {
  final String src;
  final double height;

  const CacheImage({Key key, this.src, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: new AlwaysStoppedAnimation<Color>(base_color))),
      errorWidget: (context, url, error) => Icon(Icons.error),
      height: height,
    );
  }
}
