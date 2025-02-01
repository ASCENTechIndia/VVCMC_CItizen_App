import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_widget.dart';
import 'package:vvcmc_citizen_app/widgets/register_complaint_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_widget.dart';

class UtilitiesScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const UtilitiesScreen({required this.navigatorKey, super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  final answers = List<String>.generate(7, (index) => "Yes");
  final soapClient = getIt<SoapClient>();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text =
        "${prefs.getString("firstName")!} ${prefs.getString("lastName")!}";
    mobileController.text = prefs.getString("mobile")!;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (widget.navigatorKey.currentState == null) return;
        if (widget.navigatorKey.currentState!.canPop()) {
          widget.navigatorKey.currentState!.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes = {
            "/": buildUtilities,
            "view_your_property_tax": (context) => PropertyTaxWidget(),
            "view_your_water_tax": (context) => const WaterTaxWidget(),
            "register_your_complaint": (context) =>
                const RegisterComplaintWidget(),
            "clean_vvmc": buildClean,
            "vvmt": buildVVMT,
            "download_property_tax_receipt": (context) =>
                const PropertyTaxReceiptWidget(),
            "download_water_tax_receipt": (context) =>
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

  Widget buildVVMT(context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: localizations.from,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: localizations.to,
              border: const OutlineInputBorder(
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
            child: Text(localizations.search),
          ),
        ],
      ),
    );
  }

  Widget buildClean(context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> questions = [
      localizations.questionOne,
      localizations.questionTwo,
      localizations.questionThree,
      localizations.questionFour,
      localizations.questionFive,
      localizations.questionSix,
      localizations.questionSeven,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.cleanVvmc),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.nameIsRequired;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: localizations.name,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.mobileIsRequired;
                        }
                        if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
                          return localizations.mobileIsInvalid;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: localizations.mobileNo,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: areaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.areaIsRequired;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: localizations.area,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: landmarkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.landmarkIsRequired;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: localizations.landmark,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.addressIsRequired;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: localizations.address,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(
                        questions.length,
                        (index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(questions[index]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: "Yes",
                                          groupValue: answers[index],
                                          onChanged: (value) {
                                            if (value == null) return;
                                            setState(() {
                                              answers[index] = value;
                                            });
                                          },
                                        ),
                                        Text(localizations.yes),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: "No",
                                          groupValue: answers[index],
                                          onChanged: (value) {
                                            if (value == null) return;
                                            setState(() {
                                              answers[index] = value;
                                            });
                                          },
                                        ),
                                        Text(localizations.no),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        bool success = await soapClient.submitCitizenFeedback(
                          nameController.text,
                          mobileController.text,
                          areaController.text,
                          landmarkController.text,
                          addressController.text,
                          answers[0] == "Yes",
                          answers[1] == "Yes",
                          answers[2] == "Yes",
                          answers[3] == "Yes",
                          answers[4] == "Yes",
                          answers[5] == "Yes",
                          answers[6] == "Yes",
                        );
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations
                                    .feedbackSubmittedSuccessfully),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.somethingWentWrong),
                              ),
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      child: Text(localizations.submit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUtilities(context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    List cards = [
      [
        {
          "icon": "property-tax.png",
          "text": localizations.viewYourPropertyTax,
          "onTap": () =>
              Navigator.of(context).pushNamed("view_your_property_tax"),
        },
        {
          "icon": "water-tax.png",
          "text": localizations.viewYourWaterTax,
          "onTap": () => Navigator.of(context).pushNamed("view_your_water_tax"),
        },
      ],
      [
        {
          "icon": "complaint.png",
          "text": localizations.registerYourComplaint,
          "onTap": () =>
              Navigator.of(context).pushNamed("register_your_complaint"),
        },
        {
          "icon": "clean.png",
          "text": localizations.cleanVvmc,
          "onTap": () => Navigator.of(context).pushNamed("clean_vvmc"),
        },
      ],
      [
        {
          "icon": "news.png",
          "text": localizations.newsUpdate,
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                "/web",
                arguments: {
                  "url": "https://vvcmc.in/vaccination-press-note",
                  "title": "News Update",
                },
              ),
        },
        {
          "icon": "track.png",
          "text": localizations.trackMyComplaint,
          "onTap": () => Navigator.of(context).pushNamed("track_my_complaint"),
        },
      ],
      [
        {
          "icon": "vvmt.png",
          "text": localizations.vvmt,
          "onTap": () => Navigator.of(context).pushNamed("vvmt"),
        },
        {
          "icon": "tax.png",
          "text": localizations.taxCalculator,
          "onTap": () async {
            String? session = await soapClient.getSession(
              prefs.getString("mobile")!,
              prefs.getString("email")!,
            );
            if (session == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.failedToGetSession),
                ),
              );
            }
            Navigator.of(context, rootNavigator: true).pushNamed(
              "/web",
              arguments: {
                "url":
                    "https://onlinevvcmc.in/VVCMCCitizenDashboard/FrmTaxCalculatorWeb.aspx?@=${prefs.getString("mobile")!}~${prefs.getString("email")!}~$session",
                "title": localizations.taxCalculator,
              },
            );
          },
        },
      ],
      [
        {
          "icon": "property-receipt.png",
          "text": localizations.downloadPropertyTaxReceipt,
          "onTap": () =>
              Navigator.of(context).pushNamed("download_property_tax_receipt"),
        },
        {
          "icon": "water-receipt.png",
          "text": localizations.downloadWaterTaxReceipt,
          "onTap": () =>
              Navigator.of(context).pushNamed("download_water_tax_receipt"),
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
                Text(
                  localizations.allTheTools,
                  style: const TextStyle(
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
