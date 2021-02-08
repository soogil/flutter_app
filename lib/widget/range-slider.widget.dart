import 'package:flutter/material.dart';


typedef Widget RangeSliderLabelBuilder(
    double startValue,
    double endValue,
    );

class RangeSliderWidget extends StatefulWidget {

  RangeSliderWidget({
    Key key,
    @required this.volumes,
    @required this.rangeSliderLabelBuilder,
    @required this.minValue,
    @required this.maxValue,
    this.onChanged,
    this.height = 200,
    this.values,
    this.chartHeight = 200,
    this.trackHeight = 1,
    this.thumbStrokeWidth = 6.0,
    this.enabledThumbRadius = 10.0,
    this.chartPadding = const EdgeInsets.all(0),
    this.thumbColor = Colors.red,
    this.outerThumbColor = Colors.white,
    this.inActiveTrackColor = Colors.transparent,
    this.inActiveTickMarkColor = Colors.transparent,
    this.overlayColor = Colors.transparent,
    this.chartBackgroundColor = Colors.white,
    this.chartColor = Colors.grey,
    this.chartBlendColor = Colors.pink,
  }) :
        assert(minValue != null && maxValue != null),
        assert(minValue < maxValue),
        assert(volumes != null && volumes.length != 0),
        assert(rangeSliderLabelBuilder != null),
        super(key: key);

  final List<int> volumes;
  final double minValue;
  final double maxValue;
  final double height;
  final RangeValues values;
  final double chartHeight;
  final double trackHeight;
  final double thumbStrokeWidth;
  final double enabledThumbRadius;
  final EdgeInsets chartPadding;
  final Color chartBackgroundColor;
  final Color chartColor;
  final Color chartBlendColor;
  final Color thumbColor;
  final Color outerThumbColor;
  final Color inActiveTrackColor;
  final Color inActiveTickMarkColor;
  final Color overlayColor;
  final RangeSliderLabelBuilder rangeSliderLabelBuilder;
  final ValueChanged<RangeValues> onChanged;

  @override
  _RangeSliderWidgetState createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {

  final GlobalKey chartViewKey = GlobalKey();

  RangeValues _values;
  double _chartLeftPadding = 0.0;
  double _chartRightPadding = 0.0;
  int _maxVolume = 0;

  _getMaxAxis() {
    int max = widget.volumes.first;

    widget.volumes.forEach((i){
      if(i > max){
        max = i;
      }
    });

    int maxValue = max.round();

    return maxValue;
  }

  @override
  void initState() {
    _values = widget.values ?? RangeValues(widget.minValue, widget.maxValue);
    _maxVolume = _getMaxAxis();

    if(hasValues) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setPadding();
        setState(() {

        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double handlerScaleFactor = 2.2;

    return Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child:
              _getBarLineChart(context),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: widget.chartHeight - (widget.enabledThumbRadius * handlerScaleFactor) - widget.thumbStrokeWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SliderTheme(
                      data: SliderThemeData(
                        rangeThumbShape: SliderThumb(
                          enabledThumbRadius: widget.enabledThumbRadius,
                          outerThumbColor: widget.outerThumbColor,
                          thumbColor: widget.thumbColor,
                          thumbStrokeWidth: widget.thumbStrokeWidth,
                        ),
                        activeTickMarkColor: widget.thumbColor,
                        activeTrackColor: widget.thumbColor,
                        inactiveTrackColor: widget.inActiveTrackColor,
                        inactiveTickMarkColor: widget.inActiveTickMarkColor,
                        overlayColor: widget.overlayColor,
                        trackHeight: widget.trackHeight,
                        rangeTrackShape: CustomRangeSliderTrackShape(
                            overlayRadius: widget.enabledThumbRadius,
                            handlerScaleFactor: handlerScaleFactor
                        ),
                        overlayShape: CustomRoundSliderOverlayShape(
                            overlayRadius: widget.enabledThumbRadius * 2 + widget.thumbStrokeWidth,
                            handlerScaleFactor: handlerScaleFactor
                        ),
                      ),
                      child: RangeSlider(
                        onChanged: (value) {
                          if (widget.onChanged != null) {
                            widget.onChanged(value);
                          }

                          setState(() {
                            _values = value;
                            _setPadding();
                          });
                        },
                        values: _values,
                        min: widget.minValue,
                        max: widget.maxValue,
                      ),
                    ),
                    widget.rangeSliderLabelBuilder(
                      _values.start,
                      _values.end,
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  _getBarLineChart(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      key: chartViewKey,
      height: widget.chartHeight,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          widget.chartBlendColor,
          BlendMode.saturation,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              color: widget.chartBackgroundColor,
              child: CustomPaint(
                size: Size(size.width, widget.chartHeight),
                painter: BarLineChartView(
                  volumes: widget.volumes,
                  limitPriceVolume: _maxVolume,
                  chartColor: widget.chartColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: _chartRightPadding,
                left: _chartLeftPadding,
              ),
              color: widget.chartBlendColor.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }

  _setPadding() {
    final _context = chartViewKey.currentContext ?? context;
    final width = _context.size.width;
    final priceScaleFactor = width / widget.maxValue;

    _chartLeftPadding = (_values.start - widget.minValue) * priceScaleFactor;
    _chartRightPadding = (widget.maxValue - _values.end) * priceScaleFactor;
  }

  bool get hasValues => widget.values != null;
}

class BarLineChartView extends CustomPainter {

  BarLineChartView({
    this.volumes,
    this.limitPriceVolume,
    this.leftPadding = 0.0,
    this.chartColor,
    this.hiddenXLeftovers = true,
  }) : assert(volumes != null && volumes.length != 0);

  final List<int> volumes;
  final Color chartColor;
  final int limitPriceVolume;
  final double leftPadding;
  final bool hiddenXLeftovers;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<Offset> offsets = _calcOffsets(size);

    Paint paint = Paint()
      ..color = chartColor;

    _drawLine(canvas, size, offsets, paint);
  }

  _calcOffsets(Size size) {
    List<Offset> offsets = [];
    double dx, dy;
    int i;

    final int leftOverByLength = hiddenXLeftovers ? volumes.length > 1
        ? -1
        : 0 : 1;
    final double unit = ((size.width) / (volumes.length + leftOverByLength));
    final double leftOverBySize = hiddenXLeftovers ? 0.0 : unit;

    for (i = 0; i < volumes.length; i ++) {
      final heightScaleFactor = volumes[i] / (limitPriceVolume + limitPriceVolume * 0.1);
      dx = leftOverBySize + ((i * unit));
      dy = size.height - heightScaleFactor * size.height;

      offsets.add(Offset(leftPadding + dx, dy));
    }

    return offsets;
  }

  _drawLine(Canvas canvas, Size size, List<Offset> offsets, Paint paint) {
    Path path = Path();

    path.moveTo(offsets[0].dx, offsets[0].dy);

    var temp = const Offset(0.0, 0.0);

    for (int i = 1; i < offsets.length; i++) {
      final previous = offsets[i - 1];
      final current = offsets[i];
      final next = offsets[i + 1 < offsets.length ? i + 1 : i];

      final Offset cp1 = previous + temp;

      temp = ((next - previous) / 2) * 0.25;

      final Offset cp2 = current - temp;

      path.cubicTo(
        cp1.dx, cp1.dy > size.height ? size.height : cp1.dy,
        cp2.dx, cp2.dy > size.height ? size.height : cp2.dy,
        current.dx, current.dy > size.height ? size.height : current.dy,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }
}

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

class CustomRoundSliderOverlayShape extends SliderComponentShape {
  const CustomRoundSliderOverlayShape({
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