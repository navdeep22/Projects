import 'package:club_app/constants/constants.dart';
import 'package:flutter/material.dart';

class OutlineBorderButton extends StatefulWidget {
  OutlineBorderButton(
    this.buttonBackground,
    this.verticalPadding,
    this.horizontalPadding,
    this.text,
    this.textStyle, {
    this.onPressed,
  });

  final Color buttonBackground;
  final double verticalPadding;
  final double horizontalPadding;
  final String text;
  final TextStyle textStyle;
  final Function onPressed;

  @override
  _OutlineBorderButtonState createState() => _OutlineBorderButtonState();
}

class _OutlineBorderButtonState extends State<OutlineBorderButton> {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      borderSide: BorderSide(color: dividerColor),
      onPressed: () {
        widget.onPressed();
      },
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding),
      //color: widget.buttonBackground,
      child: Text(widget.text, style: widget.textStyle),
    );
  }
}
