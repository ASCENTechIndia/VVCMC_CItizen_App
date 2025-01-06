import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List cards = [
      {"icon": "police.png", "text": "Police"},
      {"icon": "ambulance.png", "text": "Ambulance"},
      {"icon": "fire-brigade.png", "text": "Fire Brigade"},
      {"icon": "emergency-number.png", "text": "Emergency Number"},
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
