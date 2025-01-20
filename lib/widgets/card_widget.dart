import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final Widget? icon;
  final Widget title;
  final void Function()? onTap;

  const CardWidget({super.key, this.icon, required this.title, this.onTap});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF5F5F5),
      elevation: 0,
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: () {
              return widget.icon != null
                  ? [
                      widget.icon!,
                      const SizedBox(width: 10),
                      Flexible(child: widget.title),
                    ]
                  : [Flexible(child: widget.title)];
            }(),
          ),
        ),
      ),
    );
  }
}
