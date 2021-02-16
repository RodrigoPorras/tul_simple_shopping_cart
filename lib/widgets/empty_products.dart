part of 'widgets.dart';

class EmptyProducts extends StatelessWidget {
  final String message;
  final String messageForTap;
  final Function onTap;

  const EmptyProducts({Key key, this.message, this.onTap, this.messageForTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(onTap: onTap, child: Text(messageForTap))
            ],
          ),
        ));
  }
}
