import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/models/property_tax.dart';
import 'package:vvcmc_citizen_app/models/property_tax_details.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class PropertyTaxWidget extends StatelessWidget {
  PropertyTaxWidget({
    super.key,
  });

  final soapClient = getIt<SoapClient>();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final detailsFormKey = GlobalKey<FormState>();
  final propertyNoController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.propertyTax),
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
                        return localizations.propertyNoIsRequired;
                      }
                      return null;
                    },
                    controller: propertyNoController,
                    decoration: InputDecoration(
                      hintText: localizations.propertyNo,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
              ];
              return data;
            }(),
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
        HeaderWidget(title: localizations.propertyTaxBill),
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
                mobileController.text = prefs.getString("mobile")!;
                emailController.text = prefs.getString("email")!;
                if (data.taxes.isEmpty || data.taxes[0].isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.noDataFoundFor(propertyNo)
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
                            outside: BorderSide(color: Colors.grey[600]!),
                          ),
                          columnWidths: const {
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localizations.billNo,
                                      style: const TextStyle(
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
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                          },
                          children: () {
                            List<TableRow> rows = [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                children: [
                                  localizations.propertyTax,
                                  localizations.previous,
                                  localizations.current,
                                  localizations.total,
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
                            key: detailsFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return localizations.mobileIsRequired;
                                    }
                                    if (!RegExp(r"^[0-9]{10}")
                                        .hasMatch(value)) {
                                      return localizations.mobileIsInvalid;
                                    }
                                    return null;
                                  },
                                  controller: mobileController,
                                  decoration: InputDecoration(
                                    hintText: localizations.mobileNo,
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return localizations.emailIsRequired;
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return localizations.emailIsInvalid;
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: localizations.email,
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return localizations.amountIsRequired;
                                    }
                                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                                      return localizations.amountIsInvalid;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: localizations.amountToPay,
                                    border: const OutlineInputBorder(
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
                          onPressed: () {
                            if (detailsFormKey.currentState!.validate()) {}
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          child: Text(localizations.payBill),
                        )
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
