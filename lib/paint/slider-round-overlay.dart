import 'package:flutter/material.dart';


class SliderRoundOverlayShape extends SliderComponentShape {
  const SliderRoundOverlayShape({
    this.overlayRadius = 24.0,
    this.handlerScaleFactor = 1.5
  });

  final double overlayRadius;
  final double handlerScaleFactor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(overlayRadius * handlerScaleFactor, overlayRadius * handlerScaleFactor);
  }

  @override
  void paint(PaintingContext context,
      Offset center,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete, TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow
      }) {
    assert(context != null);
    assert(center != null);
    assert(activationAnimation != null);
    assert(enableAnimation != null);
    assert(labelPainter != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(textDirection != null);
    assert(value != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: 0.0,
      end: overlayRadius,
    );

    canvas.drawCircle(
      center,
      radiusTween.evaluate(activationAnimation),
      Paint()..color = sliderTheme.overlayColor,
    );
  }
}