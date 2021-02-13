import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tul_simple_shopping_cart/api/services.dart';
import 'package:tul_simple_shopping_cart/model/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepo productsRepo;
  List<Product> products;

  ProductsBloc({this.productsRepo}) : super(ProductsInitial());

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is OnFetchProducts) {
      yield ProductsLoading();
      products = await productsRepo.getProductList();
      yield ProductsLoaded(products: products);
    }
  }
}
