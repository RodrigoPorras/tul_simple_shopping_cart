import 'package:tul_simple_shopping_cart/model/product.dart';

abstract class ProductsRepo {
  Future<List<Product>> getProductList();
}

class ProductServicesFromLocal extends ProductsRepo {
  @override
  Future<List<Product>> getProductList() async {
    Future.delayed(Duration(seconds: 1));

    var mockData = [
      Product('1', 'Taladro', 'AA1',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product('2', 'Martillo', 'AA2',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product('3', 'Tuberia', 'AA3',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product('4', 'Bombillo', 'AA4',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s'),
      Product('5', 'Pintura', 'AA5',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s')
    ];

    return mockData;
  }
}
