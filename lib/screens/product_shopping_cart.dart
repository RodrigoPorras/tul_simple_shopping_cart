import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tul_simple_shopping_cart/bloc/shopping_cart/shopping_cart_bloc.dart';

const _btnShoppingSizeWidth = 170.0;
const _btnShoppingSizeHeight = 60.0;
const _btnShoppingCircularSize = 60.0;
const _finalImgSize = 30;
const _imgSize = 120;

class ProdcutShoppingCArt extends StatefulWidget {
  const ProdcutShoppingCArt({Key key}) : super(key: key);

  @override
  _ProdcutShoppingCArtState createState() => _ProdcutShoppingCArtState();
}

class _ProdcutShoppingCArtState extends State<ProdcutShoppingCArt>
    with SingleTickerProviderStateMixin {
  @override
  AnimationController _controller;
  Animation _animationResize;
  Animation _animationMovementIn;
  Animation _animationMovementOut;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _animationResize = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.2,
        ),
      ),
    );
    _animationMovementIn = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.45,
          0.55,
        ),
      ),
    );

    _animationMovementOut = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.7,
          1,
          curve: Curves.elasticIn,
        ),
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ShoppingCartBloc shoppingCartBloc =
        BlocProvider.of<ShoppingCartBloc>(context);

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          final finalBtnSizeWith =
              (_btnShoppingSizeWidth * _animationResize.value)
                  .clamp(_btnShoppingCircularSize, _btnShoppingSizeWidth);
          final panelShoppingSizeWidth = (size.width * _animationResize.value)
              .clamp(_btnShoppingCircularSize, size.width);
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                  child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black87,
                ),
              )),
              Positioned.fill(
                  child: Stack(
                children: <Widget>[
                  if (_animationMovementIn.value != 1)
                    Positioned(
                      top: size.height * 0.4 +
                          (_animationMovementIn.value * size.height * 0.5),
                      left: size.width / 2 - panelShoppingSizeWidth / 2,
                      width: panelShoppingSizeWidth,
                      child: _getShoppingPanel(context),
                    ),
                  if (_animationResize.value == 1)
                    Positioned(
                      top: size.height * 0.81,
                      left: (size.width / 2 - finalBtnSizeWith / 2),
                      child: TweenAnimationBuilder(
                        builder: (BuildContext context, value, Widget child) {
                          return Transform.translate(
                            offset: Offset(0.0, value * size.height * 0.6),
                            child: child,
                          );
                        },
                        duration: Duration(milliseconds: 300),
                        tween: Tween(begin: 1.0, end: 0.0),
                        curve: Curves.easeIn,
                        child: Container(
                          height: _btnShoppingSizeHeight,
                          width: finalBtnSizeWith,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child:
                              BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        shoppingCartBloc.add(
                                            OnRemove1ToTentativeProductQuantity());
                                      }),
                                  Text(
                                    '${state.tentativeProduct.quantity}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        shoppingCartBloc.add(
                                            OnAdd1ToTentativeProductQuantity());
                                      }),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top:
                        size.height * 0.9 + (_animationMovementOut.value) * 100,
                    left: (size.width / 2 - finalBtnSizeWith / 2),
                    child: TweenAnimationBuilder(
                      builder: (BuildContext context, value, Widget child) {
                        return Transform.translate(
                          offset: Offset(0.0, value * size.height * 0.6),
                          child: child,
                        );
                      },
                      duration: Duration(milliseconds: 300),
                      tween: Tween(begin: 1.0, end: 0.0),
                      curve: Curves.easeIn,
                      child: InkWell(
                        onTap: () {
                          shoppingCartBloc.add(OnAddProductToCar(
                              productCar:
                                  shoppingCartBloc.state.tentativeProduct));
                          _controller.forward();
                        },
                        child: Container(
                          width: finalBtnSizeWith,
                          height:
                              (_btnShoppingSizeHeight * _animationResize.value)
                                  .clamp(_btnShoppingCircularSize,
                                      _btnShoppingSizeHeight),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                ),
                              ),
                              if (_animationResize.value == 1) ...[
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Agregar al carrito',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ]),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))
            ],
          );
        },
      ),
    );
  }

  _getShoppingPanel(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, value, Widget child) {
        return Transform.translate(
          offset: Offset(0.0, value * size.height * 0.6),
          child: child,
        );
      },
      duration: Duration(milliseconds: 300),
      tween: Tween(begin: 1.0, end: 0.0),
      curve: Curves.easeIn,
      child: Container(
        height: (size.height * 0.6 * _animationResize.value).clamp(
          _btnShoppingCircularSize,
          size.height * 0.6,
        ),
        width: (size.width * _animationResize.value)
            .clamp(_btnShoppingCircularSize, size.width),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: _animationResize.value == 1
                  ? Radius.circular(0)
                  : Radius.circular(30),
              bottomRight: _animationResize.value == 1
                  ? Radius.circular(0)
                  : Radius.circular(30),
            )),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
