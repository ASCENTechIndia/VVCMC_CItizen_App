import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vvcmc_citizen_app/feature/home/temperature_grid_widget.dart';
import 'package:vvcmc_citizen_app/models/temperature.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart';
import 'package:vvcmc_citizen_app/utils/rest_client.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/widgets/card_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/property_tax_widget.dart';
import 'package:vvcmc_citizen_app/widgets/register_complaint_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_receipt_widget.dart';
import 'package:vvcmc_citizen_app/widgets/water_tax_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final navigatorKey = GlobalKey<NavigatorState>();
  final restClient = getIt<RestClient>();
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
          SystemNavigator.pop();
        }
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes = {
            "/": buildHome,
            "view_your_tax": buildViewTax,
            "view_your_tax/view_your_property_tax": (context) =>
                PropertyTaxWidget(),
            "view_your_tax/download_your_property_tax": (context) =>
                const PropertyTaxReceiptWidget(),
            "view_your_tax/view_your_water_tax": (context) =>
                const WaterTaxWidget(),
            "view_your_tax/download_your_water_tax": (context) =>
                const WaterTaxReceiptWidget(),
            "register_your_complaint": (context) =>
                const RegisterComplaintWidget(),
            "temperature": buildTemperature,
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

  Widget buildTemperature(context) {
    return FutureBuilder(
      future: restClient.getTemperature(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Temperature temperature = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  temperature.location,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Text(temperature.updateTime),
                const SizedBox(height: 20),
                Text(
                  temperature.description,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "${temperature.temp}°C",
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Min Temp: ${temperature.tempMin}°C"),
                    Text("Max Temp: ${temperature.tempMax}°C"),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TemperatureGridWidget(temperature: temperature),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildViewTax(context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    List cards = [
      [
        {
          "icon": "property-tax.png",
          "text": localizations.viewYourPropertyTax,
          "route": "view_your_property_tax",
        },
        {
          "icon": "water-tax.png",
          "text": localizations.viewYourWaterTax,
          "route": "view_your_water_tax",
        },
      ],
      [
        {
          "icon": "property-tax.png",
          "text": localizations.downloadYourPropertyTaxReceipt,
          "route": "download_your_property_tax",
        },
        {
          "icon": "water-tax.png",
          "text": localizations.downloadYourWaterTaxReceipt,
          "route": "download_your_water_tax",
        },
      ],
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cards
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/${row[0]["icon"]}"),
                        title: Text(
                          row[0]["text"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("view_your_tax/${row[0]["route"]}");
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CardWidget(
                        icon: Image.asset("assets/icons/${row[1]["icon"]}"),
                        title: Text(
                          row[1]["text"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("view_your_tax/${row[1]["route"]}");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildHome(context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    List cards = [
      [
        {
          "icon": "property-tax.png",
          "text": localizations.viewYourTax,
          "onTap": () => Navigator.of(context).pushNamed("view_your_tax"),
        },
        {
          "icon": "complaint.png",
          "text": localizations.registerYourComplaint,
          "onTap": () =>
              Navigator.of(context).pushNamed("register_your_complaint"),
        },
      ],
      [
        {
          "icon": "news.png",
          "text": localizations.newsUpdate,
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                "/web",
                arguments: {
                  "url": "https://vvcmc.in/vaccination-press-note",
                  "title": "News Update",
                },
              ),
        },
        {
          "icon": "vote.png",
          "text": localizations.election,
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                "/web",
                arguments: {
                  "url": "https://vvcmc.in/election-page",
                  "title": "Election",
                },
              ),
        },
      ],
      [
        {
          "icon": "temperature.png",
          "text": localizations.temperature,
          "onTap": () => Navigator.of(context).pushNamed("temperature"),
        },
        {
          "icon": "scheme.png",
          "text": localizations.scheme,
          "onTap": () => Navigator.of(context, rootNavigator: true).pushNamed(
                "/web",
                arguments: {
                  "url": "https://vvcmc.in/scheme",
                  "title": "Scheme",
                },
              ),
        }
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset("assets/images/banner.png", fit: BoxFit.fill),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.yourCityServices,
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
                                  "assets/icons/${row[0]["icon"]}",
                                ),
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
                                  "assets/icons/${row[1]["icon"]}",
                                ),
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
              Center(
                child: CardWidget(
                  icon: Image.asset("assets/icons/disaster.png"),
                  title: Text(
                    localizations.disasterManagement,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      "/web",
                      arguments: {
                        "url": "https://vvcmc.in/important-contact",
                        "title": localizations.disasterManagement,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
