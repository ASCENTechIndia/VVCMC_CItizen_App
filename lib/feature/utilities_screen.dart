import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/models/bus_schedule.dart';
import 'package:vvcmc_citizen_app/models/complaint_details.dart';
import 'package:vvcmc_citizen_app/models/complaint_status.dart';
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
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dustbinNoController = TextEditingController();
  final optControllers = List<TextEditingController>.generate(
    5,
    (index) => TextEditingController(),
  );
  String complaintNo = "";
  int? dustbinType;
  File? opt1Image;

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
        nameController.text =
            "${prefs.getString("firstName")!} ${prefs.getString("lastName")!}";
        mobileController.text = prefs.getString("mobile")!;
        areaController.text = "";
        landmarkController.text = "";
        addressController.text = "";
        fromController.text = "";
        toController.text = "";
        for (int i = 0; i < answers.length; i++) {
          answers[i] = "Yes";
        }
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
            "view_your_property_tax": (context) => const PropertyTaxWidget(),
            "view_your_water_tax": (context) => const WaterTaxWidget(),
            "register_your_complaint": (context) =>
                const RegisterComplaintWidget(),
            "clean_vvmc": buildClean,
            "track_my_complaint": buildTrack,
            "track_my_complaint/complaint_details": buildComplaintDetails,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.busTimeTable),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: fromController,
                decoration: InputDecoration(
                  hintText: localizations.from,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: toController,
                decoration: InputDecoration(
                  hintText: localizations.to,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () async {
                  setState(() {});
                },
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
        ),
        Expanded(
          child: FutureBuilder(
            future:
                fromController.text.isNotEmpty && toController.text.isNotEmpty
                    ? soapClient.getBusScheduleFromTo(
                        fromController.text, toController.text)
                    : soapClient.getBusSchedule(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BusSchedule> busSchedules = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 16, left: 16, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 700),
                        child: Builder(
                          builder: (context) {
                            List<TableRow> rows = [
                              TableRow(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                children: [
                                  localizations.routeNo,
                                  localizations.from,
                                  localizations.to,
                                  localizations.stages,
                                  localizations.startTime,
                                  localizations.frequency,
                                  localizations.endTime,
                                ]
                                    .map(
                                      (item) => TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ];
                            for (var entry in busSchedules.asMap().entries) {
                              rows.add(
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: entry.key % 2 == 0
                                        ? Colors.white
                                        : Colors.blue[50],
                                  ),
                                  children: [
                                    entry.value.routeNo,
                                    entry.value.from,
                                    entry.value.to,
                                    entry.value.stages,
                                    entry.value.startTime,
                                    entry.value.frequency,
                                    entry.value.endTime,
                                  ]
                                      .map(
                                        (value) => TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                            return Table(
                              columnWidths: const {
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                5: FlexColumnWidth(2),
                              },
                              children: rows,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(localizations.somethingWentWrong));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildComplaintDetails(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: complaintNo),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getComplaintDetails(complaintNo),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<ComplaintDetails> complaintDetails = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      List<TableRow> rows = [
                        TableRow(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          children: [
                            localizations.statusDate,
                            localizations.status,
                            localizations.remark
                          ]
                              .map(
                                (item) => TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ];
                      for (var entry in complaintDetails.asMap().entries) {
                        rows.add(
                          TableRow(
                            decoration: BoxDecoration(
                              color: entry.key % 2 == 0
                                  ? Colors.white
                                  : Colors.blue[50],
                            ),
                            children: [
                              entry.value.date,
                              entry.value.status,
                              entry.value.remark
                            ]
                                .map(
                                  (value) => TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(value,
                                          style: const TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                      return Table(
                        columnWidths: const {
                          3: FlexColumnWidth(2),
                        },
                        children: rows,
                      );
                    },
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(localizations.somethingWentWrong));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildTrack(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.trackMyComplaint),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getComplaintStatus(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<ComplaintStatus> complaintStatus = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: complaintStatus
                        .map(
                          (complaint) => Card(
                            color: const Color(0xFFF5F5F5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[500]!),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  complaintNo = complaint.complaintNo;
                                });
                                Navigator.of(context).pushNamed(
                                    "track_my_complaint/complaint_details");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      complaint.complaintNo,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Table(
                                      columnWidths: const {
                                        1: FlexColumnWidth(2),
                                      },
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                            child: Text(
                                              localizations.complaintType,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Text(complaint.type)),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Text(
                                              localizations.status,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Text(complaint.status)),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Text(
                                              localizations.complaintDate,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Text(complaint.date)),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(localizations.somethingWentWrong));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
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
                        if (!RegExp(r"^\d{10}$").hasMatch(value)) {
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
                        (index) => Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                            if (answers[index] == "No" && index == 0)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      child: IconButton(
                                        iconSize: 40,
                                        icon: const Icon(
                                            Icons.camera_alt_outlined),
                                        onPressed: pickImage,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      opt1Image != null
                                          ? localizations.fileSelected
                                          : localizations.selectFile,
                                    ),
                                  ],
                                ),
                              )
                            else if (answers[index] == "No" && index == 1)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                      value: dustbinType,
                                      onChanged: (item) {
                                        setState(() {
                                          dustbinType = item;
                                        });
                                      },
                                      items: const [
                                        {"name": "Big", "value": 0},
                                        {"name": "Small", "value": 1},
                                      ]
                                          .map(
                                            (item) => DropdownMenuItem(
                                              value: item["value"] as int,
                                              child:
                                                  Text(item["name"] as String),
                                            ),
                                          )
                                          .toList(),
                                      decoration: InputDecoration(
                                        hintText: localizations.typeOfDustbin,
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: dustbinNoController,
                                      decoration: InputDecoration(
                                        hintText: localizations.no_,
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (answers[index] == "No")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.grey[100],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0),
                                    ),
                                  ),
                                  child: TextFormField(
                                    maxLines: 4,
                                    controller: optControllers[index - 2],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: InputBorder.none,
                                      hintText: localizations.message,
                                    ),
                                  ),
                                ),
                              )
                          ],
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
                          opt1Image,
                          answers[1] == "Yes",
                          dustbinType,
                          dustbinNoController.text,
                          answers[2] == "Yes",
                          optControllers[0].text,
                          answers[3] == "Yes",
                          optControllers[1].text,
                          answers[4] == "Yes",
                          optControllers[2].text,
                          answers[5] == "Yes",
                          optControllers[3].text,
                          answers[6] == "Yes",
                          optControllers[4].text,
                        );
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  localizations.feedbackSubmittedSuccessfully,
                                ),
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
                  "title": localizations.newsUpdate,
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

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (img == null) return;
    setState(() {
      opt1Image = File(img.path);
    });
  }
}
