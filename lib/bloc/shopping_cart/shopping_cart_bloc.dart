import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tul_simple_shopping_cart/api/cart_services.dart';
import 'package:tul_simple_shopping_cart/model/product_cart.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final CartRepo cartRepo;

  ShoppingCartBloc(this.cartRepo)
      : super(ShoppingCartState(currentProductsOnCart: []));

  @override
  Stream<ShoppingCartState> mapEventToState(ShoppingCartEvent event) async* {
    if (event is OnConnectCartsApi) {
      await cartRepo.connectAPI();
      yield state.copyWith(apiconnected: true);
      add(OnFetchPendingCart());
    } else if (event is OnFetchPendingCart) {
      String pendingCartId = await cartRepo.fetchPendingCartId();
      if (pendingCartId == null) {
        yield state;
      } else {
        List<ProductCart> productsCartPending =
            await cartRepo.fetchPendingProductsCart(pendingCartId);
        yield state.copyWith(
            currentProductsOnCart: productsCartPending, cartId: pendingCartId);
      }
    } else if (event is OnAddTentativeProductToCar) {
      ProductCart tentativeProduct;

      if (state.currentProductsOnCart
          .any((pc) => pc.productId == event.tentativeProductCar.productId)) {
        tentativeProduct = state.currentProductsOnCart.firstWhere(
            (pc) => pc.productId == event.tentativeProductCar.productId);
      } else {
        tentativeProduct = event.tentativeProductCar;
      }

      yield state.copyWith(tentativeProduct: tentativeProduct, shopping: true);
    } else if (event is OnAdd1ToTentativeProductQuantity) {
      ProductCart oldTentativeProduct = state.tentativeProduct;
      int newQuantity = oldTentativeProduct.quantity + 1;

      ProductCart editedTentativeProduct =
          oldTentativeProduct.copyWith(quantity: newQuantity);

      yield state.copyWith(tentativeProduct: editedTentativeProduct);
    } else if (event is OnRemove1ToTentativeProductQuantity) {
      ProductCart oldTentativeProduct = state.tentativeProduct;
      int newQuantity = (oldTentativeProduct.quantity - 1) >= 1
          ? oldTentativeProduct.quantity - 1
          : 1;

      ProductCart editedTentativeProduct =
          oldTentativeProduct.copyWith(quantity: newQuantity);

      yield state.copyWith(tentativeProduct: editedTentativeProduct);
    } else if (event is OnAddProductToCar) {
      if (state.cartId == null || state.cartId.isEmpty) {
        String idNewCart = await cartRepo.createNewCart();

        ProductCart productCart = event.productCar.copyWith(cartId: idNewCart);

        ProductCart newProductCart =
            await cartRepo.createNewProductCart(productCart);

        List<ProductCart> productCarts = [newProductCart];

        yield state.copyWith(
            currentProductsOnCart: productCarts, cartId: idNewCart);
      } else {
        ProductCart productCart;

        if (event.productCar.cartId == null) {
          productCart = event.productCar.copyWith(cartId: state.cartId);
        } else {
          productCart = event.productCar;
        }

        ProductCart newProductCart =
            await cartRepo.createNewProductCart(productCart);

        if (state.currentProductsOnCart
            .any((pc) => pc.productId == newProductCart.productId)) {
          List<ProductCart> productsCartCopy = state.currentProductsOnCart;

          productsCartCopy
              .removeWhere((pc) => pc.productId == newProductCart.productId);
        }
        List<ProductCart> productCarts = [
          ...state.currentProductsOnCart,
          newProductCart
        ];

        yield state.copyWith(currentProductsOnCart: productCarts);
      }
    } else if (event is OnDeleteProductFromCar) {
      await cartRepo.deleteProductFromCart(event.productCarToDelete);

      List<ProductCart> newProductCars = state.currentProductsOnCart;

      newProductCars.removeWhere((p) => p.id == event.productCarToDelete.id);

      yield state.copyWith(currentProductsOnCart: newProductCars);
    } else if (event is OnAdd1ToProductQuantity) {
      List<ProductCart> newProductCars = state.currentProductsOnCart;

      ProductCart productCartSelected =
          newProductCars.firstWhere((p) => p.id == event.productCartId);

      newProductCars.removeWhere((p) => p.id == event.productCartId);

      int newQuantity = productCartSelected.quantity + 1;

      ProductCart editedProductCart =
          productCartSelected.copyWith(quantity: newQuantity);

      newProductCars.add(editedProductCart);

      cartRepo.updateProductCart(editedProductCart);

      yield state.copyWith(currentProductsOnCart: newProductCars);
    } else if (event is OnDelete1ToProductQuantity) {
      List<ProductCart> newProductCars = state.currentProductsOnCart;

      ProductCart productCartSelected =
          newProductCars.firstWhere((p) => p.id == event.productCartId);

      newProductCars.removeWhere((p) => p.id == event.productCartId);

      int newQuantity = (productCartSelected.quantity - 1) <= 0
          ? 1
          : productCartSelected.quantity - 1;

      ProductCart editedProductCart =
          productCartSelected.copyWith(quantity: newQuantity);

      newProductCars.add(editedProductCart);

      cartRepo.updateProductCart(editedProductCart);

      yield state.copyWith(currentProductsOnCart: newProductCars);
    } else if (event is OnFisnishShopping) {
      await cartRepo.updateStatusCart(
        state.cartId,
        'completed',
      );

      yield state.copyWith(
          cartId: '', currentProductsOnCart: [], shopping: false);
    }
  }
}
