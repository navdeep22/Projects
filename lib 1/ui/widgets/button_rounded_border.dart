import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton(
    this.buttonBackground,
    this.verticalPadding,
    this.horizontalPadding,
    this.text,
    this.textStyle,
  {this.onPressed,}
  );

  final Color buttonBackground;
  final double verticalPadding;
  final double horizontalPadding;
  final String text;
  final TextStyle textStyle;
  final Function onPressed;

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onPressed: () {
        widget.onPressed();
      },
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding),
      color: widget.buttonBackground,
      child: Text(widget.text, style: widget.textStyle),
    );
  }
}
