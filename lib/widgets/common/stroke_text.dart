import 'package:flutter/material.dart';

/*
Source: https://tutorsvilla.blogspot.com/2019/06/how-to-add-text-border-or-text-stroke-flutter.html
 */
class BorderedText extends StatelessWidget {
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final double strokeWidth;
  final Color strokeColor;
  final Text child;

  const BorderedText({
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    this.strokeWidth = 6.0,
    this.strokeColor = const Color.fromRGBO(53, 0, 71, 1),
    required this.child,
  }) : assert(child != null);

  /// the stroke cap style


  @override
  Widget build(BuildContext context) {
    TextStyle style;
    if (child.style != null) {
      style = child.style!.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = strokeCap
          ..strokeJoin = strokeJoin
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
        color: null,
      );
    } else {
      style = TextStyle(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = strokeCap
          ..strokeJoin = strokeJoin
          ..strokeWidth = strokeWidth
          ..color = strokeColor,
      );
    }
    return Stack(
      alignment: Alignment.center,
      textDirection: TextDirection.ltr,
      children: [
        Text(
          child.data ?? "",
          style: style,
          maxLines: child.maxLines,
          overflow: child.overflow,
          semanticsLabel: child.semanticsLabel,
          softWrap: child.softWrap,
          strutStyle: child.strutStyle,
          textAlign: child.textAlign,
          textDirection: child.textDirection,
          textScaleFactor: child.textScaleFactor,
          textWidthBasis: child.textWidthBasis,
        ),
        child,
      ],
    );
  }
}
