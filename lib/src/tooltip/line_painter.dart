/*
 * Copyright (c) 2021 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
part of 'tooltip.dart';

class _ArrowLine extends CustomPainter {
  _ArrowLine({
    this.strokeColor = Colors.white,
    this.strokeWidth = 2.0,
    this.paintingStyle = PaintingStyle.stroke,
    required this.targetTooltipGap,
    required this.arrowOffsetX,
  }) : _paint = Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = paintingStyle
          ..strokeCap = StrokeCap.round;

  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Paint _paint;
  final double targetTooltipGap;
  final double arrowOffsetX;

  @override
  void paint(Canvas canvas, Size size) {
    const marginTooltip = 4.0;
    // 在起点画圆环效果
    const outerRadius = 8.0;
    const innerRadius = 4.0;
    var circleStart = Offset(arrowOffsetX + Constants.arrowWidth * 0.5, -marginTooltip);
    var lineStart = Offset(arrowOffsetX + Constants.arrowWidth * 0.5, -(outerRadius + 3 + marginTooltip));
    var lineEnd = Offset(arrowOffsetX + Constants.arrowWidth * 0.5, -(targetTooltipGap + 6));

    // 创建渐变shader
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        strokeColor.withOpacity(0.8), // 下端更实
        strokeColor.withOpacity(0.2), // 上端更透明
      ],
    );
    final rect = Rect.fromPoints(lineStart, lineEnd);
    final gradientPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = paintingStyle
      ..strokeCap = StrokeCap.round;

    // 画渐变线
    canvas.drawLine(lineStart, lineEnd, gradientPaint);

    final outerPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleStart, outerRadius, outerPaint);
    canvas.drawCircle(circleStart, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _ArrowLine oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.targetTooltipGap != targetTooltipGap;
  }
}
