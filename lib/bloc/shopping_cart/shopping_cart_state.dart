part of 'shopping_cart_bloc.dart';

class ShoppingCartState {
  final List<ProductCart> currentProductsOnCart;
  final ProductCart tentativeProduct;
  final bool apiconnected;
  final String cartId;
  final bool shopping;

  ShoppingCartState(
      {this.apiconnected = false,
      this.tentativeProduct,
      this.currentProductsOnCart,
      this.cartId,
      this.shopping = true});

  ShoppingCartState copyWith(
          {List<ProductCart> currentProductsOnCart,
          ProductCart tentativeProduct,
          bool apiconnected,
          String cartId,
          bool shopping}) =>
      ShoppingCartState(
        currentProductsOnCart:
            currentProductsOnCart ?? this.currentProductsOnCart,
        tentativeProduct: tentativeProduct ?? this.tentativeProduct,
        apiconnected: apiconnected ?? this.apiconnected,
        cartId: cartId ?? this.cartId,
        shopping: shopping ?? this.shopping,
      );
}
