import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/feature/home/home_screen.dart';
import 'package:vvcmc_citizen_app/feature/services_screen.dart';
import 'package:vvcmc_citizen_app/feature/sos_screen.dart';
import 'package:vvcmc_citizen_app/feature/utilities_screen.dart';
import 'package:vvcmc_citizen_app/feature/webview_screen.dart';
import 'package:vvcmc_citizen_app/utils/get_it.dart' as sl;

void main() async {
  await sl.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                return const Main();
              case WebViewScreen.routeName:
                final args = settings.arguments as Map;
                return WebViewScreen(
                  url: args["url"],
                  title: args["title"],
                );
              default:
                return Container();
            }
          },
        );
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

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
  @override
  void initState() {
    _tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
    _tabController.addListener(() {
      if (mounted && !_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    // Todo: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Image.asset("assets/images/logo.png")),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vasai Virar City",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Municipal Corporation",
                      style: TextStyle(
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset("assets/icons/bell.png"),
                  ),
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset("assets/icons/language.png"),
                  ),
                ),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset("assets/icons/profile.png"),
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
                          width: 2.0, color: Theme.of(context).primaryColor))),
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
                  "Home",
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
                  "Services",
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
                  "Utilities",
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
          HomeScreen(),
          ServicesScreen(),
          UtilitiesScreen(),
          SosScreen(),
        ],
      ),
    );
  }
}
