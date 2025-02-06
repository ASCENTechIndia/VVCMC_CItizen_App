import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vvcmc_citizen_app/models/property_tax_receipt.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class PropertyTaxReceiptWidget extends StatefulWidget {
  const PropertyTaxReceiptWidget({
    super.key,
  });

  @override
  State<PropertyTaxReceiptWidget> createState() =>
      _PropertyTaxReceiptWidgetState();
}

class _PropertyTaxReceiptWidgetState extends State<PropertyTaxReceiptWidget> {
  final soapClient = getIt<SoapClient>();
  final propertyNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.propertyTaxReceipt),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: propertyNoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.propertyNoIsRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: localizations.propertyNo,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: buildDetails,
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
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
        ),
      ],
    );
  }

  Widget buildDetails(context, _, __) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.propertyTaxDetails),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getReceipt(
              propertyNoController.text,
              "HT",
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Receipt data = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Table(
                          border: TableBorder.symmetric(
                            outside: BorderSide(color: Colors.grey[600]!),
                          ),
                          columnWidths: const {
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizations.name),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.name),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizations.address),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.address),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizations.propertyNo),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.propertyNo),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            height: 1.0,
                            color: Colors.grey[400],
                            width: double.infinity,
                          ),
                        ),
                        ReceiptDetailsTable(
                          data: data,
                          soapClient: soapClient,
                          propertyNoController: propertyNoController,
                          localizations: localizations,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}

class ReceiptDetailsTable extends StatelessWidget {
  const ReceiptDetailsTable({
    super.key,
    required this.data,
    required this.soapClient,
    required this.propertyNoController,
    required this.localizations,
  });

  final Receipt data;
  final SoapClient soapClient;
  final TextEditingController propertyNoController;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        2: FlexColumnWidth(2),
      },
      children: () {
        List<TableRow> rows = [
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            children: ["Date", "Amount", "Receipt No"]
                .map(
                  (title) => TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        textAlign:
                            title == "Date" ? TextAlign.start : TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ];
        for (var entry in data.details.asMap().entries) {
          rows.add(
            TableRow(
              decoration: BoxDecoration(
                color: entry.key % 2 == 0 ? Colors.white : Colors.blue[50],
              ),
              children: [
                entry.value.date,
                entry.value.amount,
                entry.value.receiptNo,
              ]
                  .map(
                    (value) => TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: value == entry.value.receiptNo
                            ? InkWell(
                                child: Text(
                                  value,
                                  softWrap: false,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () async {
                                  String? url = await soapClient.getReceiptFile(
                                    propertyNoController.text,
                                    entry.value.receiptNo,
                                    "HT",
                                  );
                                  if (url == null) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              localizations.failedToLoadData),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                  await FlutterDownloader.enqueue(
                                    url: url.replaceFirst(
                                      "http://",
                                      "https://",
                                    ),
                                    headers: {},
                                    savedDir: "/storage/emulated/0/Download",
                                    showNotification: true,
                                    openFileFromNotification: true,
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Downloading file"),
                                      ),
                                    );
                                  }
                                },
                              )
                            : Text(
                                value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                textAlign: value == entry.value.date
                                    ? TextAlign.start
                                    : TextAlign.end,
                              ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }
        return rows;
      }(),
    );
  }
}
