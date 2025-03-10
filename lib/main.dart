import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvcmc_citizen_app/feature/auth_screen.dart';
import 'package:vvcmc_citizen_app/feature/home/home_screen.dart';
import 'package:vvcmc_citizen_app/feature/notifications_screen.dart';
import 'package:vvcmc_citizen_app/feature/profile_screen.dart';
import 'package:vvcmc_citizen_app/feature/services_screen.dart';
import 'package:vvcmc_citizen_app/feature/sos_screen.dart';
import 'package:vvcmc_citizen_app/feature/utilities_screen.dart';
import 'package:vvcmc_citizen_app/feature/webview_screen.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
  await Future.wait([
    sl.init(),
    FlutterDownloader.initialize(ignoreSsl: true),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final prefs = sl.getIt<SharedPreferences>();
  late String locale;

  @override
  void initState() {
    locale = prefs.getString("locale") ?? "en";
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("mr"),
      ],
      title: 'VVMC Citizen App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFF338CC3),
          primary: const Color(0xFF338CC3),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            switch (settings.name) {
              case "/":
                return prefs.getBool("loggedIn") ?? false
                    ? Main(switchLocale: switchLocale)
                    : AuthScreen(switchLocale: switchLocale);
              case "/main":
                return Main(switchLocale: switchLocale);
              case "/notifications":
                return const NotificationsScreen();
              case "/profile":
                return const ProfileScreen();
              case "/web":
                final args = settings.arguments as Map;
                return WebViewScreen(
                  url: args["url"],
                  title: args["title"],
                  method: args["method"],
                  body: args["body"],
                );
              default:
                return Container();
            }
          },
        );
      },
    );
  }

  void switchLocale() {
    if ((prefs.getString("locale") ?? "en") == "en") {
      prefs.setString("locale", "mr");
      setState(() {
        locale = "mr";
      });
    } else {
      prefs.setString("locale", "en");
      setState(() {
        locale = "en";
      });
    }
  }
}

class Main extends StatefulWidget {
  final void Function() switchLocale;
  const Main({required this.switchLocale, super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  late final TabController _tabController;
  var homeNavigatorKey = GlobalKey<NavigatorState>();
  var servicesNavigatorKey = GlobalKey<NavigatorState>();
  var utilitiesNavigatorKey = GlobalKey<NavigatorState>();
  final prefs = sl.getIt<SharedPreferences>();

  @override
  void initState() {
    _tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
    _tabController.addListener(() {
      if (mounted && !_tabController.indexIsChanging) {
        setState(() {
          homeNavigatorKey = GlobalKey<NavigatorState>();
          servicesNavigatorKey = GlobalKey<NavigatorState>();
          utilitiesNavigatorKey = GlobalKey<NavigatorState>();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).primaryColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.vasaiVirarCity,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      localizations.municipalCorporation,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed("/notifications");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/icons/bell.png"),
                    ),
                  ),
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () async {
                    widget.switchLocale();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/icons/language.png"),
                    ),
                  ),
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed("/profile");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset("assets/icons/profile.png"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: _tabController.index == 3
              ? const BoxDecoration()
              : BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                        width: 2.0, color: Theme.of(context).primaryColor),
                  ),
                ),
          indicatorPadding: const EdgeInsets.only(bottom: 8.0),
          tabs: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Tab(
                icon: ImageIcon(
                  const AssetImage("assets/icons/home.png"),
                  color: _tabController.index == 0
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 32,
                ),
                child: Text(
                  localizations.home,
                  style: TextStyle(
                    fontWeight: _tabController.index == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Tab(
                icon: ImageIcon(
                  const AssetImage("assets/icons/services.png"),
                  color: _tabController.index == 1
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 32,
                ),
                child: Text(
                  localizations.services,
                  style: TextStyle(
                    fontWeight: _tabController.index == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Tab(
                icon: ImageIcon(
                  const AssetImage("assets/icons/utilities.png"),
                  color: _tabController.index == 2
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 32,
                ),
                child: Text(
                  localizations.utilities,
                  style: TextStyle(
                    fontWeight: _tabController.index == 2
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                child: Image.asset(
                  _tabController.index == 3
                      ? "assets/icons/sos-selected.png"
                      : "assets/icons/sos.png",
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          HomeScreen(navigatorKey: homeNavigatorKey),
          ServicesScreen(navigatorKey: servicesNavigatorKey),
          UtilitiesScreen(navigatorKey: utilitiesNavigatorKey),
          const SosScreen(),
        ],
      ),
    );
  }
}
