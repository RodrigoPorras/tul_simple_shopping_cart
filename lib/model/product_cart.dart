import 'package:tul_simple_shopping_cart/model/product.dart';

class ProductCart {
  final int quantity;
  final String productId;
  final String cartId;
  final String id;

  ProductCart({this.id, this.quantity = 0, this.productId, this.cartId});

  factory ProductCart.fromMap(Map<String, dynamic> map) => ProductCart(
        id: map["id"],
        productId: map["product_id"],
        cartId: map["cart_id"],
        quantity: map["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "cart_id": cartId,
        "quantity": quantity,
        "id": id
      };

  ProductCart copyWith({
    product,
    quantity,
    productId,
    cartId,
    id,
  }) =>
      ProductCart(
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        cartId: cartId ?? this.cartId,
        id: id ?? this.id,
      );
}
