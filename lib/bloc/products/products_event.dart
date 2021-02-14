part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class OnFetchProducts extends ProductsEvent {}

class OnConnectProductsApi extends ProductsEvent {}
