import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import '../notifications_page.dart';
import '../detail_page.dart';
import '../settings_page.dart';
import '../weather/weather_page.dart';
import 'package:agrinexus/screens/crop_guide/paddy_guide_screen.dart';
import '../eatgood/eatgood_home.dart';
import '../market/market_dashboard_screen.dart';
import '../govern/government_schemes/government_schemes_screen.dart';
import '../govern/government_schemes/scheme_details_screen.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  final List<String> titles = const [
    "Add Stock",
    "My Stock",
    "Weather Forecast",
    "Crop Guide",
    "Govt Schemes",
    "EatGood",
    "Market Value",
  ];
  List<String> filteredTitles = [];
  List<String> filteredSubtitles = [];
  List<IconData> filteredIcons = [];
  List<List<Color>> filteredGradients = [];
  final List<String> subtitles = const [
    "Add new stocks",
    "View your stocks",
    "The weather in your area",
    "Grow crops wisely",
    "Know govt schemes",
    "Know what's good for you",
    "Know the Live Price Your Nearby Area",
  ];
  final List<IconData> icons = const [
    Icons.person,
    Icons.people,
    Icons.sunny,
    Icons.grass_rounded,
    Icons.next_plan,
    Icons.qr_code_scanner,
    Icons.price_change,
  ];
  final List<List<Color>> gradients = const [
    [Color(0xff2D6A4F), Color(0xff40916C),],
    [Color(0xffF9A826), Color(0xffFFD166),],
    [Color(0xff4D96FF), Color(0xff6BCBFF),],
    [Color(0xff43AA8B), Color(0xff90BE6D),],
    [Color(0xff6C757D), Color(0xffADB5BD),],
    [Color(0xff9D4EDD), Color(0xffC77DFF),],
    [Color(0xff2D6A4F), Color(0xff40916C),],
  ];
  @override
  void initState() {
    super.initState();

    filteredTitles = List.from(titles);
    filteredSubtitles = List.from(subtitles);
    filteredIcons = List.from(icons);
    filteredGradients = List.from(gradients);
  }
  void searchCards(String value) {

    setState(() {

      filteredTitles.clear();
      filteredSubtitles.clear();
      filteredIcons.clear();
      filteredGradients.clear();

      for (int i = 0; i < titles.length; i++) {

        if (
        titles[i].toLowerCase().contains(value.toLowerCase()) ||
            subtitles[i].toLowerCase().contains(value.toLowerCase())
        ) {

          filteredTitles.add(titles[i]);
          filteredSubtitles.add(subtitles[i]);
          filteredIcons.add(icons[i]);
          filteredGradients.add(gradients[i]);

        }
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Agrinexus",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Badge(
              label: Text("3"),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff2D6A4F),
                      Color(0xff40916C),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: Color(0xff2D6A4F),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hemaprakash",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Farmer",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text("Weather"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WeatherPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.grass),
              title: Text("Crop Guide"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("Market Price"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarketDashboardScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.price_change),
              title: const Text("Govt Schemes"),
              onTap: () {

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const GovernmentSchemesScreen(),
                  ),
                );
              },
            ),

            Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
        Color(0xff43AA8B),
        icon:
        Icon(Icons.add),
        label:
        Text("New Crop"),
        onPressed: (){},
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
              const Color(0xff121212),
              const Color(0xff1E1E1E),
            ]
                : [
              const Color(0xffF5F7F9),
              const Color(0xffEEF7F0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Farmer Dashboard",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Explore Your Own Farmer Dashboard",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20,
                ),
                child: TextField(
                  onChanged: searchCards,
                  decoration:
                  InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    prefixIcon:
                    Icon(Icons.search, color: Color(0xff43AA8B)),
                    hintText:
                    "Search",
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: LayoutBuilder(
                    builder: (_, constraints) {
                      int count;
                      if (constraints.maxWidth < 600) {
                        count = 2;
                      }
                      else if (constraints.maxWidth < 1100) {
                        count = 3;
                      }
                      else {
                        count = 4;
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredTitles.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: count,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (_, index) {
                          return DashboardCard(
                            index: index,
                            title: filteredTitles[index],
                            subtitle: filteredSubtitles[index],
                            icon: filteredIcons[index],
                            colors: filteredGradients[index],
                            onTap: () {

                              if (filteredTitles[index] == "Weather Forecast") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WeatherPage(),
                                  ),
                                );
                                return;
                              }
                              if (filteredTitles[index] == "Crop Guide") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  PaddyGuideScreen(),
                                  ),
                                );
                                return;
                              }
                              if (filteredTitles[index] == "EatGood") {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EatgoodHome(),
                                  ),
                                );
                                return;


                              }
                              if (filteredTitles[index] == "Govt Schemes") {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const GovernmentSchemesScreen(),
                                  ),
                                );

                                return;
                              }

                              else if (filteredTitles[index] == "Market Value") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MarketDashboardScreen(),
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 400),

                                  pageBuilder: (_, animation, secondaryAnimation) =>
                                      DetailPage(
                                        title: filteredTitles[index],
                                        colors: filteredGradients[index],
                                        icon: filteredIcons[index],
                                      ),

                                  transitionsBuilder:
                                      (_, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
