import 'package:get_it/get_it.dart';
import 'package:vvcmc_citizen_app/utils/soap_client.dart';
import 'package:vvcmc_citizen_app/utils/rest_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton<SoapClient>(SoapClient());
  getIt.registerSingleton<RestClient>(RestClient());
}
