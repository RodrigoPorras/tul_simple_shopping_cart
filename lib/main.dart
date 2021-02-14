import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/api/cart_services.dart';

import 'package:tul_simple_shopping_cart/api/product_services.dart';
import 'package:tul_simple_shopping_cart/bloc/products/products_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/screens/store_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => ProductsBloc(
              productsRepo: ProductServicesFirebase(),
            )..add(OnConnectProductsApi()),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                ShoppingCartBloc(CartServicesFromFirebase())
                  ..add(OnConnectCartsApi()),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tul Simple Store',
          home: StoreScreen(),
        ));
  }
}
