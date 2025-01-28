import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OutlinedCardWidget extends StatelessWidget {
  final String title;
  final List<String> description;
  final List<String> contacts;

  const OutlinedCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.grey[500]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: () {
            List<Widget> data = [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ];
            for (String text in description) {
              if (text.isNotEmpty) data.add(Text(text));
            }
            for (String mobile in contacts) {
              if (mobile.isNotEmpty) {
                data.add(const SizedBox(height: 10));
                data.add(
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Phone Call"),
                            content: Text("Do you wish to call $title?"),
                            actions: [
                              TextButton(
                                child: const Text("No"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  launchUrl(Uri.parse("tel:+91$mobile"));
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.white),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  mobile,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            return data;
          }(),
        ),
      ),
    );
  }
}
