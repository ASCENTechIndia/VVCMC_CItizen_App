import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List cards = [
      {
        "icon": "police.png",
        "text": "Police",
        "contact": "100",
      },
      {
        "icon": "ambulance.png",
        "text": "Ambulance",
        "contact": "108",
      },
      {
        "icon": "fire-brigade.png",
        "text": "Fire Brigade",
        "contact": "101",
      },
      {
        "icon": "emergency-number.png",
        "text": "Emergency Number",
        "contact": "+9118002334353",
      },
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
                    "Get quick help in emergencies.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    "Your safety is just one tap away.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cards
                        .map(
                          (card) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: CardWidget(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Phone Call"),
                                      content: Text(
                                          "Do you wish to call ${card["text"]}?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            launchUrl(Uri.parse(
                                                "tel:${card["contact"]}"));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Image.asset("assets/icons/${card["icon"]}"),
                              title: Text(
                                card["text"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
