import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';
import 'package:tul_simple_shopping_cart/utils/utils.dart';

abstract class CartRepo {
  Future<void> connectAPI();

  Future<String> fetchPendingCartId();

  Future<List<ProductCart>> fetchPendingProductsCart(String cartId);

  Future<String> createNewCart();

  Future<ProductCart> createNewProductCart(ProductCart productCart);

  Future<void> updateProductCart(ProductCart productCart);

  Future<void> deleteProductFromCart(ProductCart productCart);

  Future<void> updateStatusCart(String cartId, String status);
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

  @override
  Future<void> deleteProductFromCart(ProductCart productCart) {
    // TODO: implement deleteProductFromCart
    throw UnimplementedError();
  }

  @override
  Future<void> updateProductCart(ProductCart productCart) {
    // TODO: implement updateProductCart
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatusCart(String cartId, String status) {
    // TODO: implement updateStatusCart
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
    String uuid = await getUUID();

    DocumentReference documentReferenceCartCreated =
        await carts.add({'status': 'pending', 'device_id': uuid});

    return documentReferenceCartCreated.id;
  }

  @override
  Future<String> fetchPendingCartId() async {
    String uuid = await getUUID();
    QuerySnapshot querySnapshot = await carts
        .where('status', isEqualTo: 'pending')
        .where('device_id', isEqualTo: uuid)
        .get();
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

    await productCarts
        .doc(productCartCreated.id)
        .update(productCartCreated.toMap());

    return productCartCreated;
  }

  @override
  Future<void> deleteProductFromCart(ProductCart productCart) async {
    await productCarts.doc(productCart.id).delete();
  }

  @override
  Future<void> updateProductCart(ProductCart productCart) async {
    await productCarts.doc(productCart.id).update(productCart.toMap());
  }

  @override
  Future<void> updateStatusCart(String cartId, String status) async {
    await carts.doc(cartId).update({'status': status});
  }
}
