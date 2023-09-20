import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  RangeFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(0));
    } else if (int.parse(newValue.text) > max) {
      return const TextEditingValue().copyWith(text: max.toStringAsFixed(0));
    } else {
      return newValue;
    }
  }
}

class RangeSelect extends ConsumerStatefulWidget {
  final String title;
  double minValue;
  double maxValue;
  double? initialMin;
  double? initialMax;
  final double? stepSize;
  final bool showInts;
  final ValueChanged<RangeValues?>? onChanged;

  RangeSelect(this.title, this.minValue, this.maxValue,
      {super.key,
      this.stepSize,
      this.onChanged,
      this.showInts = false,
      this.initialMin,
      this.initialMax});

  @override
  ConsumerState<RangeSelect> createState() => _RangeSelectState();
}

class _RangeSelectState extends ConsumerState<RangeSelect> {
  late RangeValues values;
  late List<double> lower;

  void _resetValues() {
    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }
    setState(() {
      values = RangeValues(widget.minValue, widget.maxValue);
      lower = List<double>.generate(50, (index) => values.start - index);
    });
  }

  void _setValues(RangeValues vs) {
    if (widget.onChanged != null) {
      widget.onChanged!(vs);
    }
    setState(() {
      values = vs;
    });
  }

  bool isDefault() {
    return values.start == widget.minValue && values.end == widget.maxValue;
  }

  @override
  void initState() {
    super.initState();

    values = RangeValues(widget.initialMin ?? widget.minValue,
        widget.initialMax ?? widget.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.green[400],
                        inactiveTrackColor: Colors.grey[400],
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: Colors.green[500],
                        rangeThumbShape: widget.showInts
                            ? CustomRangeSliderThumpShape<int>(
                                values.start.toInt(), values.end.toInt(), 32)
                            : CustomRangeSliderThumpShape<double>(
                                values.start.toDouble(),
                                values.end.toDouble(),
                                32),
                        showValueIndicator: ShowValueIndicator.never,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Colors.grey[200],
                        inactiveTickMarkColor: Colors.grey[200],
                      ),
                      child: RangeSlider(
                        values: values,
                        onChanged: _setValues,
                        divisions: (widget.stepSize == null)
                            ? null
                            : (widget.maxValue - widget.minValue) ~/
                                widget.stepSize!,
                        min: widget.minValue,
                        max: widget.maxValue,
                      ),
                    ),
                  ),
                  IconButton(
                      disabledColor: Colors.grey[400],
                      icon: const Icon(Icons.clear),
                      color: Colors.red[400],
                      onPressed: isDefault() ? null : _resetValues),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRangeSliderThumpShape<T extends num> extends RangeSliderThumbShape {
  T min;
  T max;
  int height;

  CustomRangeSliderThumpShape(this.min, this.max, this.height);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(32, 32);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      bool? isDiscrete,
      bool? isEnabled,
      bool? isOnTop,
      TextDirection? textDirection,
      required SliderThemeData sliderTheme,
      Thumb? thumb,
      bool? isPressed}) {
    final Canvas canvas = context.canvas;
    final Paint strokePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.yellow
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 7.5, Paint()..color = Colors.white);
    canvas.drawCircle(center, 7.5, strokePaint);
    if (thumb == null) {
      return;
    }
    final value = thumb == Thumb.start ? min : max;
    final offset = thumb == Thumb.start
        ? Offset(center.dx, center.dy + height / 2)
        : Offset(center.dx, center.dy - height / 2);

    TextSpan span = TextSpan(
        style: TextStyle(
            fontSize: height * .3,
            fontWeight: FontWeight.w700,
            color: sliderTheme.thumbColor,
            height: 1),
        text: '$value');
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(offset.dx - (tp.width / 2), offset.dy - (tp.height / 2));

    tp.paint(canvas, textCenter);
  }
}

// https://medium.com/flutter-community/flutter-sliders-demystified-4b3ea65879c
