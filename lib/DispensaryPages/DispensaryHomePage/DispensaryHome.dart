import 'package:Buddies/APIS/Apis.dart';
import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/Constants/Static_string.dart';
import 'package:Buddies/DispensaryPages/DispensaryHomePage/Gridlayout.dart';
import 'package:Buddies/DispensaryPages/SelectedProductPage/SelectedProduct.dart';
import 'package:Buddies/DispensaryPages/TabView/tabcategories.dart';
import 'package:Buddies/Model/DisNProducts.dart';
import 'package:Buddies/widgets/helpers/ImageGuard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

enum FilterTabs {
  All,
  Feels,
//  Rec,
  Relief,
  Categories,
}

typedef void FilterTabCallback(FilterTabs tab);

class DispensaryHome extends StatefulWidget {
  final dynamic dispensary;

  final double collapsedHeight;
  final double expandedHeight;

  int colorVal;

  DispensaryHome(
      {Key key,
      @required this.dispensary,
      this.collapsedHeight,
      this.expandedHeight,
      this.colorVal})
      : super(key: key);

  @override
  State createState() =>
      _DispensaryHome(dispensary, expandedHeight, collapsedHeight);
}

class _DispensaryHome extends State<DispensaryHome>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int colorVal;

  TabController _tabController;
  var filteredProducts;
  double cartTotal = 0;

//Ratings
  int starCount = 5;
  double rating = 4.5;

  dynamic dispensary;

