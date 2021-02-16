import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';

abstract class ProductsRepo {
  Future<List<Product>> getProductList();

  Future<void> connectAPI();
}

class ProductServicesFromLocal extends ProductsRepo {
  @override
  Future<List<Product>> getProductList() async {
    Future.delayed(Duration(seconds: 1));

    var mockData = [
      Product(
          id: '1',
          nombre: 'Taladro',
          sku: 'AA1',
          descripcion:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product(
          id: '2',
          nombre: 'Martillo',
          sku: 'AA2',
          descripcion:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product(
          id: '3',
          nombre: 'Tuberia',
          sku: 'AA3',
          descripcion:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product(
          id: '4',
          nombre: 'Bombillo',
          sku: 'AA4',
          descripcion:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product(
          id: '5',
          nombre: 'Pintura',
          sku: 'AA5',
          descripcion:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s')
    ];

    return mockData;
  }

  @override
  Future<void> connectAPI() async {}
}

class ProductServicesFirebase extends ProductsRepo {
  CollectionReference products;

  @override
  Future<void> connectAPI() async {
    await Firebase.initializeApp();
    products = FirebaseFirestore.instance.collection('products');
  }

  @override
  Future<List<Product>> getProductList() async {
    var collection = await products.get();
    List<Product> fetchProducts = collection.docs
        .map((queryDocumentSnapshot) => Product.fromMap(
            queryDocumentSnapshot.data()
              ..addAll({'id': queryDocumentSnapshot.id})))
        .toList();

    return fetchProducts;
  }
}
