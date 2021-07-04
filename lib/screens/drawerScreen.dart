import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_boy_app/services/drawer_service.dart';
import 'package:flutter_delivery_boy_app/widgets/menu_widget.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
  static const String id = 'home-screen';
}

class _DrawerScreenState extends State<DrawerScreen> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  DrawerServices _service = DrawerServices();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderMenuContainer(
            appBarColor: Colors.white,
            key: _key,
            sliderMenuOpenSize: 200,
            title: Text(
              '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            trailing: Row(
              children: [
                IconButton(icon: Icon(CupertinoIcons.search), onPressed: () {}),
                IconButton(icon: Icon(CupertinoIcons.bell), onPressed: () {}),
              ],
            ),
            sliderMenu: MenuWidget(
              onItemClick: (title) {
                _key.currentState.closeDrawer();
                setState(() {
                  this.title = title;
                });
              },
            ),
            sliderMain: _service.drawerScreen(title, context)),
      ),
    );
  }
}
