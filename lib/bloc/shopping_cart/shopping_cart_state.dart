part of 'shopping_cart_bloc.dart';

class ShoppingCartState {
  final List<ProductCart> currentProductsOnCart;
  final ProductCart tentativeProduct;
  final bool apiconnected;

  ShoppingCartState(
      {this.apiconnected = false,
      this.tentativeProduct,
      this.currentProductsOnCart});

  ShoppingCartState copyWith(
          {List<ProductCart> currentProductsOnCart,
          ProductCart tentativeProduct,
          bool apiconnected}) =>
      ShoppingCartState(
          currentProductsOnCart:
              currentProductsOnCart ?? this.currentProductsOnCart,
          tentativeProduct: tentativeProduct ?? this.tentativeProduct,
          apiconnected: apiconnected ?? this.apiconnected);
}
