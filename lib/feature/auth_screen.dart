import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Vasai Virar Municipal Corporation",
          style: TextStyle(
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
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Verify OTP"),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(
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
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacementNamed("/main");
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: const Text("Verify"),
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
                child: const Text("Resend OTP"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLogin(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Login"),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  hintText: "Mobile",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacementNamed("/main");
                  });
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
      ],
    );
  }

  Widget buildRegister(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Register"),
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
                      bool result = await soapClient.register(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        mobileController.text,
                        aadharController.text,
                        bloodGroup ?? "",
                      );
                      if (result) {
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed("otp");
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
                  child: const Text("Register"),
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
                  child: const Text("Already Registered"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