//Products
  var productList;
  bool priceSorted = false;
  bool _priceSorted = false;
  bool _thcSorted = false;
  bool _cbdSorted = false;
  bool _showFab = true;
  int _shippingIconNum = 0;

  final double expandedHeight;
  final double collapsedHeight;

  double get minExtent => collapsedHeight;
  double get maxExtent => math.max(expandedHeight, minExtent);

  _DispensaryHome(this.dispensary, this.expandedHeight, this.collapsedHeight);

  List filterDropdown = [
    'Price: Low-High',
    'Price: High-Low',
    'THC: High-Low',
    'THC: Low-High',
    'Only CBD',
  ];

  List _shippingIndicatorIcons = [
    Container(
      child: Icon(
        FontAwesomeIcons.car,
        color: buddiesGreen,
        size: 25,
      ),
    ),
    Container(
      child: Icon(
        FontAwesomeIcons.truck,
        color: buddiesGreen,
        size: 25,
      ),
    ),
    Row(
      children: [
        Icon(
          FontAwesomeIcons.car,
          color: buddiesGreen,
          size: 25,
        ),
        Icon(
          FontAwesomeIcons.truck,
          color: buddiesGreen,
          size: 25,
        ),
      ],
    ),
  ];

  List _buttonColors = [Colors.white, buddiesGreen];

  List _tabDetails = [
    '',
    'Search By Feels',
    // 'For Me',
    'Search By Relief & Relaxation',
    'Search By Type',
  ];
  // final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  //Dropdown
  Color dropdownTextColor = Colors.white;
  int _currentCat = -1;
  int filterNumb = 0;
  int categoryNumber = 5;
  bool buttonPressed = false;
  var cannaIcon;
  FilterTabs selectedTab = FilterTabs.All;
  var nproducs;
  Future _setProducts;

  String finalDate = '';
  String dateName;

  @override
  void initState() {
    _setProducts = getProducts(dispensary.id);

    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
    CartProvider.of(context).dispensary = dispensary;

    _getShippingIndicator(dispensary.shippingMethod);
    getCurrentDate();
    super.initState();
  }

  getCurrentDate() {
    var date = new DateTime.now();

    print("weekday is ${date.weekday}");

    switch (date.weekday) {
      case 1:
        setState(() {
          dateName = 'Monday';
        });
        break;
      case 2:
        setState(() {
          dateName = 'Tuesday';
        });
        break;
      case 3:
        setState(() {
          dateName = 'Wednesday';
        });
        break;
      case 4:
        setState(() {
          dateName = 'Thursday';
        });
        break;
      case 5:
        setState(() {
          dateName = 'Friday';
        });
        break;
      case 6:
        setState(() {
          dateName = 'Saturday';
        });
        break;
      case 7:
        setState(() {
          dateName = 'Sunday';
        });
        break;

      default:
    }
  }

  void _handleTabSelection() {
    setState(() {
      widget.colorVal = 0xff3f51b5;
      filterNumb = _tabController.index;

      print(_tabController.index);
    });
  }

  void cartCheck(recPro) {
    final cart = CartProvider.of(context);
    if (cart.orderDetails != null) {
    } else {
      print('object');
    }
  }

  void priceSort(List list) {
    list.sort((a, b) => _priceSorted ? a.compareTo(b) : b.compareTo(a));
    _priceSorted = !_priceSorted;
  }

  _changedDropDownItem(int newValue) {
    setState(() {
      selectedTab = FilterTabs.values[newValue];

      _currentCat = -1;
    });
    _fabShown(newValue);
  }

  void _fabShown(tab) {
    if (tab == 0) {
      setState(() {
        _showFab = true;
      });
    } else {
      _showFab = false;
    }
  }

  int compareProductBySmallestSize(Product lhs, Product rhs) {
    var lhsPrice = lhs.sizes[0].price;
    var rhsPrice = rhs.sizes[0].price;
    return lhsPrice.compareTo(rhsPrice);
  }

  int compareProductByLargestSize(Product rhs, Product lhs) {
    var lhsPrice = rhs.sizes[0].price;
    var rhsPrice = lhs.sizes[0].price;
    return rhsPrice.compareTo(lhsPrice);
  }

  int compareTHCByLargestSize(Product rhs, Product lhs) {
    var lhsPrice = rhs.thcContent;
    var rhsPrice = lhs.thcContent;
    return rhsPrice.compareTo(lhsPrice);
  }

  int compareTHCBySmallestSize(Product lhs, Product rhs) {
    var lhsPrice = lhs.thcContent;
    var rhsPrice = rhs.thcContent;
    return lhsPrice.compareTo(rhsPrice);
  }

  int compareCBDByLargestSize(Product rhs, Product lhs) {
    var lhsPrice = rhs.cbdContent;
    var rhsPrice = lhs.cbdContent;
    return rhsPrice.compareTo(lhsPrice);
  }

  int compareCBDBySmallestSize(Product lhs, Product rhs) {
    var lhsPrice = lhs.cbdContent;
    var rhsPrice = rhs.cbdContent;
    return lhsPrice.compareTo(rhsPrice);
  }

  void _sortProductsDropDown(_fabSort, sortList) {
    switch (_fabSort) {
      case 0:
        print('Name Sort');
        break;
      case 1:
        if (_priceSorted = !_priceSorted) {
          setState(() {
            print('Sort by Lowest Price');

            sortList = sortList.sort(compareProductBySmallestSize);
          });
        } else {
          setState(() {
            print('Sort by Highest Price');

            sortList = sortList.sort(compareProductByLargestSize);
          });
        }

        break;
      case 2:
        setState(() {
          if (_thcSorted = !_thcSorted) {
            print('Sort By Highest Grade THC');
            setState(() {
              sortList = sortList.sort(compareTHCByLargestSize);
            });
          } else {
            setState(() {
              print('Sort By Lowest Grade THC');

              sortList = sortList.sort(compareTHCBySmallestSize);
            });
          }
        });

        break;
      case 3:
        setState(() {
          if (_cbdSorted = !_cbdSorted) {
            print('Sort By Highest Grade CBD');
            setState(() {
              sortList = sortList.sort(compareCBDByLargestSize);
            });
          } else {
            setState(() {
              print('Sort By Lowest Grade CBD');

              sortList = sortList.sort(compareCBDBySmallestSize);
            });
          }
        });
        break;
    }
  }

  //Drop down

  List<ProductsInHeading> _getProductsInHeadings(List<Product> items) {
    switch (selectedTab) {
      case FilterTabs.All:
        return TabCategories.all
            .map((e) => ProductsInHeading(e, items))
            .toList();
        break;

      case FilterTabs.Feels:
        final Map<String, List<Product>> allFeelings =
            Map.fromEntries(TabCategories.feeling.map((e) => MapEntry(e, [])));

        Map<String, List<Product>> headingItems =
            items.fold(allFeelings, (feelings, element) {
          if (!feelings.containsKey(element.effect)) {
            return feelings;
          }

          return feelings
            ..update(element.effect, (value) => value..add(element));
        });
        productList = headingItems;
        print("headingItems: $headingItems");

        return headingItems.entries
            .map((e) => ProductsInHeading(e.key, e.value..sort()))
            .toList()
              ..sort()
              ..where((e) => e.products.length != 0);
        break;

      // case FilterTabs.Rec:
      //   final Map<String, List<dynamic>> allRecommended = Map.fromEntries(
      //       TabCategories.recommendedList.map((e) => MapEntry(e, [])));

      //   Map<String, List<dynamic>> headingItems =
      //       items.fold(allRecommended, (recommendedProducts, element) {
      //     if (!recommendedProducts.containsKey(recCategories)) {
      //       return recommendedProducts;
      //     }

      //     return recommendedProducts
      //       ..update(
      //           recommendedProducts.toString(), (value) => value..add(element));
      //   });
      //   productList = headingItems;
      //   print("headingItems: $headingItems");

      //   return headingItems.entries
      //       .map((e) => ProductsInHeading(e.key, e.value..sort()))
      //       .toList()
      //         ..sort()
      //         ..where((e) => e.products.length != 0);
      //   break;

      case FilterTabs.Relief:
        // usage might be wrong, I'm not sure
        final Map<String, List<Product>> allRecovery =
            Map.fromEntries(TabCategories.usage.map((e) => MapEntry(e, [])));

        Map<String, List<Product>> headingItems =
            items.fold(allRecovery, (recovery, element) {
          if (!recovery.containsKey(element.usage)) {
            return recovery;
          }

          return recovery
            ..update(element.usage, (value) => value..add(element));
        });
        productList = headingItems;

        // print("headingItems: $headingItems");
        return headingItems.entries
            .map((e) => ProductsInHeading(e.key, e.value..sort()))
            .toList()
              ..sort();
        break;
      case FilterTabs.Categories:
        // usage might be wrong, I'm not sure
        final Map<String, List<Product>> allCategories = Map.fromEntries(
            TabCategories.prodCategory.map((e) => MapEntry(e, [])));

        Map<String, List<Product>> headingItems =
            items.fold(allCategories, (categories, element) {
          if (!categories.containsKey(element.productCategory)) {
            return categories;
          }

          return categories
            ..update(element.productCategory, (value) => value..add(element));
        });

        // print("headingItems: $headingItems");
        productList = headingItems;

        return headingItems.entries
            .map((e) => ProductsInHeading(e.key, e.value..sort()))
            .toList()
              ..sort()
              ..where((e) => e.products.length != 0);
        break;
    }
    throw UnsupportedError("Unsupported tab type");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 8,
                      backgroundColor: buddiesGreen,
                      expandedHeight: screenAwareSize(200, context),
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.all(4.0),
                          stretchModes: [StretchMode.blurBackground],
                          centerTitle: true,
                          collapseMode: CollapseMode.parallax,
                          title: Card(
                            elevation: 8,
                            color: Colors.white.withOpacity(.85),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                softWrap: true,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: dispensary.name,
                                      style: TextStyle(
                                        color: buddiesPurple,
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n${dispensary.address}',
                                      style: TextStyle(
                                        color: buddiesPurple,
                                        fontFamily: 'Poppins',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    // TextSpan(
                                    //   text: '\n${dispensary.phone}',
                                    //   style: TextStyle(
                                    //     color: buddiesPurple,
                                    //     fontFamily: 'Poppins',
                                    //     fontSize: 12.0,
                                    //   ),
                                    // ),
                                    // TextSpan(
                                    //   text:
                                    //       '\n${dispensary.openingHours[0].openingTime} - ${dispensary.openingHours[0].closingTime}',
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontFamily: 'Poppins',
                                    //     fontSize: 14.0,
                                    //   ),

                                    TextSpan(
                                      text: dispensary.deliveryOptions == 'Drop'
                                          ? '\n Next Day Shipping In The US'
                                          : '\n Home Delivery Available',
                                      style: TextStyle(
                                        color: buddiesGreen,
                                        fontFamily: 'Poppins',
                                        fontSize: 8.0,
                                      ),
                                    )
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          background: ImageGuard().imageGuard(
                              dispensary.dispensaryPhoto, BoxFit.fill)),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(TabBar(
                        isScrollable: false,
                        onTap: _changedDropDownItem,
                        indicatorColor: buddiesGreen,
                        labelColor: buddiesPurple,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        tabs: [
                          Tab(
                              icon: Icon(
                                FontAwesomeIcons.home,
                              ),
                              text: "All"),
                          Tab(
                              icon: Icon(FontAwesomeIcons.heart),
                              text: "Feels"),
                          // Tab(icon: Icon(FontAwesomeIcons.smile), text: "For Me"),
                          Tab(
                              icon: Icon(FontAwesomeIcons.handHoldingMedical),
                              text: "Relief"),
                          Tab(
                            icon: Icon(FontAwesomeIcons.clipboardList),
                            text: "Type",
                          ),
                        ],
                      )),
                      pinned: true,
                    ),
                    // SliverFillRemaining(
                    //   child: Container(
                    //     child: FutureBuilder(
                    //       future: _setProducts,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasError) {
                    //           return Text('Error: ${snapshot.error}');
                    //         } else if (snapshot.hasData == true) {
                    //           filteredProducts = snapshot.data;
                    //           currentProducts = snapshot.data;
                    //           var productsInHeadings =
                    //               _getProductsInHeadings(filteredProducts)
                    //                   .where((e) => e.products.length != 0)
                    //                   .toList();

                    //           return _bodyWidget(productsInHeadings, snapshot);
                    //         } else {
                    //           return Center(child: CircularProgressIndicator());
                    //         }
                    //       },
                    //     ),
                    //   ),
                    //   hasScrollBody: true,
                    // ),
                  ];
                },
                body: Container(
                  child: FutureBuilder(
                    future: _setProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData == true) {
                        filteredProducts = snapshot.data;
                        currentProducts = snapshot.data;
                        var productsInHeadings =
                            _getProductsInHeadings(filteredProducts)
                                .where((e) => e.products.length != 0)
                                .toList();

                        return _bodyWidget(productsInHeadings, snapshot);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              )),
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 20),
            visible: true,
            overlayColor: Colors.black,
            closeManually: false,
            curve: Curves.easeIn,
            overlayOpacity: .25,
            foregroundColor: Colors.white,
            elevation: 8,
            backgroundColor: buddiesGreen,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(
                  FontAwesomeIcons.check,
                  color: buddiesPurple,
                ),
                backgroundColor: Colors.white70,
                label: 'Sort By CBD',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 16,
                  color: buddiesPurple,
                ),
                onTap: () {
                  _sortProductsDropDown(3, filteredProducts);
                },
              ),
              SpeedDialChild(
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: buddiesPurple,
                ),
                backgroundColor: Colors.white70,
                label: 'Sort By THC',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 16,
                  color: buddiesPurple,
                ),
                onTap: () {
                  _sortProductsDropDown(2, filteredProducts);
                  print('Sort THC');
                },
              ),
              SpeedDialChild(
                child: Icon(
                  FontAwesomeIcons.user,
                  color: buddiesPurple,
                ),
                backgroundColor: Colors.white70,
                label: 'Sort By Price',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 16,
                  color: buddiesPurple,
                ),
                onTap: () {
                  _sortProductsDropDown(1, filteredProducts);
                  print('To Sean');
                },
              ),
              SpeedDialChild(
                child: Icon(
                  FontAwesomeIcons.check,
                  color: buddiesPurple,
                ),
                backgroundColor: Colors.white70,
                label: 'Search By Name',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 16,
                  color: buddiesPurple,
                ),
                onTap: () {
                  showSearch(context: context, delegate: DataSearch());
                },
              ),
            ]));
  }

  Widget _shippingIndicator() {
    return Container(child: _shippingIndicatorIcons[_shippingIconNum]);
  }

  void _getShippingIndicator(shipType) {
    setState(() {
      switch (shipType) {
        case 'Standard':
          _shippingIconNum = 0;
          break;
        case 'Drop':
          _shippingIconNum = 1;
          break;
        case 'Both':
          _shippingIconNum = 2;
          break;
        default:
      }
    });
  }

  Widget _bodyWidget(productsInHeadings, snapshot) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: _subSort(productsInHeadings)),
          ),
          Expanded(
            flex: 9,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: _currentCat != -1 ? 1 : productsInHeadings.length,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                currentProducts = snapshot.data;
                var headingTitle = _tabDetails[selectedTab.index];

                return CategoryAndProducts(
                    productsInHeading: _currentCat != -1
                        ? productsInHeadings[_currentCat]
                        : productsInHeadings[index],
                    showHeading: selectedTab != FilterTabs.All,
                    dispensary: dispensary,
                    starCount: starCount,
                    rating: rating,
                    filterNum: _currentCat,
                    currentIndex: headingTitle);
              },
            ),
          ),
        ]));
  }

  Widget _subSort(sortList) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _tabDetails[selectedTab.index],
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, color: buddiesPurple),
          ),
          Center(
            child: Container(
              height: screenAwareSize(75, context),
              color: Colors.transparent,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: sortList.length,
                  itemBuilder: (context, i) {
                    return _subSortTiles(sortList, i);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subSortTiles(sortList, i) {
    return Container(
      child: InkWell(
        onTap: () {
          setState(() {
            buttonPressed == false
                ? buttonPressed = true
                : buttonPressed = false;
            _resetBtn(buttonPressed, i);
          });
        },
        child: _chipWidget(sortList, i),
      ),
    );
  }

  Widget _chipWidget(sortList, i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        label: Text(
          sortList[i].heading,
          style: TextStyle(
              color: _currentCat != i ? buddiesPurple : _buttonColors[0],
              fontFamily: 'Roboto-Regular'),
        ),
        backgroundColor: _currentCat != i ? _buttonColors[0] : buddiesYellow,
      ),
    );
  }

  void _resetBtn(buttonPressed, i) {
    switch (buttonPressed) {
      case true:
        print('unselected');

        _currentCat = i;
        break;

      case false:
        print('selected');
        _currentCat = i;
        break;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class DataSearch extends SearchDelegate<String> {
  DataSearch();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(FontAwesomeIcons.backspace),
          onPressed: () {
            query = "";
          })
    ];
    //Navigate with data
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Build icon
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // return
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? currentProducts
        : currentProducts
            .where((p) => p.name.toLowerCase().startsWith(query) ? true : false)
            .toList();

    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
          leading: Icon(FontAwesomeIcons.cannabis),
          title: GestureDetector(
            onTap: () {
              fromPreRec = false;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectedProduct(
                          product: currentProducts[i],
                          dispensary: selectedDispensary)));
            },
            child: Text(suggestionList[i].name,
                style: TextStyle(
                  color: Colors.grey,
                )),
          )),
      itemCount: suggestionList.length,
    );
  }
}
