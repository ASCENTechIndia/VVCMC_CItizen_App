import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_widget.dart';
import 'package:vvcmc_citizen_app/widgets/register_complaint_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_widget.dart';

import 'webview_screen.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (navigatorKey.currentState == null) return;
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes = {
            "/": buildUtilities,
            "view_your_property_tax": (context) => PropertyTaxWidget(),
            "view_your_water_tax": (context) => WaterTaxWidget(),
            "register_your_complaint": (context) =>
                const RegisterComplaintWidget(),
            "clean_vvmc": buildClean,
            "download_your_property_tax": (context) =>
                const PropertyTaxReceiptWidget(),
            "download_your_water_tax": (context) =>
                const WaterTaxReceiptWidget(),
          };
          var builder = routes[settings.name];
          builder ??= (context) => const Center(child: Text("No route"));
          return PageRouteBuilder(
            pageBuilder: (context, _, __) => builder!(context),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        },
      ),
    );
  }

  /*
  Widget build2(BuildContext build) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        setState(() {
          page = "Utilities";
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!["Utilities", "News Update", "Election", "Tax Calculator"]
              .contains(page))
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                page,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: () {
                switch (page) {
                  case "Utilities":
                    return buildUtilities();
                  case "View Your Property Tax":
                    return const PropertyTaxWidget();
                  case "View Your Water Tax":
                    return const WaterTaxWidget();
                  case "Register Your Complaint":
                    return const RegisterComplaintWidget();
                  case "Clean VVMC":
                    return buildClean();
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
                      page = "Utilities";
                    });
                    return buildUtilities();
                  case "VVMT":
                    return buildVVMT();
                  case "Tax Calculator":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => Navigator.of(context).pushNamed(
                        WebViewScreen.routeName,
                        arguments: {
                          "url":
                              "https://onlinevvcmc.in/VVCMCCitizenDashboard/FrmTaxCalculatorWeb.aspx",
                          "title": "Tax Calculator",
                        },
                      ),
                    );
                    setState(() {
                      page = "Utilities";
                    });
                    return buildUtilities();
                  case "Download Property Tax Receipt":
                    return const PropertyTaxReceiptWidget();
                  case "Download Water Tax Receipt":
                    return const WaterTaxReceiptWidget();
                  default:
                    return Container();
                }
              }(),
            ),
          ),
        ],
      ),
    );
  }
*/

  Widget buildVVMT() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: "From",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            decoration: InputDecoration(
              hintText: "To",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
    );
  }

  Widget buildClean(context) {
    Map questions = {
      "Do you find your area clean": "Yes",
      "Are you able to easily locate dust bins in your area": "Yes",
      "Door to door waste collection done and transported by municipal corporation people from your household daily":
          "Yes",
      "Acces to toiler public community toilet available": "Yes",
      "Basic information in the public/community toilet available and functional":
          "Yes",
      "Does your household have a toilet": "Yes",
      "Are there any unattended garbage heaps in your area": "Yes",
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Citizen Feedback"),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Mobile No.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Area",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Landmark",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: questions.entries
                        .map(
                          (question) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(question.key),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "Yes",
                                            groupValue: question.value,
                                            onChanged: (value) {
                                              setState(() {
                                                questions[question.key] = value;
                                              });
                                            },
                                          ),
                                          const Text("Yes"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "No",
                                            groupValue: question.value,
                                            onChanged: (value) {
                                              setState(() {
                                                questions[question.key] = value;
                                              });
                                            },
                                          ),
                                          const Text("No"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUtilities(context) {
    List cards = [
      [
        {
          "icon": "property-tax.png",
          "text": "View Your Property Tax",
          "onTap": () =>
              Navigator.of(context).pushNamed("view_your_property_tax"),
        },
        {
          "icon": "water-tax.png",
          "text": "View Your Water Tax",
          "onTap": () => Navigator.of(context).pushNamed("view_your_water_tax"),
        },
      ],
      [
        {
          "icon": "complaint.png",
          "text": "Register Your Complaint",
          "onTap": () =>
              Navigator.of(context).pushNamed("register_your_complaint"),
        },
        {
          "icon": "clean.png",
          "text": "Clean VVMC",
          "onTap": () => Navigator.of(context).pushNamed("clean_vvmc"),
        },
      ],
      [
        {
          "icon": "news.png",
          "text": "News Update",
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url": "https://vvcmc.in/vaccination-press-note",
                  "title": "News Update",
                },
              ),
        },
        {
          "icon": "track.png",
          "text": "Track My Complaint",
          "onTap": () => Navigator.of(context).pushNamed("track_my_complaint"),
        },
      ],
      [
        {
          "icon": "vvmt.png",
          "text": "VVMT",
          "onTap": () => Navigator.of(context).pushNamed("vvmt"),
        },
        {
          "icon": "tax.png",
          "text": "Tax Calculator",
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                WebViewScreen.routeName,
                arguments: {
                  "url":
                      "https://onlinevvcmc.in/VVCMCCitizenDashboard/FrmTaxCalculatorWeb.aspx",
                  "title": "Tax Calculator",
                },
              ),
        },
      ],
      [
        {
          "icon": "property-receipt.png",
          "text": "Download Property Tax Receipt",
          "onTap": () =>
              Navigator.of(context).pushNamed("download_property_tax_receipt"),
        },
        {
          "icon": "water-receipt.png",
          "text": "Download Water Tax Receipt",
          "onTap": () => Navigator.of(context)
              .pushNamed("download_property_water_receipt"),
        },
      ],
    ];
    return SizedBox(
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
                                  onTap: row[0]["onTap"],
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
                                  onTap: row[1]["onTap"],
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
    );
  }
}
