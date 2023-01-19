import 'package:digiui_sample/models/SpecialOfeerModel.dart';
import 'package:flutter/material.dart';


class SingleProduct extends StatelessWidget {

  SpecialOfferModel specialOfferModel;


  SingleProduct(this.specialOfferModel) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFef4758),
        title: Text(specialOfferModel.product_name , style: TextStyle(fontFamily: "iranyekan"),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon( Icons.share)) ,
        ],
      ),
        body: Container(
          child: Center(
            child: (
                Column(
                  children: [
                    Image.network(specialOfferModel.imageUrl , fit: BoxFit.fill, width: 300,),
                    Padding(padding: EdgeInsets.all( 10),
                        child:Row(
                          children: [
                            Text(specialOfferModel.price.toString() , style:TextStyle(fontFamily: "iranyekan" , fontSize: 15 , decoration: TextDecoration.lineThrough) ,),
                            Text("تومان" , style:TextStyle(fontSize: 15 , fontFamily: "iranyekan") ,),
                            Text(specialOfferModel.off_price.toString() , style:TextStyle(fontSize: 20 ,fontFamily: "iranyekan") ,),
                          ],
                        )
                    ),
                    Expanded(
                      child:Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20 ,
                          child: ElevatedButton(
                            onPressed: (){},
                            child: Text("افزودن به سبد خرید" , style: TextStyle(color: Colors.white , fontFamily: "iranyekan"),),
                            style: ElevatedButton.styleFrom(primary:Color(0xFFef4758) ),
                          ),
                        ),
                      ),
                    ) ,

                  ],
            )),
          ),
        ),
    );
  }
}
