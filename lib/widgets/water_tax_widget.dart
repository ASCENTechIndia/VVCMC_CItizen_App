import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final detailsFormKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final taxNoController = TextEditingController();
  final amountController = TextEditingController();
  int? zoneId;
  int? wardId;
  List<Ward> wards = [];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.viewYourWaterTax),
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
        HeaderWidget(title: localizations.waterTaxBill),
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
                mobileController.text = prefs.getString("mobile")!;
                emailController.text = prefs.getString("email")!;
                amountController.text = data.total;
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localizations.connectionNo,
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
                                    child: Text(localizations.roadName),
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      localizations.previousBillAmt,
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizations.currentBillAmt),
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(localizations.totalRs),
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
                            key: detailsFormKey,
                            child: Column(
                              children: [
                                TextFormField(
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
                                  controller: amountController,
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
                            if (formKey.currentState!.validate()) {}
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
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations.noDataFound,
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
