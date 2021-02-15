part of 'widgets.dart';

class CircularProgressIndicatorTul extends StatelessWidget {
  const CircularProgressIndicatorTul({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: new AlwaysStoppedAnimation<Color>(base_color)),
      ),
    );
  }
}
