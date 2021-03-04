import 'package:Buddies/widgets/helpers/Colors.dart';
import 'package:flutter/material.dart';


class LocationCalendar extends StatefulWidget{
  @override 
  State createState() => _LocationCalendar();
}

class _LocationCalendar extends State<LocationCalendar>{

  @override
  Widget build(BuildContext context) {
        final fullHeight = MediaQuery.of(context).size.height;
    final fullWeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        height: fullHeight,
        width: fullWeight,
        child: Column(
          children: <Widget>[
            
          ],
        ),
        
      ),
    );
  }
}