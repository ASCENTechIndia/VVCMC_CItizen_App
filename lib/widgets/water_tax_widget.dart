import 'package:flutter/material.dart';
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
                          onChanged: (_) {},
                          items: data.map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name),
                            ),
                          ).toList(),
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
                          onChanged: (_) {},
                          items: const [],
                          decoration: const InputDecoration(
                            hintText: "Select Ward",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: "Tax No.",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: Theme.of(context).primaryColor),
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
}
