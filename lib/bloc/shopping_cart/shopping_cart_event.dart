part of 'shopping_cart_bloc.dart';

@immutable
abstract class ShoppingCartEvent {}

class OnDeleteCart extends ShoppingCartEvent {}

class OnAddProductToCar extends ShoppingCartEvent {
  final ProductCart productCar;

  OnAddProductToCar({this.productCar});
}

class OnAddTentativeProductToCar extends ShoppingCartEvent {
  final ProductCart tentativeProductCar;

  OnAddTentativeProductToCar(this.tentativeProductCar);
}

class OnDeleteTentativeProductToCar extends ShoppingCartEvent {}

class OnDeleteProductToCar extends ShoppingCartEvent {}

class OnFisnishShopping extends ShoppingCartEvent {}

class OnAdd1ToTentativeProductQuantity extends ShoppingCartEvent {}

class OnRemove1ToTentativeProductQuantity extends ShoppingCartEvent {}

class OnConnectCartsApi extends ShoppingCartEvent {}

class OnFetchPendingCart extends ShoppingCartEvent {}
