import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/api/services.dart';
import 'package:tul_simple_shopping_cart/bloc/products/products_bloc.dart';
import 'package:tul_simple_shopping_cart/screens/product_detail_screen.dart';
import 'package:tul_simple_shopping_cart/screens/store_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => ProductsBloc(
              productsRepo: ProductServicesFromLocal(),
            ),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tul Simple Store',
          initialRoute: 'store',
          routes: {
            'store': (BuildContext context) => StoreScreen(),
            'product_detail': (BuildContext context) => ProductDetailScreen(),
          },
        ));
  }
}
