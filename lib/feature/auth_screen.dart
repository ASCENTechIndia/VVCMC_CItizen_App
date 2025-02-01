import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final soapClient = getIt<SoapClient>();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final otpController = TextEditingController();
  bool loading = false;
  String? bloodGroup;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          localizations.vasaiVirarMunicipalCorporation,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          if (navigatorKey.currentState == null) return;
          if (navigatorKey.currentState!.canPop()) {
            navigatorKey.currentState!.pop();
          } else {
            SystemNavigator.pop();
          }
        },
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            final Map<String, WidgetBuilder> routes = {
              "/": buildRegister,
              "login": buildLogin,
              "otp": buildOtp,
            };
            var builder = routes[settings.name];
            builder ??= (context) => const Center(child: Text("No route"));
            return PageRouteBuilder(
              pageBuilder: (context, _, __) => builder!(context),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            );
          },
        ),
      ),
    );
  }

  Widget buildOtp(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.verifyOtp),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: localizations.enterOtp,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  bool result = await soapClient.verifyOTP(
                    mobileController.text,
                    otpController.text,
                  );
                  if (result) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("loggedIn", true);
                  }
                  setState(() {
                    loading = false;
                  });
                  if (context.mounted) {
                    if (result) {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed("/main");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.invalidOtp),
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
                child: Text(localizations.verify),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: Text(localizations.resendOtp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLogin(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.alreadyRegistered),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  bool result =
                      await soapClient.storeUserDetails(mobileController.text);
                  if (result) {
                    result = await soapClient.register(
                      prefs.getString("firstName")!,
                      prefs.getString("lastName")!,
                      prefs.getString("email")!,
                      prefs.getString("mobile")!,
                      prefs.getString("aadhar")!,
                      prefs.getString("bloodGroup")!,
                    );
                  }
                  setState(() {
                    loading = false;
                  });
                  if (context.mounted) {
                    if (result) {
                      Navigator.of(context).pushReplacementNamed("otp");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.failedToSendOtp),
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
                child: Text(localizations.submit),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRegister(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.register),
        Padding(
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
                    border: const OutlineInputBorder(
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
                    border: const OutlineInputBorder(
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
                    border: const OutlineInputBorder(
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
                  decoration:  InputDecoration(
                    hintText: localizations.mobileNo,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: aadharController,
                  decoration: InputDecoration(
                    hintText: localizations.aadharNo,
                    border: const OutlineInputBorder(
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
                    border: const OutlineInputBorder(
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
                      bool result = await soapClient.register(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        mobileController.text,
                        aadharController.text,
                        bloodGroup ?? "",
                      );
                      if (result) {
                        await Future.wait([
                          prefs.setString(
                            "firstName",
                            firstNameController.text,
                          ),
                          prefs.setString(
                            "lastName",
                            lastNameController.text,
                          ),
                          prefs.setString("mobile", mobileController.text),
                          prefs.setString("email", emailController.text),
                          prefs.setString("aadhar", aadharController.text),
                          prefs.setString("bloodGroup", bloodGroup ?? ""),
                        ]);
                      }
                      setState(() {
                        loading = false;
                      });
                      if (context.mounted) {
                        if (result) {
                          Navigator.of(context).pushReplacementNamed("otp");
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
                  child: Text(localizations.register),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("login");
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                  ),
                  child:  Text(localizations.alreadyRegistered),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
