import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/models/temperature.dart';

class TemperatureGridWidget extends StatelessWidget {
  const TemperatureGridWidget({
    super.key,
    required this.temperature,
  });

  final Temperature temperature;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: [
        Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.sunrise),
                const Text("Sunrise"),
                Text(temperature.sunrise),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.sunset),
                const Text("Sunset"),
                Text(temperature.sunset),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.wind),
                const Text("Wind"),
                Text("${temperature.wind}"),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.gauge_badge_plus),
                const Text("Pressure"),
                Text("${temperature.pressure}"),
              ],
            ),
          ),
        ),
        Container(),
        Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop),
                const Text("Humidity"),
                Text("${temperature.humidity}"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
