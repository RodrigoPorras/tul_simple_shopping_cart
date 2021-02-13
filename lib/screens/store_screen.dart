import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/products/products_bloc.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';
import 'package:tul_simple_shopping_cart/screens/product_detail_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    BlocProvider.of<ProductsBloc>(context).add(OnFetchProducts());
  }

  void _onProductPressed(Product productSelected) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation1,
            Animation<double> animation2) {
      return FadeTransition(
        opacity: animation1,
        child: ProductDetailScreen(),
      );
    }));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logos/logo_tul.png',
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ));
                  } else if (state is ProductsLoaded) {
                    return Expanded(
                      child: ListView.builder(
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
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: kToolbarHeight,
            child: Container(
              color: Colors.white.withOpacity(0.85),
              child: Row(
                children: <Widget>[
                  Expanded(child: Icon(Icons.home_outlined)),
                  Expanded(child: Icon(Icons.shopping_cart_outlined)),
                ],
              ),
            ))
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
                child: Container(
                  height: itemHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.95)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/common/tools.png',
                      height: 200,
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
                  ],
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: Icon(
                    Icons.favorite_border,
                  )),
              Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(
                    Icons.shopping_cart,
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    '\$0',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
