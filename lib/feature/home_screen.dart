import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                  "Your city services, updates,",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
                const Text(
                  "and more - all in one place!",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CardWidget(
                            icon: Image.asset("assets/icons/tax.png"),
                            title: const Text(
                              "View Your Tax",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CardWidget(
                            icon: Image.asset("assets/icons/complaint.png"),
                            title: const Text(
                              "Register Your Complaint",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/news.png"),
                        title: const Text(
                          "News Update",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/vote.png"),
                        title: const Text(
                          "Election",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/temperature.png"),
                        title: const Text(
                          "Temperature",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/scheme.png"),
                        title: const Text(
                          "Scheme",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: CardWidget(
                    icon: Image.asset("assets/icons/disaster.png"),
                    title: const Text(
                      "Disaster Management",
                      style: TextStyle(fontWeight: FontWeight.w500),
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
