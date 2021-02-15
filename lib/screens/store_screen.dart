import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/products/products_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/colors/app_colors.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';
import 'package:tul_simple_shopping_cart/screens/product_detail_screen.dart';
import 'package:tul_simple_shopping_cart/screens/product_shopping_cart_screen.dart';
import 'package:tul_simple_shopping_cart/screens/shopping_cart_screen.dart';
import 'package:tul_simple_shopping_cart/widgets/widgets.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  // @override
  // void initState() {
  //   super.initState();
  //   _loadProducts();
  // }

  // _loadProducts() async {
  //   BlocProvider.of<ProductsBloc>(context).add(OnFetchProducts());
  // }

  void _onProductPressed(Product productSelected) async {
    notifierBottomBarVisible.value = false;

    await Navigator.of(context).push(PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation1,
            Animation<double> animation2) {
      return FadeTransition(
        opacity: animation1,
        child: ProductDetailScreen(
          product: productSelected,
        ),
      );
    }));

    notifierBottomBarVisible.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return SafeArea(
        child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logos/logo_tul.png',
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsApiConnected) {
                    BlocProvider.of<ProductsBloc>(context)
                        .add(OnFetchProducts());
                    return CircularProgressIndicatorTul();
                  } else if (state is ProductsLoading ||
                      state is ProductsApiConnecting) {
                    return CircularProgressIndicatorTul();
                  } else if (state is ProductsLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: state.products.length,
                        itemBuilder: (BuildContext context, int index) {
                          Product productItem = state.products[index];
                          return ProductCard(
                            product: productItem,
                            onTap: () {
                              _onProductPressed(productItem);
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('Estado desconocido'),
                    );
                  }
                },
              )
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: notifierBottomBarVisible,
          child: Container(
            color: Colors.white.withOpacity(0.85),
            child: Row(
              children: <Widget>[
                Expanded(child: Icon(Icons.home_outlined)),
                Expanded(
                    child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                  builder: (context, state) {
                    int totalProducts = 0;
                    if (state.currentProductsOnCart.length > 0) {
                      totalProducts = state.currentProductsOnCart.fold(
                          0, (totalAmount, p) => totalAmount + p.quantity);
                    }

                    return InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(state.currentProductsOnCart.length > 0
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined),
                          Text(totalProducts > 0 ? '$totalProducts' : '')
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingCart()),
                        );
                      },
                    );
                  },
                )),
              ],
            ),
          ),
          builder: (BuildContext context, value, Widget child) {
            return AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: 0,
                right: 0,
                bottom: value ? 0.0 : -kToolbarHeight,
                height: kToolbarHeight,
                child: child);
          },
        )
      ],
    ));
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({Key key, this.product, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 350;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: itemHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logos/logo_tul.png',
                  height: 100,
                ),
              ),
              Positioned.fill(
                child: Hero(
                  tag: 'background_product${product.id}',
                  child: Container(
                    height: itemHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.95)),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'main_image ${product.id}',
                        child: product.imagesSrc != null
                            ? Image.network(product.imagesSrc.first,
                                height: 150)
                            : Image.asset(
                                'assets/images/common/tools.png',
                                height: 150,
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        product.nombre,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$0',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          _openShoppingCartScreen(context);
                        },
                        child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                          builder: (context, state) {
                            int currentAdded = 0;

                            try {
                              currentAdded = state.currentProductsOnCart
                                  .firstWhere(
                                      (pc) => pc.productId == product.id)
                                  .quantity;
                            } catch (e) {}
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    currentAdded > 0
                                        ? Icons.shopping_cart
                                        : Icons.shopping_cart_outlined,
                                    size: 30),
                                Text(currentAdded > 0 ? '$currentAdded' : '',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openShoppingCartScreen(BuildContext context) async {
    ProductCart tentativeProduct =
        ProductCart(cartId: null, productId: product.id, quantity: 1);
    BlocProvider.of<ShoppingCartBloc>(context)
        .add(OnAddTentativeProductToCar(tentativeProduct));

    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, animation, __) {
          return FadeTransition(
              opacity: animation,
              child: ProductShoppingCart(
                product: product,
              ));
        }));
  }
}
