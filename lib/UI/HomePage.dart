import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/Slide.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   late Future<List<Slide>>  imageSlider_future ;

   PageController pageController = PageController() ;

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

      body:Container(
        child: Column(
          children: [
            Container(
              height: 250,

              child: FutureBuilder<List<Slide>>(
                  future: imageSlider_future,
                  builder: (context ,  snappshot){

                    if(snappshot.hasData)
                    {
                      List<Slide>? models =  snappshot.data ;

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                              controller: pageController,
                              allowImplicitScrolling: true,
                              itemCount: models?.length,
                              itemBuilder:(context , position)
                              {
                                return PageViewItems(models![position]) ;
                              }
                          ) ,
                          Padding(
                              padding:EdgeInsets.only(bottom: 5) ,
                              child:SmoothPageIndicator(
                                count: models!.length,
                                controller:pageController ,
                                effect: ExpandingDotsEffect(
                                    dotWidth: 10 ,
                                    dotHeight: 10 ,
                                    spacing: 3 ,
                                    dotColor: Colors.white ,
                                    activeDotColor: Colors.black
                                  ),
                                onDotClicked: (index)=>
                                    pageController.animateToPage(
                                        index, duration: Duration(milliseconds: 300), curve: Curves.bounceOut)
                              ),
                          ) ,

                        ],
                      );
                    }
                    else
                    {
                      return Center(
                        child: JumpingDotsProgressIndicator(
                        fontSize: 60,
                          dotSpacing: 5,
                        ),
                      ) ;
                    }
                  },
              ),
            )
          ],
        ),
      )
      ,
    );
  }

   Padding PageViewItems (Slide model)
   {
     return Padding(
         padding:EdgeInsets.only(top: 10 , left:5 , right: 5 ),
         child: Container(
            child:ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(model.imageUrl , fit: BoxFit.fill,)
            ),
         ),
      )  ;

   }




}
