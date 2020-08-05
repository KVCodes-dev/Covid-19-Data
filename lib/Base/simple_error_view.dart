import 'package:covid19status/colors.dart';
import 'package:flutter/material.dart';

class SimpleErrorView extends StatelessWidget {
  final String messageKey;
  final Color textColor;

  const SimpleErrorView({
    Key key,
    @required this.messageKey,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageKey.isEmpty
        ? Container()
        : Padding(
            padding: EdgeInsets.all(5.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  child: Center(
                    child: Text(
                       messageKey,
                      style: TextStyle(
                          color: textColor ?? kTextLight,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
