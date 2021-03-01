import 'package:flutter/material.dart';


class CustomRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape{
  CustomRangeSliderTrackShape({
    this.overlayRadius,
    this.handlerScaleFactor = 1.5
  });

  final double overlayRadius;
  final double handlerScaleFactor;

  @override
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(parentBox != null);
    assert(offset != null);
    assert(sliderTheme != null);
    assert(sliderTheme.overlayShape != null);
    assert(isEnabled != null);
    assert(isDiscrete != null);
    final double overlayWidth = sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width / handlerScaleFactor;
    final double trackHeight = sliderTheme.trackHeight;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= overlayWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - overlayWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}