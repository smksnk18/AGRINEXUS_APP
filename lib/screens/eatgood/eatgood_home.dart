import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import 'producer/producer_home.dart';
import 'consumer/consumer_home.dart';

class EatgoodHome extends StatefulWidget {
  const EatgoodHome({super.key});

  @override
  State<EatgoodHome> createState() => _EatgoodHomeState();
}

class _EatgoodHomeState extends State<EatgoodHome> {
  final List<String> titles = const [
    "Producer",
    "Consumer",
  ];
  final List<String> subtitles = const [
    "Register Food Products",
    "Analyze Food Safety",
  ];
  final List<IconData> icons = const [
    Icons.qr_code,
    Icons.health_and_safety,
  ];
  final List<List<Color>> gradients = const [
    [
      Color(0xff2D6A4F),
      Color(0xff40916C),
    ],
    [
      Color(0xff9D4EDD),
      Color(0xffC77DFF),
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
          "EatGood",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Healthy Food Analyzer",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Explore Your Health Dashboard",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (_, constraints) {
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
                        padding: EdgeInsets.all(20),
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
                                      builder: (_) => const ProducerHome(),
                                    ),
                                  );
                                }
                                else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ConsumerHome(),
                                    ),
                                  );
                                }
                              }


                          );
                        }
                    );
                  }
                  ),
            ),
          ]
        ),
    ),
        ),
        );

  }
}
