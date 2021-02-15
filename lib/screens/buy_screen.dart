import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:tul_simple_shopping_cart/colors/app_colors.dart';
import 'package:tul_simple_shopping_cart/screens/store_screen.dart';
import 'package:tul_simple_shopping_cart/widgets/widgets.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (BuildContext context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!BlocProvider.of<ShoppingCartBloc>(context).state.shopping) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StoreScreen()));
          }
        });
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title:
                  Text('¡Ultimo paso!', style: TextStyle(color: Colors.black)),
              leading: BackButton(
                color: Colors.black,
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '\$0.0',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Envio: '),
                                    Text('\$0.0'),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '\$0.0',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detalles ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                SizedBox(height: 10),
                                Text('Direccion'),
                                SizedBox(height: 10),
                                Text('Forma de pago'),
                                SizedBox(height: 10),
                                Text('Hora estimada de entrega'),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    color: base_color,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      width: double.infinity,
                      child: Text('Hacer pedido',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    onPressed: () {
                      BlocProvider.of<ShoppingCartBloc>(context)
                          .add(OnFisnishShopping());
                      waitingDialog(context, false);
                    },
                  ),
                )
              ],
            ));
      },
    );
  }

  Future<Widget> waitingDialog(BuildContext context, bool useRootNavigator) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator:
            useRootNavigator, //enviarlo al navegador raiz o al mas cercano
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicatorTul(),
          );
        });
  }
}
