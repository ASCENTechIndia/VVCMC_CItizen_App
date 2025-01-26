import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/models/ward.dart';
import 'package:vvcmc_citizen_app/models/water_tax_details.dart';
import 'package:vvcmc_citizen_app/models/zone.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class WaterTaxWidget extends StatefulWidget {
  const WaterTaxWidget({
    super.key,
  });

  @override
  State<WaterTaxWidget> createState() => _WaterTaxWidgetState();
}

class _WaterTaxWidgetState extends State<WaterTaxWidget> {
  final soapClient = getIt<SoapClient>();
  final formKey = GlobalKey<FormState>();
  String zoneId = "";
  String wardId = "";
  final taxNoController = TextEditingController();
  List<Ward> wards = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Water Tax"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getZones(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Zone> data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Zone",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          onChanged: (zid) async {
                            if (zid == null) return;
                            List<Ward> data = await soapClient.getWards(zid);
                            setState(() {
                              wards = data;
                              zoneId = zid.toString();
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
                          decoration: const InputDecoration(
                            hintText: "Select Zone",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Ward",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          onChanged: (wid) {
                            setState(() {
                              wardId = wid?.toString() ?? "";
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
                          decoration: const InputDecoration(
                            hintText: "Select Ward",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: taxNoController,
                          decoration: const InputDecoration(
                            hintText: "Tax No.",
                            border: OutlineInputBorder(
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
                          child: const Text("Search"),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Failed to load data"));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildDetails(context, _, __) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Water Tax Bill"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getWaterTaxDetails(
              zoneId,
              wardId,
              taxNoController.text,
            ),
            builder: (context, snapshot) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              );
              if (snapshot.hasData) {
                WaterTaxDetails data = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Table(
                          border: TableBorder.symmetric(
                              outside: BorderSide(color: Colors.grey[600]!)),
                          columnWidths: const {
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor),
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Connection No.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      taxNoController.text,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Name"),
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
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Road Name"),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.roadName),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Previous Bill Amt.",
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.previousBillAmount),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Current Bill Amt."),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.currentBillAmount),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Total (Rs.)"),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data.total),
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
                        if (data.allowPayment)
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Mobile No.",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Amount to Pay",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          child: const Text("Pay Bill"),
                        )
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No data found",
                      ),
                    ),
                  ),
                );
                Navigator.of(context).pop();
                return Container();
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
