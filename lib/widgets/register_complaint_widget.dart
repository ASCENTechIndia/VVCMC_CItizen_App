import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/models/complaint_type.dart';
import 'package:vvcmc_citizen_app/models/department.dart';
import 'package:vvcmc_citizen_app/models/prabhag.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';

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
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final subjectController = TextEditingController();
  final detailsController = TextEditingController();
  int? prabhagId;
  int? departmentId;
  int? complaintId;
  List<ComplaintType> complaintTypes = [];

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
                            controller: mobileNoController,
                            decoration: const InputDecoration(
                              hintText: "Mobile No.",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
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
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
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
}
