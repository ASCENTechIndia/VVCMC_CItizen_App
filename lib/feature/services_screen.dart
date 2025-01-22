import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vvcmc_citizen_app/models/ambulance.dart';
import 'package:vvcmc_citizen_app/models/blood_bank.dart';
import 'package:vvcmc_citizen_app/models/elected_member.dart';
import 'package:vvcmc_citizen_app/models/eye_bank.dart';
import 'package:vvcmc_citizen_app/models/fire_brigade.dart';
import 'package:vvcmc_citizen_app/models/government_office.dart';
import 'package:vvcmc_citizen_app/models/hospital.dart';
import 'package:vvcmc_citizen_app/models/mayor_message.dart';
import 'package:vvcmc_citizen_app/models/official_numbers.dart';
import 'package:vvcmc_citizen_app/models/police.dart';
import 'package:vvcmc_citizen_app/models/prabhag_samiti.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';
import 'package:vvcmc_citizen_app/widgets/outlined_card_widget.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String page = "Services";
  SoapClient soapClient = getIt<SoapClient>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        switch (page) {
          case "Hospitals":
          case "Ambulance":
          case "Police Station":
          case "Fire Brigades":
          case "Blood Banks":
          case "Eye Banks":
          case "Government Offices":
            setState(() {
              page = "Emergency Numbers";
            });
            break;
          default:
            setState(() {
              page = "Services";
            });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!["Services", "Twitter", "VVMC Website", "Facebook", "Youtube", "VTS"].contains(page))
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                page,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: () {
                switch (page) {
                  case "Services":
                    return buildServices();
                  case "About VVMC":
                    return buildAbout();
                  case "Emergency Numbers":
                    return buildEmergency();
                  case "Elected Member":
                    return buildElected();
                  case "Prabhag Samiti":
                    return buildPrabhag();
                  case "Official Numbers":
                    return buildOfficial();
                  case "Commissioner Message":
                    return buildComissioner();
                  case "Mayor Message":
                    return buildMayor();
                  case "Map":
                    return buildMap();
                  case "Twitter":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => launchUrl(
                        Uri.parse("https://twitter.com/VasaiVirarMcorp"),
                      ),
                    );
                    setState(() {
                      page = "Services";
                    });
                    return buildServices();
                  case "Gallery":
                    return buildGallery();
                  case "VVMC Website":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => launchUrl(
                        Uri.parse("https://vvcmc.in"),
                      ),
                    );
                    setState(() {
                      page = "Services";
                    });
                    return buildServices();
                  case "Facebook":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => launchUrl(
                        Uri.parse("https://facebook.com/vvcmc1"),
                      ),
                    );
                    setState(() {
                      page = "Services";
                    });
                    return buildServices();
                  case "Youtube":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => launchUrl(
                        Uri.parse(
                            "https://youtube.com/channel/UCeQZ7rHyw1-f_SCy5298YIg"),
                      ),
                    );
                    setState(() {
                      page = "Services";
                    });
                    return buildServices();
                  case "VTS":
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => launchUrl(
                        Uri.parse("https://intouch.mapmyindia.com/nextgen"),
                      ),
                    );
                    setState(() {
                      page = "Services";
                    });
                    return buildServices();
                  case "Hospitals":
                    return buildHospitals();
                  case "Ambulance":
                    return buildAmbulance();
                  case "Police Station":
                    return buildPolice();
                  case "Fire Brigades":
                    return buildFireBrigades();
                  case "Blood Banks":
                    return buildBloodBanks();
                  case "Eye Banks":
                    return buildEyeBanks();
                  case "Government Offices":
                    return buildGovernmentOffices();
                  default:
                    return Container();
                }
              }(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGallery() {
    return FutureBuilder(
      future: soapClient.getGallery(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<String> gallery = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: gallery.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridTile(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.network(gallery[index]),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                ),
                                child: const Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(gallery[index]),
                    ),
                  ),
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
    );
  }

  Widget buildGovernmentOffices() {
    return FutureBuilder(
      future: soapClient.getGovernmentOffices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<GovernmentOffice> governmentOffices = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: governmentOffices
                  .map(
                    (governmentOffice) => OutlinedCardWidget(
                      title: governmentOffice.name,
                      description: [governmentOffice.address],
                      contacts: [
                        governmentOffice.mobile1,
                        governmentOffice.mobile2,
                        governmentOffice.phone1,
                        governmentOffice.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildEyeBanks() {
    return FutureBuilder(
      future: soapClient.getEyeBanks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<EyeBank> eyeBanks = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: eyeBanks
                  .map(
                    (eyeBank) => OutlinedCardWidget(
                      title: eyeBank.name,
                      description: [eyeBank.address],
                      contacts: [
                        eyeBank.mobile1,
                        eyeBank.mobile2,
                        eyeBank.phone1,
                        eyeBank.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildBloodBanks() {
    return FutureBuilder(
      future: soapClient.getBloodBanks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<BloodBank> bloodBanks = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: bloodBanks
                  .map(
                    (bloodBank) => OutlinedCardWidget(
                      title: bloodBank.name,
                      description: [bloodBank.address],
                      contacts: [
                        bloodBank.mobile1,
                        bloodBank.mobile2,
                        bloodBank.phone1,
                        bloodBank.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildFireBrigades() {
    return FutureBuilder(
      future: soapClient.getFireBrigades(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<FireBrigade> fireBrigades = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: fireBrigades
                  .map(
                    (fireBrigade) => OutlinedCardWidget(
                      title: fireBrigade.department,
                      description: [fireBrigade.type],
                      contacts: [
                        fireBrigade.mobile1,
                        fireBrigade.mobile2,
                        fireBrigade.phone1,
                        fireBrigade.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildPolice() {
    return FutureBuilder(
      future: soapClient.getPolice(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Police> polices = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: polices
                  .map(
                    (police) => OutlinedCardWidget(
                      title: police.department,
                      description: const [],
                      contacts: [
                        police.mobile1,
                        police.mobile2,
                        police.phone1,
                        police.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildAmbulance() {
    return FutureBuilder(
      future: soapClient.getAmbulance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Ambulance> hospitals = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: hospitals
                  .map(
                    (hospital) => OutlinedCardWidget(
                      title: hospital.organization,
                      description: [hospital.address],
                      contacts: [
                        hospital.mobile1,
                        hospital.mobile2,
                        hospital.phone1,
                        hospital.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildHospitals() {
    return FutureBuilder(
      future: soapClient.getHospitals(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Hospital> hospitals = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: hospitals
                  .map(
                    (hospital) => OutlinedCardWidget(
                      title: hospital.doctorName,
                      description: [hospital.address],
                      contacts: [
                        hospital.mobile1,
                        hospital.mobile2,
                        hospital.phone1,
                        hospital.phone2,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildMap() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Image.network(
          "https://www.onlinevvcmc.in/VVCMCPersonaliseApp/Documents/vvmc_map.jpg",
        ),
      ),
    );
  }

  Widget buildMayor() {
    return FutureBuilder(
      future: soapClient.getMayorMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final MayorMessage mayorMessage = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(mayorMessage.imageUrl),
                const SizedBox(height: 10),
                Center(child: Text(mayorMessage.mayorName)),
                const SizedBox(height: 10),
                Text(mayorMessage.mayorMessage),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildComissioner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.network(
              "https://onlinevvcmc.in/App/MobileImages/commissioner_Sir_changes.JPG",
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Shri. Anilkumar Kanderao Pawar (I.A.S.)",
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Email: commissioner.vvmc@gov.in",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
              "The Corporation is constantly working for health and well being of its citizens and in lieu of that citizens pay various taxes. Information about these taxes including tax rates, necessary application forms and their details is given on the website in a simple and easily understandable language for the common man. Also importantly, the Development Plan of city has been made available on the website, which can be very useful for land use planning to the citizens."),
          const SizedBox(height: 10),
          const Text(
            "I will try to bring more transparency and accountability in the system through e-governance. As the Municipal Commissioner, I would like to assure the citizens of Vasai Virar that we would constantly endeavor to achieve the goal of improving services provided by the Corporation to its citizens and to ensure that the website is helpful as a step towards achievement of that goal.",
          ),
        ],
      ),
    );
  }

  Widget buildOfficial() {
    return FutureBuilder(
      future: soapClient.getOfficialNumbers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<OfficialNumbers> officialNumbers = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: officialNumbers
                  .map(
                    (officialNumber) => OutlinedCardWidget(
                      title: officialNumber.memberName,
                      description: [
                        officialNumber.designation,
                        officialNumber.emailId,
                        "Ward: ${officialNumber.wardName}",
                      ],
                      contacts: [
                        officialNumber.mobileNo,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildPrabhag() {
    return FutureBuilder(
      future: soapClient.getPrabhagSamiti(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<PrabhagSamiti> prabhagSamiti = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: prabhagSamiti
                  .map(
                    (prabhagSamiti) => OutlinedCardWidget(
                      title: prabhagSamiti.memberName,
                      description: [
                        prabhagSamiti.prabhagSamitiName,
                      ],
                      contacts: [
                        prabhagSamiti.mobileNo,
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildElected() {
    return FutureBuilder(
      future: soapClient.getElectedMembers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ElectedMember> electedMembers = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: electedMembers
                  .map(
                    (member) => OutlinedCardWidget(
                      title: member.wardNo,
                      description: [member.memberName],
                      contacts: [member.mobileNo],
                    ),
                  )
                  .toList(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load data"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildEmergency() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CardWidget(
            title: const Text("Hospitals"),
            onTap: () {
              setState(
                () {
                  page = "Hospitals";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Ambulance"),
            onTap: () {
              setState(
                () {
                  page = "Ambulance";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Police Station"),
            onTap: () {
              setState(
                () {
                  page = "Police Station";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Fire Brigades"),
            onTap: () {
              setState(
                () {
                  page = "Fire Brigades";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Blood Banks"),
            onTap: () {
              setState(
                () {
                  page = "Blood Banks";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Eye Banks"),
            onTap: () {
              setState(
                () {
                  page = "Eye Banks";
                },
              );
            },
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Government Offices"),
            onTap: () {
              setState(
                () {
                  page = "Government Offices";
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildAbout() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Vasai-Virar City is the only Municipal Corporation in the newly formed Palghar district. It is located at North Mumbai. The area of Vasai-Virar City is 311 sq. km. The city is located on the north bank of Vasai Creek, part of the estuary of the Ulhas River."),
          SizedBox(height: 10),
          Text(
            "Vasai-Virar City has been separated from Greater Mumbai and Mira-Bhayandar City by the Vasai Creek. The City is well connected to Mumbai by Western Railway and through Mumbai-Ahmedabad National Highway. The city is connected to Navi Mumbai, Thane, Bhiwandi, Kalyan and Panvel cities by the Vasai-Diva Railway line. Vasai Virar city has significant growth potential due to close proximity to Brihan Mumbai.",
          ),
          SizedBox(height: 10),
          Text(
              "The Vasai-Virar City Municipal Corporation (VVCMC) was established on 3rd July 2009. Vasai Virar corporation is located between 19 deg. 28 min. north-90 deg. 47 min. north latitude and 72 deg. 48 min. east-72 deg. 8 min. east"),
          SizedBox(height: 20),
          Text(
            "History",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
              "Vasai Virar is a historical city and an important business port. The history of Vasai comes from ancient ages. One version of the origin of the name derived from Sanskrit word which means 'waas' or residence. The Portuguese influence is especially noticeable in Vasai and Virar. When Marathas invaded and colonized the region, they named it as 'Bajipura' or 'Bajipur'. But it did not stick. When England conquered the region from Marathas in the year 1774, they named it as Bassein region which is now called Vasai. Bassein was an important trading centre of that time. From 15th century it was ruled by Portuguese, followed by Diu and British This region has many Heritage installations.. The Bassein fort was initially built by Bahadurshah of Gujarat and further developed by Portuguese."),
        ],
      ),
    );
  }

  Widget buildServices() {
    List cards = [
      [
        {"icon": "logo.png", "text": "About VVMC"},
        {"icon": "emergency.png", "text": "Emergency Numbers"},
      ],
      [
        {"icon": "elected.png", "text": "Elected Member"},
        {"icon": "prabhag.png", "text": "Prabhag Samiti"},
      ],
      [
        {"icon": "official.png", "text": "Official Numbers"},
        {"icon": "commissioner.png", "text": "Commissioner Message"},
      ],
      [
        {"icon": "mayor.png", "text": "Mayor Message"},
        {"icon": "map.png", "text": "Map"},
      ],
      [
        {"icon": "gallery.png", "text": "Gallery"},
        {"icon": "twitter.png", "text": "Twitter"},
      ],
      [
        {"icon": "logo.png", "text": "VVMC Website"},
        {"icon": "facebook.png", "text": "Facebook"},
      ],
      [
        {"icon": "youtube.png", "text": "Youtube"},
        {"icon": "vts.png", "text": "VTS"},
      ],
    ];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Access essential services to keep your city life running smoothly.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: cards
                      .map(
                        (row) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CardWidget(
                                  icon: Image.asset(
                                      "assets/icons/${row[0]["icon"]}"),
                                  title: Text(
                                    row[0]["text"],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      page = row[0]["text"];
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CardWidget(
                                  icon: Image.asset(
                                      "assets/icons/${row[1]["icon"]}"),
                                  title: Text(
                                    row[1]["text"],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      page = row[1]["text"];
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
