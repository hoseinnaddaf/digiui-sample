import 'dart:convert';
import 'dart:ffi';

import 'package:digiui_sample/UI/ProductsPage.dart';
import 'package:digiui_sample/models/Banner.dart';
import 'package:digiui_sample/models/SpecialOfeerModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/Slide.dart';
import '../widgets/BottomNav.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   late Future<List<Slide>>  imageSlider_future ;
   late Future<List<SpecialOfferModel>>  specialOffers_future ;
   late Future<List<BannerData>>  banners_future ;

   PageController pageController = PageController() ;

  @override
  void initState() {

    super.initState();


    imageSlider_future =  getimageSliderData() ;
    specialOffers_future = getSpecialOffersData() ;
    banners_future = getBannersData() ;
  }

  Future<List<Slide>> getimageSliderData() async {

    List<Slide> imageSlides =[] ;

    var respone =  await Dio().get("http://mhnaddaf.ir/digiui_api/getPageViewData.php") ;
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

   Future<List<SpecialOfferModel>> getSpecialOffersData() async {

     List<SpecialOfferModel> specialOffers =[] ;

     var respone =  await Dio().get("http://mhnaddaf.ir/digiui_api/getSpecialOffersData.php") ;
    
     if(respone.statusCode== 200)
     {
       var datas =  json.decode(respone.data) ;
       datas.forEach( (var data)
       {
         specialOffers.add(SpecialOfferModel(
                                             data["product_name"],
                                             data["price"],
                                             data["off_price"],
                                             data["off_percent"],
                                             data["imageUrl"])) ;}) ;
     }

     return specialOffers ;
   }

   Future<List<BannerData>> getBannersData() async {

     List<BannerData> banners =[] ;

     var respone =  await Dio().get("http://mhnaddaf.ir/digiui_api/getBannersData.php") ;
     if(respone.statusCode== 200)
     {
       var datas =  json.decode(respone.data) ;
       datas.forEach( (var data)
       {
         banners.add(BannerData( data["imageUrl"])) ;
       }
       ) ;

     }

     print("datas size : "+ banners.length.toString()) ;
     return banners ;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(),
      appBar: AppBar(
        title: Text("فروشگاه اینترنتی"  ,style: TextStyle(fontFamily: "iranyekan"),),
        centerTitle: true,
        backgroundColor: Color(0xFFef4758),
        leading:  IconButton(
            onPressed: ()=>{},
            icon: Icon(Icons.shopping_cart_outlined)),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add ),
        backgroundColor: Colors.grey[600],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(),

      body:SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 200,
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
              ) ,
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 300,
                  color: Color(0xFFef4758),
                  child: FutureBuilder<List<SpecialOfferModel>>(
                      future: specialOffers_future,
                      builder: (context ,  snapshot){
                          if(snapshot.hasData)
                          {
                            List<SpecialOfferModel>? special_data =  snapshot.data ;

                            return ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:special_data!.length ,
                                itemBuilder: (context ,  position)
                                  {
                                    if(position ==0 )
                                      {
                                        return Container(
                                          height: 300,
                                          width: 150,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15 , left: 10 , right: 10),
                                                child: Image.asset("assets/images/specialoffer.png",  height: 230 ,),
                                              ),
                                              Padding( padding: const EdgeInsets.only(bottom: 5),
                                                child:Expanded(
                                                  child: OutlinedButton(
                                                      onPressed: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductsPage())) ;
                                                      },
                                                      style:OutlinedButton.styleFrom(
                                                        side: BorderSide(color: Colors.white) ,

                                                      ),
                                                      child: Text("مشاهده همه" , style: TextStyle(color: Colors.white , fontFamily: "iranyekan"),)

                                                  ),

                                                )
                                              )

                                            ],
                                          ),
                                        );
                                      }
                                    else
                                      {
                                        return SpecialOfferItem(special_data[position-1]) ;
                                      }
                                  }

                            ) ;
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
                      }
                  ),
                ),
              ) ,
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                    width: double.infinity,
                    child: FutureBuilder<List<BannerData>>(
                      future: banners_future,
                      builder: (context , snapshot)
                      {
                       if(snapshot.hasData)
                         {
                           List<BannerData>? model = snapshot.data ;

                           return Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(top: 5),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly
                                   ,children: [
                                    Container(
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                          child: Image.network(model![0].imageUrl, fit: BoxFit.fill, width: 190,)),
                                    ) ,
                                    Container(
                                      height: 150,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          child: Image.network(model![1].imageUrl, fit: BoxFit.fill, width: 190,)),
                                    )
                                  ],
                                 ),
                               ) ,
                               Padding(
                                 padding: const EdgeInsets.only(top: 5),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly
                                   ,children: [
                                   Container(
                                     height: 150,
                                     child: ClipRRect(
                                         borderRadius: BorderRadius.all(Radius.circular(15)),
                                         child: Image.network(model![2].imageUrl, fit: BoxFit.fill, width: 190,)),
                                   ) ,
                                   Container(
                                     height: 150,
                                     child: ClipRRect(
                                         borderRadius: BorderRadius.all(Radius.circular(15)),
                                         child: Image.network(model![3].imageUrl, fit: BoxFit.fill, width: 190,)),
                                   )
                                 ],
                                 ),
                               )
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
                ),
              )
            ],
          ),
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

   Container SpecialOfferItem(SpecialOfferModel specialOfferModel)
   {

     return Container(
        width: 200,
        height: 300,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: 200,
              child: Column(
                children: [
                  Padding(
                  padding:EdgeInsets.all(5),
                  child :Image.network(specialOfferModel.imageUrl  , height: 150 ,fit:BoxFit.fill,)
                  ) ,
                  Padding(padding: EdgeInsets.only(top: 5) ,
                  child: Text(specialOfferModel.product_name  ,style: TextStyle(fontFamily: "iranyekan")),
                  ) ,
                  Expanded(
                      child:Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10 , left: 10),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(padding: EdgeInsets.only(top: 3),
                                        child:Row(
                                          children: [
                                            Text("تومان" , style:TextStyle(fontSize: 12 , fontFamily: "iranyekan") ,),
                                            Text(specialOfferModel.off_price.toString() , style:TextStyle(fontSize: 16 ,fontFamily: "iranyekan") ,),
                                          ],
                                        )
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 2),
                                          child: Text(specialOfferModel.price.toString() , style:TextStyle(fontFamily: "iranyekan" , fontSize: 12 , decoration: TextDecoration.lineThrough) ,),
                                        )
                                      ],

                                  ),
                                ) ,
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10 , right: 10),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Color(0xFFef4758) ,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(specialOfferModel.off_percent.toString() + " % " , style: TextStyle(color: Colors.white),),
                                      ),

                                    ),
                                  ),
                                )
                              ],
                          ),
                      )
                  )

                ],
              ),
              
            ),
        ),
     ) ;
   }




}
