import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/widgets/helpers/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sticky_headers/sticky_headers.dart';

class GridHeader extends StatefulWidget {
  @override
  _GridHeaderState createState() => _GridHeaderState();
}

class _GridHeaderState extends State<GridHeader> {
  List<String> listHeader = ['HEADER1', 'HEADER2'];
  List<String> listTitle = [
    'title1',
    'title2',
    'title3',
    'title4',
    'title5',
    'title6',
    'title7',
    'title8',
  ];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Colors


//Ratings
  int starCount = 5;
  double rating = 4.5;

  List _onSaleProducts = [
    AssetImage(
      'assets/farma.jpg',
    ),
    AssetImage('assets/prod6.jpg'),
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
  List _prodType = [
    'Edibles',
    'Cartridges',
    'Vape Pen',
    'Topicals',
  ];

  List _price = [
    '\$7.99',
    '\$12.99',
    '\$9.99',
    '\$14.99',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid Header Demo"),
      ),
      body: gridHeader(),
    );
  }

  Widget gridHeader() {
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWeight = MediaQuery.of(context).size.height;

    return new ListView.builder(
      itemCount: listHeader.length,
      itemBuilder: (context, index) {
        return new StickyHeader(
          overlapHeaders: false,
          header: Column(
            children: <Widget>[
              Container(
                height: fullHeight / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _onSaleProducts[index], fit: BoxFit.fill)),
                child: Center(
                  child: CircleAvatar(
                    foregroundColor: buddiesPurple,
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/sweetleaf.png'),
                  ),
                ),
              ),
              _buildCoupon()
            ],
          ),
          content: Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listTitle.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (contxt, indx) {
                return Container(
                  margin: EdgeInsets.all(4.0),
                  color: Colors.purpleAccent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, top: 6.0, bottom: 2.0),
                    child: Center(
                        child: Text(
                      listTitle[indx],
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    )),
                  ),
                );
              },
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }

  _buildCoupon() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(18),
            color: Colors.orange[300]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.tag)),
            Text(
              '10% Off Your Order Applied \nAt Checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: HexColor('1c1463'),
              ),
            ),
            Icon(
              FontAwesomeIcons.shoppingCart,
            )
          ],
        ),
      ),
    );
  }

}
