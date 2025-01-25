import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/models/property_tax.dart';
import 'package:vvcmc_citizen_app/models/property_tax_details.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class PropertyTaxWidget extends StatelessWidget {
  PropertyTaxWidget({
    super.key,
  });

  final SoapClient soapClient = getIt<SoapClient>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController propertyNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "View Your Property Tax"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: () {
              List<Widget> data = [
                Form(
                  key: formKey,
                  child: TextFormField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Property No. is required";
                      }
                      return null;
                    },
                    controller: propertyNoController,
                    decoration: const InputDecoration(
                      hintText: "Property No.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
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
                  child: const Text("Search"),
                ),
              ];
              return data;
            }(),
          ),
        ),
      ],
    );
  }

  Widget buildDetails(context, _, __) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Property Tax"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getPropertyTax(propertyNoController.text),
            builder: (context, snapshot) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              );
              String propertyNo = propertyNoController.text;
              if (snapshot.hasData) {
                PropertyTaxDetails data = snapshot.data!;
                if (data.taxes.isEmpty || data.taxes[0].isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "No data found for $propertyNo",
                        ),
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                  return Container();
                }
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
                                      "Bill No.",
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
                                      data.billNo,
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
                                    child: Text("Address"),
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
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Property No."),
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
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                          },
                          children: () {
                            List<TableRow> rows = [
                              TableRow(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                children: [
                                  "Property Tax",
                                  "Previous",
                                  "Current",
                                  "Total"
                                ]
                                    .map(
                                      (title) => TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            title,
                                            textAlign: TextAlign.center,
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
                            List<PropertyTax> taxes = data.taxes;
                            for (var entry in taxes.asMap().entries) {
                              rows.add(
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: entry.key == taxes.length - 1
                                        ? Theme.of(context).primaryColor
                                        : entry.key % 2 == 0
                                            ? Colors.white
                                            : Colors.blue[50],
                                  ),
                                  children: [
                                    entry.value.name,
                                    entry.value.previous,
                                    entry.value.current,
                                    entry.value.total,
                                  ]
                                      .map(
                                        (value) => TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontWeight: entry.key ==
                                                        taxes.length - 1
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: entry.key ==
                                                        taxes.length - 1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 12,
                                              ),
                                              textAlign:
                                                  value == entry.value.name
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
                return const Center(child: Text("Failed to load data"));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
