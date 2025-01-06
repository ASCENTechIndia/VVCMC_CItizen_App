import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List cards = [
      [
        {"icon": "property-tax.png", "text": "View Your Tax"},
        {"icon": "complaint.png", "text": "Register Your Complaint"},
      ],
      [
        {"icon": "news.png", "text": "News Update"},
        {"icon": "vote.png", "text": "Election"},
      ],
      [
        {"icon": "temperature.png", "text": "Temperature"},
        {"icon": "scheme.png", "text": "Scheme"},
      ],
    ];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/images/banner.png", fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Your city services, updates, and more - all in one place!",
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
                Center(
                  child: CardWidget(
                    icon: Image.asset("assets/icons/disaster.png"),
                    title: const Text(
                      "Disaster Management",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
