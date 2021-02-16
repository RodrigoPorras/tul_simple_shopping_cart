part of 'widgets.dart';

class DialogTul extends StatelessWidget {
  final String title;
  final String message;
  final String ok;
  final String cancel;
  final Function actionOk;
  final Function actionCancel;

  const DialogTul(
      {Key key,
      @required context,
      @required this.title,
      @required this.message,
      @required this.ok,
      this.cancel,
      this.actionOk,
      this.actionCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        title,
        style: TextStyle(color: base_color),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              cancel != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 40.0,
                        child: MaterialButton(
                          onPressed: () {
                            if (actionCancel != null) actionCancel();

                            Navigator.pop(context, false);
                          },
                          color: Colors.grey,
                          child: Text(
                            cancel,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40.0,
                  child: MaterialButton(
                    onPressed: () {
                      if (actionOk != null) actionOk();

                      Navigator.pop(context, true);
                    },
                    color: base_color,
                    child: Text(
                      ok,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
