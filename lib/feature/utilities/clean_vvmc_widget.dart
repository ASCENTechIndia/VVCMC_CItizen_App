import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class CleanVVMCWidget extends StatefulWidget {
  const CleanVVMCWidget({super.key});

  @override
  State<CleanVVMCWidget> createState() => _CleanVVMCWidgetState();
}

class _CleanVVMCWidgetState extends State<CleanVVMCWidget> {
  final soapClient = getIt<SoapClient>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final addressController = TextEditingController();
  bool loading = false;

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

  @override
  Widget build(context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Citizen Feedback"),
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
                          return "Name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile No. is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Mobile No.",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: areaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Area is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Area",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: landmarkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Landmark is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Landmark",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                                  questions[question.key] =
                                                      value;
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
                                                  questions[question.key] =
                                                      value;
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
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        List options = questions.values.toList();
                        String? message =
                            await soapClient.submitCitizenFeedback(
                          nameController.text,
                          mobileController.text,
                          areaController.text,
                          landmarkController.text,
                          addressController.text,
                          options[0] == "Yes",
                          options[1] == "Yes",
                          options[2] == "Yes",
                          options[3] == "Yes",
                          options[4] == "Yes",
                          options[5] == "Yes",
                          options[6] == "Yes",
                        );
                        if (context.mounted) {
                          if (message != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
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
                      child: const Text("Submit"),
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
}
