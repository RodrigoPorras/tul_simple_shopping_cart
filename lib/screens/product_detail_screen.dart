import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';
import 'package:tul_simple_shopping_cart/screens/product_shopping_cart_screen.dart';
import 'package:tul_simple_shopping_cart/widgets/widgets.dart';

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
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildCarousel(context),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$0.0',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(product.descripcion),
              ),
            ],
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
            Hero(
              tag: 'main_image${product.id}',
              child: PageView(
                children: [
                  ...product.imagesSrc
                      .map((src) => CacheImage(src: src))
                      .toList(),
                  if (product.imagesSrc.length == 0)
                    Image.asset('assets/images/logos/logo_tul.png'),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  void _openShoppingCartScreen(BuildContext context) async {
    ProductCart tentativeProduct =
        ProductCart(cartId: null, productId: product.id, quantity: 1);
    BlocProvider.of<ShoppingCartBloc>(context)
        .add(OnAddTentativeProductToCar(tentativeProduct));

    notifierBtnVisible.value = false;
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, animation, __) {
          return FadeTransition(
              opacity: animation,
              child: ProductShoppingCart(
                product: product,
              ));
        }));
    notifierBtnVisible.value = true;
  }
}
