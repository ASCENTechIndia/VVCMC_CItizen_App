import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final soapClient = getIt<SoapClient>();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  String? bloodGroup;
  bool loading = false;

  @override
  void initState() {
    firstNameController.text = prefs.getString("firstName")!;
    lastNameController.text = prefs.getString("lastName")!;
    mobileController.text = prefs.getString("mobile")!;
    emailController.text = prefs.getString("email")!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorScheme.primary,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: colorScheme.onPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: Builder(
        builder: (context) {
          if (loading) return const Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "First Name is required";
                      }
                      return null;
                    },
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Last Name is required";
                      }
                      return null;
                    },
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Email is invalid";
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mobile is required";
                      }
                      if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
                        return "Mobile is invalid";
                      }
                      return null;
                    },
                    controller: mobileController,
                    decoration: const InputDecoration(
                      hintText: "Mobile",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: aadharController,
                    decoration: const InputDecoration(
                      hintText: "Aadhar No.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: bloodGroup,
                    onChanged: (item) {
                      setState(() {
                        bloodGroup = item;
                      });
                    },
                    items: const [
                      "Don't Know",
                      "A+",
                      "A-",
                      "B+",
                      "B-",
                      "AB+",
                      "AB-",
                      "O+",
                      "O-"
                    ]
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      hintText: "Select Blood Group",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        bool result = await soapClient.updateUserDetails(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          mobileController.text,
                          aadharController.text,
                          bloodGroup ?? "",
                        );
                        setState(() {
                          loading = false;
                        });
                        if (context.mounted) {
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Saved sucessfully"),
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
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
