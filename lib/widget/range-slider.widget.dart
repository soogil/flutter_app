import 'package:flutter/material.dart';
import 'package:flutter_app/paint/bar-line.dart';
import 'package:flutter_app/paint/slider-round-overlay.dart';
import 'package:flutter_app/paint/slider-thumb.dart';
import 'package:flutter_app/paint/slider-track.dart';


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
        setState(() {});
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
                        overlayShape: SliderRoundOverlayShape(
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
                painter: BarLinePainter(
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

