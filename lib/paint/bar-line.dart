import 'package:flutter/material.dart';


class BarLinePainter extends CustomPainter {

  BarLinePainter({
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