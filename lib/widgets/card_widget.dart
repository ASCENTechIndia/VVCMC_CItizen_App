import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final Widget icon;
  final Widget title;

  const CardWidget({super.key, required this.icon, required this.title});

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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              widget.icon,
              const SizedBox(width: 10),
              Flexible(child: widget.title),
            ],
          ),
        ),
      ),
    );
  }
}
