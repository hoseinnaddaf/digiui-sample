import 'dart:convert';

import 'package:digiui_sample/UI/SingleProduct.dart';
import 'package:digiui_sample/widgets/BottomNav.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../models/SpecialOfeerModel.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  late Future<List<SpecialOfferModel>>  specialOffers_future ;


  @override
  void initState() {

    super.initState();
    specialOffers_future = getSpecialOffersData() ;
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




  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add ),
        backgroundColor: Colors.grey[600],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(),
      appBar: AppBar(
        backgroundColor: Color(0xFFef4758),
        title: Text("محصولات" , style: TextStyle(fontFamily: "iranyekan"),),
        centerTitle: true,
        actions: [
          //  IconButton(onPressed: (){}, icon: Icon( Icons.share)) ,
        ],
      ),
      body: Container(
        child: FutureBuilder<List<SpecialOfferModel>>(
            future: specialOffers_future,
            builder: (context , snapshot){
              if(snapshot.hasData)
                {
                  List<SpecialOfferModel>? model = snapshot.data ;

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                        crossAxisCount: 2 ,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: (0.9) ,
                        children: List.generate(model!.length, (index) => generateItem(model[index])),
                    ),
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
            },
        ),
      ),

    );
  }

  InkWell generateItem(SpecialOfferModel model)
  {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleProduct(model))) ;
      }
      ,child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 5,
        child: Center(
          child: Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 75,
                    height: 75,
                    child: Image.network(model.imageUrl),
                  ),
                ) ,
                Padding(
                    padding: EdgeInsets.only(top: 2) ,
                    child: Text(model.product_name ,  style: TextStyle(fontFamily: "iranyekan"),)
                ) ,
                Expanded(
                    child:Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5 , left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 3),
                                    child:Row(
                                      children: [
                                        Text("تومان" , style:TextStyle(fontSize: 12 , fontFamily: "iranyekan") ,),
                                        Text(model.off_price.toString() , style:TextStyle(fontSize: 16 ,fontFamily: "iranyekan") ,),
                                      ],
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(top: 2),
                                  child: Text(model.price.toString() , style:TextStyle(fontFamily: "iranyekan" , fontSize: 12 , decoration: TextDecoration.lineThrough) ,),
                                )
                              ],

                            ),
                          ) ,
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5 , right: 10),
                              child: Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xFFef4758) ,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(model.off_percent.toString() + " % " , style: TextStyle(color: Colors.white),),
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
          )
        ),
      ),
    ) ;
  }

}
