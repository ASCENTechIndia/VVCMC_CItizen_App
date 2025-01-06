import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List cards = [
      [
        {"icon": "property-tax.png", "text": "View Your Propert Tax"},
        {"icon": "water-tax.png", "text": "View Your Water Tax"},
      ],
      [
        {"icon": "complaint.png", "text": "Register Your Complaint"},
        {"icon": "clean.png", "text": "Clean VVMC"},
      ],
      [
        {"icon": "news.png", "text": "News Update"},
        {"icon": "track.png", "text": "Track My Complaint"},
      ],
      [
        {"icon": "vvmt.png", "text": "VVMT"},
        {"icon": "tax.png", "text": "Tax Calculator"},
      ],
      [
        {
          "icon": "property-receipt.png",
          "text": "Download Property Tax Receipt"
        },
        {"icon": "water-receipt.png", "text": "Download Water Tax Receipt"},
      ],
    ];
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "All the tools you need to manage your municipal tasks, right here.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cards
                        .map(
                          (row) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CardWidget(
                                    icon: Image.asset(
                                        "assets/icons/${row[0]["icon"]}"),
                                    title: Text(
                                      row[0]["text"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CardWidget(
                                    icon: Image.asset(
                                        "assets/icons/${row[1]["icon"]}"),
                                    title: Text(
                                      row[1]["text"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
