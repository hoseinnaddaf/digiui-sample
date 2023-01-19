import 'package:digiui_sample/widgets/BottomNav.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
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
            IconButton(onPressed: (){}, icon: Icon( Icons.share)) ,
          ],
        ),
        body: Container(),

    );
  }
}
