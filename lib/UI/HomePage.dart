import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/Slide.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   late Future<List<Slide>>  imageSlider_future ;

  @override
  void initState() {

    super.initState();


    imageSlider_future =  getimageSliderData() ;

  }

  Future<List<Slide>> getimageSliderData() async {

    List<Slide> imageSlides =[] ;

    var respone =  await Dio().get("https://zhoobinarad.ir/digiui_api/getPageViewData.php") ;

    if(respone.statusCode== 200)
    {
      var datas =  json.decode(respone.data) ;
        datas.forEach( (var data)
        {
          imageSlides.add(Slide(data["name"], data["imageUrl"])) ;
        }
      ) ;
    }
    return imageSlides ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(),
      appBar: AppBar(
        title: Text("فروشگاه اینترنتی"),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading:  IconButton(
            onPressed: ()=>{},
            icon: Icon(Icons.shopping_cart_outlined)),
      ),

      body: Padding(
        padding: EdgeInsets.all(5),
        child: Container(),
      ),
    );
  }


}
