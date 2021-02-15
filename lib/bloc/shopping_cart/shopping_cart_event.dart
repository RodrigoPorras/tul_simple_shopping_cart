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

class OnDeleteProductFromCar extends ShoppingCartEvent {
  final ProductCart productCarToDelete;

  OnDeleteProductFromCar(this.productCarToDelete);
}

class OnFisnishShopping extends ShoppingCartEvent {}

class OnAdd1ToTentativeProductQuantity extends ShoppingCartEvent {}

class OnRemove1ToTentativeProductQuantity extends ShoppingCartEvent {}

class OnConnectCartsApi extends ShoppingCartEvent {}

class OnFetchPendingCart extends ShoppingCartEvent {}

class OnAdd1ToProductQuantity extends ShoppingCartEvent {
  final String productCartId;

  OnAdd1ToProductQuantity(this.productCartId);
}

class OnDelete1ToProductQuantity extends ShoppingCartEvent {
  final String productCartId;

  OnDelete1ToProductQuantity(this.productCartId);
}
