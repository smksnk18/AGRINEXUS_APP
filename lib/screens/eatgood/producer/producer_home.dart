import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';
import 'add_product_screen.dart';
import 'product_list_screen.dart';
import 'qr_generate_screen.dart';

class ProducerHome extends StatelessWidget {
  const ProducerHome({super.key});
  final List<String> titles = const [
    "Add Product",
    "Product List",
  ];
  final List<String> subtitles = const [
    "Register food products",
    "View all products",
  ];
  final List<IconData> icons = const [
    Icons.add_box,
    Icons.inventory_2,
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
          "Producer",
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
                        "Producer Dashboard",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Manage food products",
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
                                        builder: (_) => const AddProductScreen(),
                                      ),
                                    );

                                  }

                                  else if(index ==1) {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProductListScreen(),
                                      ),
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