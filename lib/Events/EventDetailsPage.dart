import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/widgets/helpers/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatefulWidget {
  final String cityImage;
  final String cityName;
  EventDetailPage({Key key, @required this.cityName, this.cityImage})
      : super(key: key);
  @override
  State createState() => _EventDetailPage(cityName, cityImage);
}

class _EventDetailPage extends State<EventDetailPage> {
  //Colors
  String cityImage;
  String cityName;
  _EventDetailPage(String cityName, String cityImage);

//Ratings
  int starCount = 5;
  double rating = 4.5;

//DateTime

  List _onSaleProducts = [
    AssetImage('assets/cbddate.jpeg'),
    AssetImage('assets/cbdYoga.jpeg'),
    AssetImage('assets/cbddate.jpeg'),
    AssetImage('assets/cbdYoga.jpeg'),
    AssetImage('assets/cbddate.jpeg'),
    AssetImage('assets/cbdYoga.jpeg'),
    AssetImage('assets/cbddate.jpeg'),
    AssetImage('assets/cbdYoga.jpeg'),
  ];
  List _colors = [
    Colors.white,
    buddiesGreen,
    Colors.white,
    Colors.white,
    buddiesGreen,
    Colors.white,
    Colors.white,
    buddiesGreen,
  ];

  List _onSaleDetail = [
    'CBD Almond Biscotti',
    'Green Crack Refil Cartridge',
    'Vape Pen',
    'CBD Topical Scrub',
  ];

  List _usage = [
    'CBD Vape Refil',
    'Green Crack Refil Cartridge',
    'Vape Pen',
    'CBD Topical Scrub',
  ];
  List _events = [
    'CannaGather',
    'High Times',
    'Women Grow',
    '420 Kool Parties',
    'CannaGather',
    'High Times',
    'Women Grow',
    '420 Kool Parties',
  ];
  List _time = [
    '4pm to 10pm',
    '5pm to 7pm',
    '11am to 2pm',
    '7pm to 10pm',
    '4pm to 10pm',
    '5pm to 7pm',
    '11am to 2pm',
    '7pm to 10pm',
  ];

  List _eventDetails = [
    'Maximize Revenue From Your Canna-Business',
    'BudTender Ball!',
    'Reform For Criminalizing Cannabis',
    'Learn How To Maximize Revenue From Your Canna-Business',
    'BudTender Ball!',
    'Reform For Criminalizing Cannabis',
    'Learn How To Maximize Revenue From Your Canna-Business',
    'BudTender Ball!',
  ];

  List _address = [
    'Location: 223 Broadway, New York, NY'
        'Location: 14 Union Avenue, New York, NY',
    'Location: 223 Albany Avenue, Brooklyn, NY',
    'Location: 223 Broadway, New York, NY'
        'Location: 14 Union Avenue, New York, NY',
    'Location: 223 Albany Avenue, Brooklyn, NY',
    'Location: 223 Broadway, New York, NY'
        'Location: 14 Union Avenue, New York, NY',
  ];

  List _price = [
    '\$7.99',
    '\$12.99',
    '\$9.99',
    '\$14.99',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEEEE, M/d/y').format(now);

    return Stack(children: <Widget>[
      Container(height: fullHeight, width: fullWeight),
      Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: buddiesGreen,
          centerTitle: true,
          title: Image.asset('assets/buddies.png', color: Colors.white),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.search),
                onPressed: () {},
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: fullHeight / 4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            widget.cityImage,
                          ),
                          fit: BoxFit.fill)),
                ),
                Positioned(
                  left: 10,
                  top: 20,
                  child: Text(
                    widget.cityName,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                    fontFamily: 'Poppins', color: buddiesPurple, fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[_buildEvents()],
                    )),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildEvents() {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _onSaleProducts.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Container(
          color: _colors[i],
          width: fullWeight,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 8,
                  child: Image(
                    height: 125,
                    width: 120,
                    image: _onSaleProducts[i],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _events[i],
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: buddiesPurple,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          _time[i],
                          style: TextStyle(
                              fontFamily: 'Roboto-Regular',
                              color: buddiesPurple,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      child: Text(
                        _eventDetails[i],
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            color: buddiesPurple,
                            fontSize: 12),
                      ),
                      constraints: BoxConstraints(maxWidth: 200),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      child: Text(
                        'Location: 223 Broadway, New York, NY',
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            color: buddiesPurple,
                            fontSize: 12),
                      ),
                      constraints: BoxConstraints(maxWidth: 250),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Get Tickets',
                        style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            color: buddiesPurple,
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        FontAwesomeIcons.externalLinkSquareAlt,
                        color: buddiesPurple,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
