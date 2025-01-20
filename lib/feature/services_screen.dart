import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vvcmc_citizen_app/models/elected_member.dart';
import 'package:vvcmc_citizen_app/models/mayor_message.dart';
import 'package:vvcmc_citizen_app/models/official_numbers.dart';
import 'package:vvcmc_citizen_app/models/prabhag_samiti.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';

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
        setState(() {
          page = "Services";
        });
      },
      child: () {
        switch (page) {
          case "Services":
            return buildServices();
          case "About VVMC":
            return buildAbout();
          case "Emergency Number":
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
          default:
            return Container();
        }
      }(),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Commissioner Message",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                    (officialNumber) => Card.outlined(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              officialNumber.memberName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(officialNumber.designation),
                            Text(officialNumber.emailId),
                            Text("Ward: ${officialNumber.wardName}"),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                width: MediaQuery.of(context).size.width,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "7769049009",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: prabhagSamiti
                    .map(
                      (member) => Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.memberName),
                              Text(member.prabhagSamitiName),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        member.mobileNo,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                    (member) => Card.outlined(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.wardNo),
                            Text(member.memberName),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      member.mobileNo,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          CardWidget(title: Text("Hospitals")),
          SizedBox(height: 8),
          CardWidget(title: Text("Ambulannce")),
          SizedBox(height: 8),
          CardWidget(title: Text("Police Station")),
          SizedBox(height: 8),
          CardWidget(title: Text("Fire Brigades")),
          SizedBox(height: 8),
          CardWidget(title: Text("Blood Banks")),
          SizedBox(height: 8),
          CardWidget(title: Text("Eye Banks")),
          SizedBox(height: 8),
          CardWidget(title: Text("Government Offices")),
        ],
      ),
    );
  }

  Widget buildAbout() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "About VVMC",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
    );
  }

  Widget buildServices() {
    List cards = [
      [
        {"icon": "logo.png", "text": "About VVMC"},
        {"icon": "emergency.png", "text": "Emergency Number"},
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
    return SingleChildScrollView(
      child: SizedBox(
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
      ),
    );
  }
}
