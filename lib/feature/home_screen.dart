import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vvcmc_citizen_app/feature/webview_screen.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_widget.dart';
import 'package:vvcmc_citizen_app/widgets/register_complaint_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String page = "Home";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        setState(() {
          switch (page) {
            case "View Your Property Tax":
            case "View Your Water Tax":
            case "Download Property Tax Receipt":
            case "Download Water Tax Receipt":
              page = "View Your Tax";
              break;
            default:
              page = "Home";
          }
        });
      },
      child: () {
        switch (page) {
          case "Home":
            return buildHome();
          case "View Your Tax":
            return buildViewTax();
          case "Register Your Complaint":
            return const RegisterComplaintWidget();
          case "Scheme":
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": "https://vvcmc.in/schemes",
                  "title": "Scheme",
                },
              ),
            );
            setState(() {
              page = "Home";
            });
            return buildHome();
          case "Disaster Management":
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": "https://vvcmc.in/important-contact",
                  "title": "Disaster Management",
                },
              ),
            );
            setState(() {
              page = "Home";
            });
            return buildHome();
          case "News Update":
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": "https://vvcmc.in/vaccination-press-note",
                  "title": "News Update",
                },
              ),
            );
            setState(() {
              page = "Home";
            });
            return buildHome();
          case "View Your Property Tax":
            return const PropertyTaxWidget();
          case "View Your Water Tax":
            return const WaterTaxWidget();
          case "Download Property Tax Receipt":
            return const PropertyTaxReceiptWidget();
          case "Download Water Tax Receipt":
            return const WaterTaxReceiptWidget();
          default:
            return Container();
        }
      }(),
    );
  }

  Widget buildViewTax() {
    List cards = [
      [
        {"icon": "property-tax.png", "text": "View Your Property Tax"},
        {
          "icon": "water-tax.png",
          "text": "View Your Water Tax",
        },
      ],
      [
        {"icon": "property-tax.png", "text": "Download Property Tax Receipt"},
        {
          "icon": "water-tax.png",
          "text": "Download Water Tax Receipt",
        },
      ],
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cards
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/${row[0]["icon"]}"),
                        title: Text(
                          row[0]["text"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            page = row[0]["text"];
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/${row[1]["icon"]}"),
                        title: Text(
                          row[1]["text"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            page = row[1]["text"];
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildHome() {
    List cards = [
      [
        {"icon": "property-tax.png", "text": "View Your Tax"},
        {
          "icon": "complaint.png",
          "text": "Register Your Complaint",
        },
      ],
      [
        {"icon": "news.png", "text": "News Update"},
        {"icon": "vote.png", "text": "Election"},
      ],
      [
        {"icon": "temperature.png", "text": "Temperature"},
        {
          "icon": "scheme.png",
          "text": "Scheme",
        }
      ],
    ];
    return Column(
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
                                onTap: () {
                                  setState(() {
                                    page = row[0]["text"];
                                  });
                                },
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
                                onTap: () {
                                  setState(() {
                                    page = row[1]["text"];
                                  });
                                },
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
                  onTap: () {
                    setState(() {
                      page = "Disaster Management";
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
