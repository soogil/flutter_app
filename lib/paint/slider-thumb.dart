import 'package:flutter/material.dart';


class SliderThumb extends RangeSliderThumbShape {
  const SliderThumb({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.outerThumbColor = Colors.white,
    this.thumbColor = Colors.red,
    this.thumbStrokeWidth = 6.0,
  }) : assert(enabledThumbRadius != null);

  final double enabledThumbRadius;
  final double disabledThumbRadius;
  final Color outerThumbColor;
  final Color thumbColor;
  final double thumbStrokeWidth;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  double get _disabledThumbRadius =>  disabledThumbRadius ?? enabledThumbRadius;

  @override
  void paint(PaintingContext context,
      Offset center,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete, bool isEnabled,
        bool isOnTop,
        TextDirection textDirection,
        SliderThemeData sliderTheme,
        Thumb thumb,
        bool isPressed
      }) {
    assert(context != null);
    assert(center != null);
    assert(activationAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    assert(enableAnimation != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final double radius = radiusTween.evaluate(enableAnimation);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = outerThumbColor,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = thumbColor
        ..strokeWidth = thumbStrokeWidth
        ..style = PaintingStyle.stroke,
    );
  }
}