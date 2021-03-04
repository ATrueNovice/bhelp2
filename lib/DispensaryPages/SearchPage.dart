import 'package:Buddies/Checkout/CartProvider.dart';
import 'package:Buddies/Constants/Static_string.dart';

import 'package:flutter/material.dart';

import 'DispensaryHomePage/DispensaryHome.dart';

class SearchPage extends StatefulWidget {
  final String selectedCategory;

  const SearchPage({Key key, this.selectedCategory}) : super(key: key);

  @override
  State createState() => _SearchPage(this.selectedCategory);
}

class _SearchPage extends State<SearchPage> {
  int index = 0;
  PageController _pageController;
  dynamic selectedCategory;

  List _categoryList = [];

  _SearchPage(this.selectedCategory);
  @override
  void initState() {
    _selectionCheck(selectedCategory);

    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  void _selectionCheck(selectedCategory) {
    setState(() {
      if (selectedCategory != null) {
        print('We want ' + selectedCategory);
        _selectedDisCateogory(selectedCategory);
      } else {
        print('Show All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [_optionsGrid(), _dispensaryList()];
    final fullHeight = MediaQuery.of(context).size.height;
    final fullWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 8,
        backgroundColor: buddiesGreen,
        title: buddiesLogo,
        actions: <Widget>[],
      ),
      body: Container(
        height: fullHeight,
        width: fullWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            Expanded(
              flex: 4,
              child: IndexedStack(
                index: index,
                children: [
                  PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return selectedCategory == null ? pages[i] : pages[1];
                    },
                    itemCount: pages.length,
                    controller: _pageController,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Divider(),
              ),
              Text(
                  selectedCategory == null
                      ? 'Search By Speciality'
                      : 'Speciality: $selectedCategory',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: buddiesPurple,
                      fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Divider(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionsGrid() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(18)),
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: dispensarySearchCategories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (contxt, indx) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDispensary = dispensarySearchCategories[indx];
                          _searchPageFilterTapped(selectedDispensary);
                        });
                      },
                      child: Container(
                        height: screenAwareSize(200, context),
                        child: Stack(children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.black.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(.65),
                                        BlendMode.darken),
                                    image: AssetImage(categoryPhotos[indx]),
                                    fit: BoxFit.fill)),
                          ),
                          Center(
                            child: Text(
                              dispensarySearchCategories[indx],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: screenAwareSize(20, context)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                );
              },
            )));
  }

  void _searchPageFilterTapped(category) {
    print(category);

    setState(() {
      _categoryList = currentDispensaries
          .where((e) => e.dispensaryCategory == category)
          .toList();
      selectedCategory = category;
    });

    print('Printed category');
    print(_categoryList.length);
    print(_categoryList.toList());
    _nextPage();
  }

  void _nextPage() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _goBack() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);

    setState(() {
      selectedCategory = null;
    });
  }

  void _selectedDisCateogory(category) {
    print('Printing category');

    setState(() {
      _categoryList = currentDispensaries
          .where((e) => e.dispensaryCategory == category)
          .toList();
      selectedCategory = category;
    });

    print('Printed category');
    print(_categoryList.length);
    print(_categoryList.toList());
  }

  Widget _noConnection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Results',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: screenAwareSize(16, context)),
          ),
          Image.asset(
            'assets/emptyCart.png',
            height: screenAwareSize(140, context),
            width: screenAwareSize(100, context),
          ),
          SizedBox(
            height: screenAwareSize(20, context),
          ),
          MaterialButton(
              color: buddiesGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 8,
              onPressed: () {
                _goBack();
              }),
        ],
      ),
    );
  }

  Widget _dispensaryList() {
    return _categoryList.length != 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: .6),
                itemCount: selectedCategory == null
                    ? currentDispensaries.length
                    : _categoryList.length,
                itemBuilder: (context, indx) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        selectedCategory == null
                            ? _locations(
                                '${currentDispensaries[indx].name}',
                                '${currentDispensaries[indx].address}',
                                '${currentDispensaries[indx].rating}',
                                '${currentDispensaries[indx].dispensaryPhoto}',
                                currentDispensaries[indx])
                            : _locations(
                                '${_categoryList[indx].name}',
                                '${_categoryList[indx].address}',
                                '${_categoryList[indx].rating}',
                                '${_categoryList[indx].dispensaryPhoto}',
                                _categoryList[indx]),
                        Divider(
                          endIndent: 100,
                          indent: 100,
                          height: 2,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                })

            // child: ListView.builder(
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     itemCount: currentDispensaries.length,
            //     itemBuilder: (
            //       context,
            //       int index,
            //     ) {
            )
        : _noConnection(context);
  }

  // Bottom Sheet location details
  Widget _locations(_name, _address, _rating, dispensaryImage, dispensaries) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            height: screenAwareSize(200, context),
            child: InkWell(
              onTap: () {
                CartProvider.of(context).setDispensary(dispensaries);
                _navigtorFunc(dispensaries, context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: screenAwareSize(100, context),
                    height: screenAwareSize(100, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        image: DecorationImage(
                            image: NetworkImage(dispensaryImage),
                            fit: BoxFit.fill)),
                  ),
                  Text(
                    _name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: screenAwareSize(14, context),
                        fontWeight: FontWeight.bold,
                        color: buddiesPurple),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigtorFunc(dispensary, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DispensaryHome(
                  dispensary: dispensary,
                )));
  }
}
