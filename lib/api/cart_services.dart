import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';

abstract class CartRepo {
  Future<void> connectAPI();

  Future<String> fetchPendingCartId();

  Future<List<ProductCart>> fetchPendingProductsCart(String cartId);

  Future<String> createNewCart();

  Future<ProductCart> createNewProductCart(ProductCart productCart);
}

class CartServicesFromLocal extends CartRepo {
  @override
  Future<void> connectAPI() async {}

  @override
  Future<String> createNewCart() {
    // TODO: implement createNewCart
    throw UnimplementedError();
  }

  @override
  Future<ProductCart> createNewProductCart(ProductCart productCart) {
    // TODO: implement createNewProductCart
    throw UnimplementedError();
  }

  @override
  Future<String> fetchPendingCartId() {
    // TODO: implement fetchPendingCart
    throw UnimplementedError();
  }

  @override
  Future<List<ProductCart>> fetchPendingProductsCart(String cartId) {
    // TODO: implement fetchPendingProductsCart
    throw UnimplementedError();
  }
}

class CartServicesFromFirebase extends CartRepo {
  CollectionReference carts;
  CollectionReference productCarts;

  @override
  Future<void> connectAPI() async {
    await Firebase.initializeApp();
    carts = FirebaseFirestore.instance.collection('carts');
    productCarts = FirebaseFirestore.instance.collection('product_carts');
  }

  @override
  Future<String> createNewCart() async {
    DocumentReference documentReferenceCartCreated =
        await carts.add({'status': 'pending'});

    return documentReferenceCartCreated.id;
  }

  @override
  Future<ProductCart> createNewProductCart(ProductCart productCart) async {
    DocumentReference documentReferenceProductCart;

    if (productCart.id != null) {
      await productCarts.doc(productCart.id).update(productCart.toMap());
      return productCart;
    } else {
      documentReferenceProductCart =
          await productCarts.add(productCart.toMap());
    }

    DocumentSnapshot documentSnapshotProductCartCreated =
        await documentReferenceProductCart.get();

    ProductCart productCartCreated = ProductCart.fromMap(
        documentSnapshotProductCartCreated.data()
          ..addAll({'id': documentReferenceProductCart.id}));

    return productCartCreated;
  }

  @override
  Future<String> fetchPendingCartId() async {
    QuerySnapshot querySnapshot =
        await carts.where('status', isEqualTo: 'pending').get();
    return querySnapshot.docs.length > 0 ? querySnapshot.docs.first.id : null;
  }

  @override
  Future<List<ProductCart>> fetchPendingProductsCart(String cartId) async {
    QuerySnapshot querySnapshot =
        await productCarts.where('cart_id', isEqualTo: cartId).get();

    List<ProductCart> productsCart = querySnapshot.docs
        .map((d) => ProductCart.fromMap(d.data()..addAll({'id': d.id})))
        .toList();

    return productsCart;
  }
}
