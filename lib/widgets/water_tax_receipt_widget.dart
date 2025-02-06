import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vvcmc_citizen_app/models/property_tax_receipt.dart';
import 'package:vvcmc_citizen_app/models/ward.dart';
import 'package:vvcmc_citizen_app/models/zone.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class WaterTaxReceiptWidget extends StatefulWidget {
  const WaterTaxReceiptWidget({
    super.key,
  });

  @override
  State<WaterTaxReceiptWidget> createState() => _WaterTaxReceiptWidgetState();
}

class _WaterTaxReceiptWidgetState extends State<WaterTaxReceiptWidget> {
  final soapClient = getIt<SoapClient>();
  final formKey = GlobalKey<FormState>();
  final taxNoController = TextEditingController();
  int? zoneId;
  int? wardId;
  List<Ward> wards = [];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.waterTaxReceipt),
        Expanded(
          child: Form(
            key: formKey,
            child: FutureBuilder(
              future: soapClient.getZones(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Zone> data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          localizations.zone,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          value: zoneId,
                          onChanged: (zid) async {
                            if (zid == null) return;
                            List<Ward> data = await soapClient.getWards(zid);
                            setState(() {
                              wards = data;
                              wardId = null;
                              zoneId = zid;
                            });
                          },
                          items: data
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            hintText: localizations.selectZone,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.ward,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          value: wardId,
                          onChanged: (wid) {
                            setState(() {
                              wardId = wid;
                            });
                          },
                          items: wards
                              .map(
                                (ward) => DropdownMenuItem(
                                  value: ward.id,
                                  child: Text(ward.name),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            hintText: localizations.selectWard,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: taxNoController,
                          decoration: InputDecoration(
                            hintText: localizations.taxNo,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: buildDetails,
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
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
                if (snapshot.hasError) {
                  return Center(child: Text(localizations.failedToLoadData));
                }
                return const Center(child: CircularProgressIndicator());
              },
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
        HeaderWidget(title: localizations.waterTaxDetails),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getReceipt(
              taxNoController.text,
              "WT",
              zoneId: zoneId,
              wardId: wardId,
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
                                    child: Text(localizations.connectionNo),
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
                          propertyNoController: taxNoController,
                          localizations: localizations,
                          zoneId: zoneId,
                          wardId: wardId,
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
    required this.zoneId,
    required this.wardId,
  });

  final Receipt data;
  final SoapClient soapClient;
  final TextEditingController propertyNoController;
  final AppLocalizations localizations;
  final int? zoneId;
  final int? wardId;

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
                                    "WT",
                                    zoneId: zoneId,
                                    wardId: wardId,
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
