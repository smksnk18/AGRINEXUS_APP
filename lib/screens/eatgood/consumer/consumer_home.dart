import 'package:flutter/material.dart';

import '../../../widgets/dashboard_card.dart';

import 'health_profile_screen.dart';
import 'qr_scan_screen.dart';
import 'analysis_screen.dart';

class ConsumerHome extends StatefulWidget {
  const ConsumerHome({super.key});

  @override
  State<ConsumerHome> createState() => _ConsumerHomeState();
}

class _ConsumerHomeState extends State<ConsumerHome> {
  final List<String> titles = const [
    "Health Profile",
    "Scan Product",
    "Analysis",
  ];
  final List<String> subtitles = const [
    "Manage your health conditions",
    "Analyze food products",
    "View analysis results",
  ];
  final List<IconData> icons = const [
    Icons.medical_information,
    Icons.qr_code_scanner,
    Icons.analytics,
  ];
  final List<List<Color>> gradients = const [

    [
      Color(0xff4D96FF),
      Color(0xff6BCBFF),
    ],

    [
      Color(0xff9D4EDD),
      Color(0xffC77DFF),
    ],

    [
      Color(0xff43AA8B),
      Color(0xff90BE6D),
    ],

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: Text(
          "Consumer",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
            Theme.of(context).brightness == Brightness.dark
                ? [
              Color(0xff121212),
              Color(0xff1E1E1E),
            ]
                : [
              Color(0xffF5F7F9),
              Color(0xffEEF7F0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Consumer Dashboard",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Monitor your safety",
                    ),
                  ],
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
                        itemCount: titles.length,
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
                              title: titles[index],
                              subtitle: subtitles[index],
                              icon: icons[index],
                              colors: gradients[index],
                              onTap: () {

                                if (index == 0) {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HealthProfileScreen(),
                                    ),
                                  );

                                }

                                else if(index ==1) {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const QRScanScreen(),
                                    ),
                                  );
                                }

                                else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const QRScanScreen(),                                    ),
                                  );
                                }
                              }
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