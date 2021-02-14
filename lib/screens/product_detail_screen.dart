import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';
import 'package:tul_simple_shopping_cart/screens/product_shopping_cart.dart';
import 'package:tul_simple_shopping_cart/screens/store_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final ValueNotifier<bool> notifierBtnVisible = ValueNotifier(false);

  ProductDetailScreen({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifierBtnVisible.value = true;
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logos/logo_tul.png',
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildCarousel(context),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: notifierBtnVisible,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (context, state) {
                  int currentAdded = 0;

                  try {
                    currentAdded = state.currentProductsOnCart
                        .firstWhere((pc) => pc.productId == product.id)
                        .quantity;
                  } catch (e) {}

                  return FloatingActionButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                        ),
                        currentAdded == 0
                            ? SizedBox.shrink()
                            : Text(
                                '$currentAdded',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      ProductCart tentativeProduct = ProductCart(
                          cartId: null, productId: product.id, quantity: 1);
                      BlocProvider.of<ShoppingCartBloc>(context)
                          .add(OnAddTentativeProductToCar(tentativeProduct));

                      _openShoppingCartScreen(context);
                    },
                  );
                },
              ),
            ),
            builder: (BuildContext context, value, Widget child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: 0,
                right: 0,
                bottom: value ? 0.0 : -kToolbarHeight * 2,
                child: child,
              );
            },
          )
        ],
      ),
    );
  }

  _buildCarousel(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return [
      SizedBox(
        height: size.height * 0.5,
        child: Stack(
          children: [
            Hero(
              tag: 'background_product${product.id}',
              child: Container(
                color: Colors.white,
              ),
            ),
            PageView(
              children: [
                Hero(
                    tag: 'main_image${product.id}',
                    child: Image.asset('assets/images/common/tools.png')),
                Image.asset('assets/images/common/tools2.png'),
              ],
            )
          ],
        ),
      )
    ];
  }

  void _openShoppingCartScreen(BuildContext context) async {
    notifierBtnVisible.value = false;
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, animation, __) {
          return FadeTransition(
              opacity: animation, child: ProdcutShoppingCArt());
        }));
    notifierBtnVisible.value = true;
  }
}
