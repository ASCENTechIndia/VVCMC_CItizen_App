import 'package:flutter/material.dart';
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
import 'package:vvcmc_citizen_app/widgets/header_widget.dart';
import 'package:vvcmc_citizen_app/widgets/outlined_card_widget.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});

  final navigatorKey = GlobalKey<NavigatorState>();
  final soapClient = getIt<SoapClient>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (navigatorKey.currentState == null) return;
        if (navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes = {
            "/": buildServices,
            "about_vvmc": buildAbout,
            "emergency_numbers": buildEmergency,
            "emergency_numbers/hospitals": buildHospitals,
            "emergency_numbers/ambulance": buildAmbulance,
            "emergency_numbers/police_station": buildPoliceStation,
            "emergency_numbers/fire_brigades": buildFireBrigades,
            "emergency_numbers/blood_banks": buildBloodBanks,
            "emergency_numbers/eye_banks": buildEyeBanks,
            "emergency_numbers/government_offices": buildGovernmentOffices,
            "elected_member": buildElected,
            "prabhag_samiti": buildPrabhag,
            "official_numbers": buildOfficial,
            "commissioner_message": buildCommissioner,
            "mayor_message": buildMayor,
            "map": buildMap,
            "gallery": buildGallery,
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
    );
  }

  Widget buildGallery(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Gallery"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getGallery(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<String> gallery = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: gallery.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Image.network(gallery[index]),
                                    const SizedBox(height: 10),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero),
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
          ),
        ),
      ],
    );
  }

  Widget buildGovernmentOffices(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Government Offices"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getGovernmentOffices(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<GovernmentOffice> governmentOffices = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildEyeBanks(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Eye Banks"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getEyeBanks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<EyeBank> eyeBanks = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildBloodBanks(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Blood Banks"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getBloodBanks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<BloodBank> bloodBanks = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildFireBrigades(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Fire Brigades"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getFireBrigades(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<FireBrigade> fireBrigades = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildPoliceStation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Police Stations"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getPolice(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Police> polices = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildAmbulance(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Ambulance"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getAmbulance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Ambulance> hospitals = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildHospitals(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Hospitals"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getHospitals(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Hospital> hospitals = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildMap(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Map"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.network(
                "https://www.onlinevvcmc.in/VVCMCPersonaliseApp/Documents/vvmc_map.jpg",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMayor(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Mayor Message"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getMayorMessage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final MayorMessage mayorMessage = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildCommissioner(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Commissioner Message"),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOfficial(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Official Numbers"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getOfficialNumbers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<OfficialNumbers> officialNumbers = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildPrabhag(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Prabhag Samiti"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getPrabhagSamiti(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<PrabhagSamiti> prabhagSamiti = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildElected(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderWidget(title: "Elected Member"),
        Expanded(
          child: FutureBuilder(
            future: soapClient.getElectedMembers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<ElectedMember> electedMembers = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
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

  Widget buildEmergency(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CardWidget(
            title: const Text("Hospitals"),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/hospitals"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Ambulance"),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/ambulance"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Police Station"),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/police_station"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Fire Brigades"),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/fire_brigades"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Blood Banks"),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/blood_banks"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Eye Banks"),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/eye_banks"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            title: const Text("Government Offices"),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/government_offices"),
          ),
        ],
      ),
    );
  }

  Widget buildAbout(context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: "About VVMC"),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget buildServices(context) {
    List cards = [
      [
        {
          "icon": "logo.png",
          "text": "About VVMC",
          "onTap": () => Navigator.of(context).pushNamed("about_vvmc"),
        },
        {
          "icon": "emergency.png",
          "text": "Emergency Numbers",
          "onTap": () => Navigator.of(context).pushNamed("emergency_numbers"),
        },
      ],
      [
        {
          "icon": "elected.png",
          "text": "Elected Member",
          "onTap": () => Navigator.of(context).pushNamed("elected_member"),
        },
        {
          "icon": "prabhag.png",
          "text": "Prabhag Samiti",
          "onTap": () => Navigator.of(context).pushNamed("prabhag_samiti"),
        },
      ],
      [
        {
          "icon": "official.png",
          "text": "Official Numbers",
          "onTap": () => Navigator.of(context).pushNamed("official_numbers"),
        },
        {
          "icon": "commissioner.png",
          "text": "Commissioner Message",
          "onTap": () =>
              Navigator.of(context).pushNamed("commissioner_message"),
        },
      ],
      [
        {
          "icon": "mayor.png",
          "text": "Mayor Message",
          "onTap": () => Navigator.of(context).pushNamed("mayor_message"),
        },
        {
          "icon": "map.png",
          "text": "Map",
          "onTap": () => Navigator.of(context).pushNamed("map"),
        },
      ],
      [
        {
          "icon": "gallery.png",
          "text": "Gallery",
          "onTap": () => Navigator.of(context).pushNamed("gallery"),
        },
        {
          "icon": "twitter.png",
          "text": "Twitter",
          "onTap": () => launchUrl(
                Uri.parse("https://twitter.com/VasaiVirarMcorp"),
              ),
        },
      ],
      [
        {"icon": "logo.png", "text": "VVMC Website"},
        {
          "icon": "facebook.png",
          "text": "Facebook",
          "onTap": () => launchUrl(
                Uri.parse("https://facebook.com/vvcmc1"),
              ),
        },
      ],
      [
        {
          "icon": "youtube.png",
          "text": "Youtube",
          "onTap": () => launchUrl(
                Uri.parse(
                    "https://youtube.com/channel/UCeQZ7rHyw1-f_SCy5298YIg"),
              ),
        },
        {
          "icon": "vts.png",
          "text": "VTS",
          "onTap": () => launchUrl(
                Uri.parse("https://intouch.mapmyindia.com/nextgen"),
              ),
        },
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
                                  onTap: row[0]["onTap"],
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
                                  onTap: row[1]["onTap"],
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
