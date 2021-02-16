import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/products/products_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/colors/app_colors.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';
import 'package:tul_simple_shopping_cart/screens/buy_screen.dart';
import 'package:tul_simple_shopping_cart/widgets/widgets.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Carrito', style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              height: double.infinity,
              child: state.currentProductsOnCart.length == 0
                  ? _getEmptyCartWidget(context)
                  : _getBody(state, context),
            );
          },
        ),
      ),
    );
  }

  Widget _getEmptyCartWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Tu carrito está vacío', style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
            color: base_color,
            child: Text('Comprar ahora', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context))
      ],
    );
  }

  Widget _getBody(ShoppingCartState state, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.currentProductsOnCart.length,
            itemBuilder: (BuildContext context, int index) {
              if (state.currentProductsOnCart.length > 1)
                state.currentProductsOnCart
                    .sort((a, b) => a.id.compareTo(b.id));

              ProductCart productCart = state.currentProductsOnCart[index];
              return _getItemProductCart(productCart, context);
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text('Total: \$0.0',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                color: base_color,
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  child: Text('Continuar',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BuyScreen()));
                },
              )
            ],
          ),
        )
      ],
    );
  }

  _getItemProductCart(ProductCart productCart, BuildContext context) {
    ProductsBloc productsBloc = BlocProvider.of<ProductsBloc>(context);

    ShoppingCartBloc shoppingCartBloc =
        BlocProvider.of<ShoppingCartBloc>(context);

    Product product;

    //Verificando si el producto todavia existe
    if (productsBloc.products.any((p) => p.id == productCart.productId)) {
      product = productsBloc.products
          .firstWhere((p) => p.id == productCart.productId);
    } else {
      BlocProvider.of<ShoppingCartBloc>(context)
          .add(OnDeleteProductFromCar(productCart));
      return SizedBox.shrink();
    }

    return Dismissible(
      onDismissed: (direction) {
        shoppingCartBloc.add(OnDeleteProductFromCar(productCart));
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Eliminar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      key: Key(product.id),
      child: Container(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Center(
                    child: CacheImage(
                      src: product.imagesSrc.first,
                      height: 70,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(product.nombre),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  if (productCart.quantity - 1 <= 0) {
                                    bool resp = await showDialog(
                                        context: context,
                                        builder: (context) => DialogTul(
                                            context: context,
                                            title: 'Eliminar Producto',
                                            message:
                                                'Desea elimiar este producto del carrito?',
                                            ok: 'Si',
                                            cancel: 'No'));

                                    if (resp == null) {
                                      return;
                                    } else if (resp) {
                                      shoppingCartBloc.add(
                                          OnDeleteProductFromCar(productCart));
                                      return;
                                    } else {
                                      shoppingCartBloc.add(
                                          OnAdd1ToProductQuantity(
                                              productCart.id));
                                    }
                                  }
                                  shoppingCartBloc.add(
                                      OnDelete1ToProductQuantity(
                                          productCart.id));
                                }),
                            Text(
                              '${productCart.quantity}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  shoppingCartBloc.add(
                                      OnAdd1ToProductQuantity(productCart.id));
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '\$0.0',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
