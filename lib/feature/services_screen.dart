import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    List cards = [
      [
        {"icon": "logo.png", "text": "About VVMC"},
        {"icon": "emergency.png", "text": "emergency.png"},
      ],
      [
        {"icon": "elected.png", "text": "Elected Member"},
        {"icon": "prabhag.png", "text": "Prabhag Samiti"},
      ],
      [
        {"icon": "official.png", "text": "Official Numbers"},
        {"icon": "commissioner.png", "text": "Commissioner Message"},
      ],
      [
        {"icon": "mayor.png", "text": "Mayor Message"},
        {"icon": "map.png", "text": "Map"},
      ],
      [
        {"icon": "gallery.png", "text": "Gallery"},
        {"icon": "twitter.png", "text": "Twitter"},
      ],
      [
        {"icon": "logo.png", "text": "VVMC Website"},
        {"icon": "facebook.png", "text": "Facebook"},
      ],
      [
        {"icon": "youtube.png", "text": "Youtube"},
        {"icon": "vts.png", "text": "VTS"},
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
                    "Access essential services to ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const Text(
                    "keep your city life running smoothly.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: cards
                        .map(
                          (row) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CardWidget(
                                    icon: Image.asset(
                                        "assets/icons/${row[0]["icon"]}"),
                                    title: Text(
                                      row[0]["text"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500),
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
