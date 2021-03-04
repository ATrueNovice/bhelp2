import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/Events/EventDetailsPage.dart';
import 'package:Buddies/widgets/helpers/Colors.dart';
import 'package:flutter/material.dart';

class EventLandingPage extends StatefulWidget {
  @override
  State createState() => _EventLandingPage();
}

class _EventLandingPage extends State<EventLandingPage> {


  List _cities = [
    'New York',
    'New Jersey',
    'Chicago',
    'Boston',
    'Los Angeles',
    'Detroit',
    'Philadelphia',
    'Portland',
    'San Francisco',
    'Seattle',
  ];
  List _citiesPhotos = [
    'assets/ny.jpeg',
    'assets/jersey.jpeg',
    'assets/chicago.jpeg',
    'assets/boston.jpeg',
    'assets/la.jpeg',
    'assets/detroit.jpeg',
    'assets/philly.jpeg',
    'assets/portland.jpeg',
    'assets/sanfran.jpeg',
    'assets/seattle.jpeg'
  ];


  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: buddiesGreen,
          centerTitle: true,
          title: buddiesLogo,
        ),
        body: Container(
            height: fullHeight,
            width: fullWeight,
            color: Colors.white,
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Happening Near Me:',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: HexColor('1c1463'),
                          fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(18)),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _cities.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (contxt, indx) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                print(_cities[indx]);
                                print(_citiesPhotos[indx]);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetailPage(
                                              cityImage: _citiesPhotos[indx],
                                              cityName: _cities[indx],
                                            )));
                              },
                              child: Stack(children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      image: DecorationImage(
                                          image:
                                              AssetImage(_citiesPhotos[indx]),
                                          fit: BoxFit.fill)),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 0,
                                  bottom: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 28.0),
                                    child: Text(
                                      _cities[indx],
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
