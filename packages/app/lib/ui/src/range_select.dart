import 'package:app/ui/style/style.dart';
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
  final double minValue;
  final double maxValue;
  final double? initialMin;
  final double? initialMax;
  final double? stepSize;
  final bool showInts;
  final ValueChanged<RangeValues?>? onChanged;

  const RangeSelect(
    this.title,
    this.minValue,
    this.maxValue, {
    super.key,
    this.stepSize,
    this.onChanged,
    this.showInts = false,
    this.initialMin,
    this.initialMax,
  });

  @override
  ConsumerState<RangeSelect> createState() => _RangeSelectState();
}

class _RangeSelectState extends ConsumerState<RangeSelect> {
  late RangeValues values;
  // late List<double> lower;

  void _resetValues() {
    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }
    setState(() {
      values = RangeValues(widget.minValue, widget.maxValue);
      // lower = List<double>.generate(50, (index) => values.start - index);
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

  Widget buildMenuRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextHeadline(widget.title.toUpperCase()),
        ],
      ),
    );
  }

  Widget buildContentRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: buildSlider()),
          ResetIcon(onPressed: isDefault() ? null : _resetValues),
        ],
      ),
    );
  }

  Widget buildSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.green[200],
        inactiveTrackColor: Colors.grey[400],
        trackShape: const RectangularSliderTrackShape(),
        trackHeight: 1.0,
        thumbColor: Colors.green[400],
        rangeThumbShape: widget.showInts
            ? CustomRangeSliderThumpShape<int>(
                values.start.toInt(), values.end.toInt(), 32)
            : CustomRangeSliderThumpShape<double>(
                values.start.toDouble(), values.end.toDouble(), 32),
        showValueIndicator: ShowValueIndicator.never,
        overlayColor: Colors.green[200]!.withAlpha(32),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.grey[200],
        inactiveTickMarkColor: Colors.grey[200],
      ),
      child: RangeSlider(
        values: values,
        onChanged: _setValues,
        divisions: (widget.stepSize == null)
            ? null
            : (widget.maxValue - widget.minValue) ~/ widget.stepSize!,
        min: widget.minValue,
        max: widget.maxValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenuRow(),
          buildContentRow(),
        ],
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
    return const Size(24, 24);
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
      ..strokeWidth = 2.0
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
            fontWeight: FontWeight.w500,
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
