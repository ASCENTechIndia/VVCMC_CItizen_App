import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class PropertyTaxReceiptWidget extends StatelessWidget {
  const PropertyTaxReceiptWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Property Tax Receipt"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: "Property No.",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: const Text("Search"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
