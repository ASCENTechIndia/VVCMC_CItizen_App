import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/models/complaint_type.dart';
import 'package:vvcmc_citizen_app/models/department.dart';
import 'package:vvcmc_citizen_app/models/prabhag.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';
import 'dart:io';

class RegisterComplaintWidget extends StatefulWidget {
  const RegisterComplaintWidget({
    super.key,
  });

  @override
  State<RegisterComplaintWidget> createState() =>
      _RegisterComplaintWidgetState();
}

class _RegisterComplaintWidgetState extends State<RegisterComplaintWidget> {
  final soapClient = getIt<SoapClient>();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final subjectController = TextEditingController();
  final detailsController = TextEditingController();
  final location = Location();

  File? imgFile;
  int? prabhagId;
  int? departmentId;
  int? complaintId;
  List<ComplaintType> complaintTypes = [];

  @override
  void initState() {
    nameController.text =
        "${prefs.getString("firstName")!} ${prefs.getString("lastName")!}";
    mobileController.text = prefs.getString("mobile")!;
    emailController.text = prefs.getString("email")!;
    requestLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Register Your Complaint"),
        Expanded(
          child: FutureBuilder(
            future: Future.wait(
                [soapClient.getPrabhags(), soapClient.getDepartments()]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final prabhagData = snapshot.data![0] as List<Prabhag>;
                final departmentData = snapshot.data![1] as List<Department>;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Prabhag is required";
                              }
                              return null;
                            },
                            value: prabhagId,
                            onChanged: (pid) {
                              if (pid == null) return;
                              setState(() {
                                prabhagId = pid;
                              });
                            },
                            items: prabhagData
                                .map(
                                  (prabhag) => DropdownMenuItem(
                                    value: prabhag.id,
                                    child: Text(prabhag.name),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              hintText: "Select Prabhag",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Department is required";
                              }
                              return null;
                            },
                            value: departmentId,
                            onChanged: (did) async {
                              if (did == null) return;
                              List<ComplaintType> complaintTypeData =
                                  await soapClient.getComplaintTypes(did);
                              setState(() {
                                complaintTypes = complaintTypeData;
                                complaintId = null;
                                departmentId = did;
                              });
                            },
                            items: departmentData
                                .map(
                                  (department) => DropdownMenuItem(
                                    value: department.id,
                                    child: Text(department.name),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              hintText: "Select Department",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Complaint type is required";
                              }
                              return null;
                            },
                            value: complaintId,
                            onChanged: (cid) {
                              if (cid == null) return;
                              setState(() {
                                complaintId = cid;
                              });
                            },
                            items: complaintTypes
                                .map(
                                  (complaintType) => DropdownMenuItem(
                                    value: complaintType.id,
                                    child: Text(
                                      complaintType.name,
                                    ),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              hintText: "Select Complaint Type",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Complaint Details",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: "Name",
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
                              hintText: "Mobile No.",
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
                                return "Complainant's address is required";
                              }
                              return null;
                            },
                            controller: addressController,
                            decoration: const InputDecoration(
                              hintText: "Complainant's Address",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Complaint subject is required";
                              }
                              return null;
                            },
                            controller: subjectController,
                            decoration: const InputDecoration(
                              hintText: "Complaint Subject",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Complaint details are required";
                              }
                              return null;
                            },
                            controller: detailsController,
                            decoration: const InputDecoration(
                              hintText:
                                  "Complaint Details (100 characters max)",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              CircleAvatar(
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  onPressed: pickImage,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    String? location = await getLocation();
                                    if (location == null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Unable to fetch location"),
                                          ),
                                        );
                                        return;
                                      }
                                    }
                                    bool success =
                                        await soapClient.registerComplaint(
                                      departmentId.toString(),
                                      nameController.text,
                                      mobileController.text,
                                      detailsController.text,
                                      imgFile,
                                      emailController.text,
                                      location!,
                                      prabhagId.toString(),
                                      addressController.text,
                                      subjectController.text,
                                    );
                                    if (context.mounted) {
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Complaint registered sucessfully"),
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Something went wrong"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                    ),
                                  ),
                                  child: const Text("Submit"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              "GPS Location Service should be on",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (img == null) return;
    setState(() {
      imgFile = File(img.path);
    });
  }

  Future<bool> requestLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String?> getLocation() async {
    if (await requestLocation()) {
      var currentLocation = await location.getLocation();
      return '${currentLocation.latitude!},${currentLocation.longitude!}';
    }
    return null;
  }
}
