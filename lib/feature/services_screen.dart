import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class ServicesScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ServicesScreen({required this.navigatorKey, super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final soapClient = getIt<SoapClient>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (widget.navigatorKey.currentState == null) return;
        if (widget.navigatorKey.currentState!.canPop()) {
          widget.navigatorKey.currentState!.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: widget.navigatorKey,
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
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.gallery),
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
                                      child: Text(localizations.close),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildGovernmentOffices(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.governmentOffices),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildEyeBanks(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.eyeBanks),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildBloodBanks(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.bloodBanks),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildFireBrigades(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.fireBrigades),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildPoliceStation(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.policeStation),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildAmbulance(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.ambulance),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildHospitals(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.hospitals),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildMap(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.corporationMap),
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
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.mayorMessage),
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
                        Center(
                          child: Text(mayorMessage.mayorName),
                        ),
                        const SizedBox(height: 10),
                        Text(mayorMessage.mayorMessage),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildCommissioner(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.commissionerMessage),
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
                      localizations.shriAnilkumar,
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${localizations.email}: commissioner.vvmc@gov.in",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(localizations.commissionerMessageContent),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOfficial(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.officialNumbers),
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
                                "${localizations.ward}: ${officialNumber.wardName}",
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildPrabhag(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.prabhagSamiti),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildElected(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.electedMembers),
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
                return Center(child: Text(localizations.failedToLoadData));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget buildEmergency(context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CardWidget(
            icon: Image.asset("assets/icons/hospital.png"),
            title: Text(localizations.hospitals),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/hospitals"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/ambulance.png"),
            title: Text(localizations.ambulance),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/ambulance"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/police.png"),
            title: Text(localizations.policeStation),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/police_station"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/fire-brigade.png"),
            title: Text(localizations.fireBrigades),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/fire_brigades"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/blood-bank.png"),
            title: Text(localizations.bloodBanks),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/blood_banks"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/eye.png"),
            title: Text(localizations.eyeBanks),
            onTap: () =>
                Navigator.of(context).pushNamed("emergency_numbers/eye_banks"),
          ),
          const SizedBox(height: 8),
          CardWidget(
            icon: Image.asset("assets/icons/government-office.png"),
            title: Text(localizations.governmentOffices),
            onTap: () => Navigator.of(context)
                .pushNamed("emergency_numbers/government_offices"),
          ),
        ],
      ),
    );
  }

  Widget buildAbout(context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderWidget(title: localizations.aboutVvmc),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.aboutContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildServices(context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    List cards = [
      [
        {
          "icon": "logo.png",
          "text": localizations.aboutVvmc,
          "onTap": () => Navigator.of(context).pushNamed("about_vvmc"),
        },
        {
          "icon": "emergency.png",
          "text": localizations.emergencyNumbers,
          "onTap": () => Navigator.of(context).pushNamed("emergency_numbers"),
        },
      ],
      [
        {
          "icon": "elected.png",
          "text": localizations.electedMembers,
          "onTap": () => Navigator.of(context).pushNamed("elected_member"),
        },
        {
          "icon": "prabhag.png",
          "text": localizations.prabhagSamiti,
          "onTap": () => Navigator.of(context).pushNamed("prabhag_samiti"),
        },
      ],
      [
        {
          "icon": "official.png",
          "text": localizations.officialNumbers,
          "onTap": () => Navigator.of(context).pushNamed("official_numbers"),
        },
        {
          "icon": "commissioner.png",
          "text": localizations.commissionerMessage,
          "onTap": () =>
              Navigator.of(context).pushNamed("commissioner_message"),
        },
      ],
      [
        {
          "icon": "mayor.png",
          "text": localizations.mayorMessage,
          "onTap": () => Navigator.of(context).pushNamed("mayor_message"),
        },
        {
          "icon": "map.png",
          "text": localizations.map,
          "onTap": () => Navigator.of(context).pushNamed("map"),
        },
      ],
      [
        {
          "icon": "gallery.png",
          "text": localizations.gallery,
          "onTap": () => Navigator.of(context).pushNamed("gallery"),
        },
        {
          "icon": "twitter.png",
          "text": localizations.twitter,
          "onTap": () => launchUrl(
                Uri.parse("https://twitter.com/VasaiVirarMcorp"),
              ),
        },
      ],
      [
        {
          "icon": "logo.png",
          "text": localizations.vvmcWebsite,
          "onTap": () => launchUrl(
                Uri.parse("https://vvcmc.in/"),
              ),
        },
        {
          "icon": "facebook.png",
          "text": localizations.facebook,
          "onTap": () => launchUrl(
                Uri.parse("https://facebook.com/vvcmc1"),
              ),
        },
      ],
      [
        {
          "icon": "youtube.png",
          "text": localizations.youtube,
          "onTap": () => launchUrl(
                Uri.parse(
                    "https://youtube.com/channel/UCeQZ7rHyw1-f_SCy5298YIg"),
              ),
        },
        {
          "icon": "vts.png",
          "text": localizations.vts,
          "onTap": () => launchUrl(
                Uri.parse("https://intouch.mapmyindia.com/nextgen"),
              ),
        },
      ],
      [
        {
          "icon": "",
          "text": localizations.rts,
          "onTap": () => launchUrl(
                Uri.parse("https://rtsvvmc.in/vvcmcrts"),
              ),
        },
        {
          "icon": "",
          "text": localizations.swachhata,
          "onTap": () => launchUrl(
                Uri.parse(
                  "https://play.google.com/store/apps/details?id=com.ichangemycity.swachhbharat",
                ),
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
                Text(
                  localizations.accessEssentialServices,
                  style: const TextStyle(
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
