import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/bodySection.dart';
import 'package:fyp_project/MainPages/categorySection.dart';
import '../ViewProducts/categaryPage.dart';

class MydashboardPage extends StatefulWidget {
  final String id;
  const MydashboardPage({Key? key, required this.id}) : super(key: key);
  @override
  State<MydashboardPage> createState() => _MydashboardPageState(id);
}
final List<String> imgList = [
  'assets/share.jpeg',
  'assets/child.jpeg',
  'assets/Donate.jpeg',
  'assets/help.jpeg'
];
class _MydashboardPageState extends State<MydashboardPage> with TickerProviderStateMixin {
  String id;

  _MydashboardPageState(this.id);


  DateTime? _currentBackPressTime;

  Widget slider(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              CarouselSlider(
                  items: imgList.map((item) =>
                      Container(child:
                      Image(
                        image: AssetImage(
                            item),
                      )
                      ),
                  ).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  )
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: FittedBox(child: Text(
                    'TALEEM-E-KHAZANA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight
                          .bold,
                      fontFamily: 'Arvo',
                      fontSize: 28,))),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: FittedBox(
                  child: Text(
                    'Select option you want to explore',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight
                          .bold,
                      fontFamily: 'Anto',
                      fontSize: 20,),
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    print("idDA: " + id);
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTabController(
                      length: 5, // length of tabs
                      initialIndex: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                labelColor: Colors.blue,
                                unselectedLabelColor: Colors.black,
                                isScrollable: true,
                                labelPadding: EdgeInsets.symmetric(horizontal: 20),
                                tabs: [
                                  Tab(text: 'Books'),
                                  Tab(text: 'Bags'),
                                  Tab(text: 'Uniforms'),
                                  Tab(text: 'Stationary'),
                                  Tab(text: 'Shoes'),
                                ],
                              ),
                            ),
                            Container(
                              height: 575,
                                 //height of TabBarView
                                decoration: BoxDecoration(
                                    border: Border(top: BorderSide(
                                        color: Colors.grey,
                                      width: 0.5,),
                                    )
                                ),
                                child: TabBarView(children: <Widget>[
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        slider(),
                                        Body(id: id, category: 'Books',),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        slider(),
                                        Body(id: id, category: 'Bags',),
                                      ],
                                    ),
                                  ),

                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        slider(),
                                        Body(id: id, category: 'Uniforms',),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        slider(),
                                        Body(id: id, category: 'Stationary',),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        slider(),
                                        Body(id: id, category: 'Shoes',),
                                      ],
                                    ),
                                  ),
                                ])
                            )
                          ])
                  ),
                ]
            ),
          ),
        )
    );
  }

}