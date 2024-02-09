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

class BlankSliderSelect extends ConsumerStatefulWidget {
  final String title;
  final String? description;
  final double value;
  final double min;
  final double max;
  final double? stepSize;
  final bool showInts;
  final ValueChanged<double?>? onChanged;

  const BlankSliderSelect(
    this.title,
    this.description,
    this.value, {
    required this.min,
    required this.max,
    super.key,
    this.stepSize,
    this.onChanged,
    this.showInts = false,
  });

  @override
  ConsumerState<BlankSliderSelect> createState() => _BlankSliderSelectState();
}

class _BlankSliderSelectState extends ConsumerState<BlankSliderSelect> {
  late double v;
  bool showDescription = false;

  void _resetValues() {
    if (widget.onChanged != null) {
      widget.onChanged!(null);
    }
    setState(() {
      v = widget.value;
    });
  }

  void _setValues(double vv) {
    if (widget.onChanged != null) {
      widget.onChanged!(vv);
    }
    setState(() {
      v = vv;
    });
  }

  bool isDefault() {
    return v == widget.value;
  }

  @override
  void initState() {
    super.initState();

    v = widget.value;
  }

  Widget buildMenuRow() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 10, 0),
        child: GestureDetector(
          onTap: () => setState(() {
            showDescription = !showDescription;
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.description != null)
                InfoIcon(
                  onPressed: () => setState(() {
                    showDescription = !showDescription;
                  }),
                ),
              TextHeadline(widget.title.toUpperCase()),
            ],
          ),
        ));
  }

  Widget buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextSubtitle(widget.description ?? ""),
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
        ],
      ),
    );
  }

  Widget buildSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Theme.of(context).colorScheme.onBackground,
        trackShape: const RectangularSliderTrackShape(),
        trackHeight: 1.0,
        thumbColor: Theme.of(context).colorScheme.primary,
        thumbShape: widget.showInts
            ? CustomSliderThumpShape<int>(v.toInt(), 32, context)
            : CustomSliderThumpShape<double>(v, 32, context),
        showValueIndicator: ShowValueIndicator.never,
        // overlayColor: Theme.of(context).colorScheme.primary.withAlpha(64),
        // overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        // tickMarkShape: const RoundSliderTickMarkShape(),
        // activeTickMarkColor: Theme.of(context).colorScheme.primary,
        // inactiveTickMarkColor: Theme.of(context).colorScheme.onBackground,
      ),
      child: Slider(
        value: v,
        onChanged: _setValues,
        divisions: (widget.stepSize == null)
            ? null
            : (widget.max - widget.min) ~/ widget.stepSize!,
        min: widget.min,
        max: widget.max,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMenuRow(),
        if (widget.description != null && showDescription) buildDescription(),
        buildContentRow(),
      ],
    );
  }
}

class CustomSliderThumpShape<T extends num> extends SliderComponentShape {
  int height;
  T displayValue;
  BuildContext parentContext;

  CustomSliderThumpShape(this.displayValue, this.height, this.parentContext);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final Paint strokePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.yellow
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, 7.5,
        Paint()..color = Theme.of(parentContext).colorScheme.background);
    canvas.drawCircle(center, 7.5, strokePaint);

    // final offset = Offset(center.dx, center.dy - height / 2);

    // TextSpan span = TextSpan(
    //     style: TextStyle(
    //         fontSize: height * .3,
    //         fontWeight: FontWeight.w500,
    //         color: sliderTheme.thumbColor,
    //         height: 1),
    //     text: '$displayValue');
    // TextPainter tp = TextPainter(
    //     text: span,
    //     textAlign: TextAlign.left,
    //     textDirection: TextDirection.ltr);
    // tp.layout();
    // Offset textCenter =
    //     Offset(offset.dx - (tp.width / 2), offset.dy - (tp.height / 2));

    // tp.paint(canvas, textCenter);
  }
}

// https://medium.com/flutter-community/flutter-sliders-demystified-4b3ea65879c
