import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';
import 'package:evo_project/features/cart/Domain/usecases/add_product_to_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/delete_product_from_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/get_cart.dart';
import 'package:evo_project/features/cart/Domain/usecases/get_cart_discount.dart';
import 'package:evo_project/features/cart/Domain/usecases/set_cart_discount.dart';
import 'package:evo_project/features/cart/Domain/usecases/update_product_quantity.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUsecase getCartUsecase;
  final AddProductToCart addProductToCartUsecase;
  final DeleteProductFromCart deleteProductFromCartUsecase;
  final UpdateProductQuantity updateProductQuantityUsecase;
  final SetCartDiscount setCartDiscountUsecase;
  final GetCartDiscountState getCartDiscountStateUsecase;

  CartBloc({
    required this.getCartUsecase,
    required this.addProductToCartUsecase,
    required this.deleteProductFromCartUsecase,
    required this.updateProductQuantityUsecase,
    required this.setCartDiscountUsecase,
    required this.getCartDiscountStateUsecase,
  }) : super(CartState.initial()) {
    on<GetCartProductsEvent>(getCartProducts);
    on<AddProductToCartEvent>(addProductToCart);
    on<DeleteProductFromCartEvent>(deleteProductFromCart);
    on<UpdateProductQuantityEvent>(updateProductQuantity);
    on<ApplyPromoCodeEvent>(applyPromoCode);
    on<GetCartDiscountEvent>(getCartDiscount);
  }

  Map<String, dynamic> _calculateCartBill(List<CartItem> items) {
    double subTotal = 0;
    int totalItems = 0;

    for (final item in items) {
      subTotal += item.price * item.quantity;
      totalItems += item.quantity;
    }

    int deliveryCost = totalItems * 3;
    double total =
        (state.hasDiscount
            ? subTotal - (subTotal * state.discountPercentage)
            : subTotal) +
        deliveryCost;

    return {
      'sub_total': subTotal,
      'delivery_cost': deliveryCost,
      'total': total,
    };
  }

  Future<void> getCartProducts(
    GetCartProductsEvent event,
    Emitter<CartState> emit,
  ) async {
    await blocRequestHandeler<List<CartItem>>(
      request: () => getCartUsecase(),
      onLoading: () => emit(
        state.copyWith(getCartProductsState: GetCartProductsState.laoding),
      ),
      onSuccess: (cartProducts) {
        emit(
          state.copyWith(
            getCartProductsState: GetCartProductsState.success,
            cartProducts: cartProducts,
            cartBill: _calculateCartBill(cartProducts),
          ),
        );
      },
      onError: (errorMessage) => emit(
        state.copyWith(
          getCartProductsState: GetCartProductsState.failure,
          getCartErrorMessage: errorMessage,
        ),
      ),
    );
  }

  Future<void> addProductToCart(
    AddProductToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    await blocRequestHandeler<void>(
      request: () => addProductToCartUsecase(cartItem: event.cartItem),
      onLoading: () => emit(
        state.copyWith(addProductToCartState: AddProductToCartState.loading),
      ),
      onSuccess: (success) {
        final bool exists = state.cartProducts.any(
          (element) => element.productId == event.cartItem.productId,
        );
        final updatedList = exists
            ? state.cartProducts
            : [...state.cartProducts, event.cartItem];

        emit(
          state.copyWith(
            addProductToCartState: AddProductToCartState.success,
            cartProducts: updatedList,
            cartBill: _calculateCartBill(updatedList),
          ),
        );
      },
      onError: (errorMessage) => emit(
        state.copyWith(
          addProductToCartState: AddProductToCartState.failure,
          addProductToCartErrorMessage: errorMessage,
        ),
      ),
    );
  }

  Future<void> deleteProductFromCart(
    DeleteProductFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final List<CartItem> updatedList = state.cartProducts
        .where((eachProduct) => eachProduct.productId != event.productId)
        .toList();
    emit(state.copyWith(cartProducts: updatedList));

    await blocRequestHandeler(
      request: () => deleteProductFromCartUsecase(productId: event.productId),
      onLoading: () => emit(
        state.copyWith(
          deleteProductFromCartState: DeleteProductFromCartState.loading,
        ),
      ),
      onSuccess: (success) => emit(
        state.copyWith(
          deleteProductFromCartState: DeleteProductFromCartState.success,
          cartBill: _calculateCartBill(updatedList),
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          deleteProductFromCartState: DeleteProductFromCartState.failure,
          deleteProductFromCartErrorMessage: errorMessage,
        ),
      ),
    );
  }

  Future<void> updateProductQuantity(
    UpdateProductQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    await updateProductQuantityUsecase(
      increment: event.increment,
      productId: event.productId,
    );
    final List<CartItem> updatedList = state.cartProducts.map((eachProduct) {
      if (eachProduct.productId == event.productId) {
        final int newQuantity = (event.increment)
            ? eachProduct.quantity + 1
            : eachProduct.quantity - 1;
        return eachProduct.copyWith(quantity: newQuantity);
      }
      return eachProduct;
    }).toList();
    emit(
      state.copyWith(
        cartProducts: updatedList,
        cartBill: _calculateCartBill(updatedList),
      ),
    );
  }

  Future<void> applyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.promoCode == state.promoCode) {
      await setCartDiscountUsecase(cartDiscount: 0.10, userHaveDiscount: true);
      emit(state.copyWith(hasDiscount: true, discountPercentage: 0.10));
      emit(state.copyWith(cartBill: _calculateCartBill(state.cartProducts)));
    } else {
      emit(state.copyWith(hasDiscount: false));
    }
  }

  Future<void> getCartDiscount(
    GetCartDiscountEvent event,
    Emitter<CartState> emit,
  ) async {
    final Map<String, dynamic> result = await getCartDiscountStateUsecase();
    emit(
      state.copyWith(
        discountPercentage: result['cart_discount'],
        hasDiscount: result['have_discount'],
      ),
    );
  }
}
