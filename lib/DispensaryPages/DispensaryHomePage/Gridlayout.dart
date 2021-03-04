import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/SelectedProductPage/SelectedProduct.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CategoryAndProducts extends StatelessWidget {
  final productsInHeading;
  final bool showHeading;
  final dynamic dispensary;
  final int starCount;
  final double rating;
  final dynamic currentIndex;
  final dynamic filterNum;

  const CategoryAndProducts(
      {Key key,
      this.productsInHeading,
      this.showHeading,
      this.dispensary,
      this.starCount,
      this.rating,
      this.currentIndex,
      this.filterNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 10.0, right: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  productsInHeading.heading == "All"
                      ? ''
                      : productsInHeading.heading,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: buddiesPurple,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.25,
              child: GridView.builder(
                dragStartBehavior: DragStartBehavior.down,
                itemCount: filterNum != -1
                    ? productsInHeading.products.length
                    : productsInHeading.products.length,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: .5,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  var productMenu = productsInHeading.products;

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectedProduct(
                                    dispensary: dispensary,
                                    product: productMenu[i],
                                    dispensaryMenu: productMenu,
                                  )));

                      fromPreRec = false;
                    },
                    child: _buildProductList(
                        productMenu[i].name,
                        productMenu[i].image,
                        productMenu[i].usage,
                        productMenu[i].effect,
                        productMenu[i].productType,
                        '${productMenu[i].sizes[0].price.toStringAsFixed(2)}',
                        productMenu[i].quantity),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget _buildProductList(
      name, image, usage, effect, strain, price, quantity) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FadeInImage(
            width: 100,
            height: 125,
            image: NetworkImage(image),
            fit: BoxFit.fill,
            placeholder: AssetImage('assets/smiley.png'),
          ),
          Container(
            width: 150,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: buddiesPurple,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Feels : ' + effect,
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 14,
                        color: buddiesPurple),
                  ),
                ],
              ),
              Text(
                'Best For: ' + usage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 14,
                  color: buddiesPurple,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Starting At: \$$price',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 14,
                  color: buddiesPurple,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              StarRating(
                size: 18.0,
                rating: rating,
                color: Colors.orange,
                borderColor: Colors.grey,
                starCount: starCount,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
