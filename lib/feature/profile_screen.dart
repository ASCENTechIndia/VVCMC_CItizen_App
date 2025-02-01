import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorScheme.primary,
        title: Text(
          localizations.editProfile,
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
                      return localizations.firstNameIsRequired;
                      }
                      return null;
                    },
                    controller: firstNameController,
                    decoration: InputDecoration(
                    hintText: localizations.firstName,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return localizations.lastNameIsRequired;
                      }
                      return null;
                    },
                    controller: lastNameController,
                    decoration: InputDecoration(
                    hintText: localizations.lastName,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
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
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return localizations.mobileIsRequired;
                      }
                      if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
                      return localizations.mobileIsInvalid;
                      }
                      return null;
                    },
                    controller: mobileController,
                    decoration: InputDecoration(
                    hintText: localizations.mobileNo,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: aadharController,
                    decoration: InputDecoration(
                    hintText: localizations.aadharNo,
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
                    decoration: InputDecoration(
                    hintText: localizations.selectBloodGroup,
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
                              SnackBar(
                                content: Text(localizations.savedSuccessfully),
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
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: Text(localizations.save),
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
