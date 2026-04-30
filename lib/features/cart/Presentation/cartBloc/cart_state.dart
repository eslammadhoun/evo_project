import 'package:equatable/equatable.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

enum GetCartProductsState { initial, laoding, success, failure }

enum AddProductToCartState { initial, loading, success, failure }

enum DeleteProductFromCartState { initial, loading, success, failure }

enum UpdateProductQuantityState { initial, loading, success, failure }

class CartState extends Equatable {
  // =================== Get Cart Products States ===================
  final GetCartProductsState getCartProductsState;
  final List<CartItem> cartProducts;
  final String? getCartErrorMessage;
  /* 
    ===== Cart Bill Format =====
    {
      'sub_total': 0.0,
      'delivery_cost': cart products count * 3.0,
      'has_discount: true or false,
      'discount_percentage': 0.0,
      'total': has_discount ? (sub_total * discount_percentage) + delivery_cost : sub_total + delivery_cost
    }
   */
  final Map<String, dynamic>? cartBill;
  final String promoCode = 'xyz';
  final bool hasDiscount;
  final double discountPercentage;
  // ===============================================================

  // =================== Add Product To Cart States ===================
  final AddProductToCartState addProductToCartState;
  final String? addProductToCartErrorMessage;
  // ===============================================================

  // =================== Delete Product From Cart States ===================
  final DeleteProductFromCartState deleteProductFromCartState;
  final String? deleteProductFromCartErrorMessage;
  // ===============================================================

  const CartState({
    // =================== Get Cart Products States ===================
    required this.getCartProductsState,
    required this.cartProducts,
    this.getCartErrorMessage,
    this.cartBill,
    required this.hasDiscount,
    required this.discountPercentage,
    // =================== Add Product To Cart States ===================
    required this.addProductToCartState,
    this.addProductToCartErrorMessage,
    // =================== Delete Product From Cart States ===============
    required this.deleteProductFromCartState,
    this.deleteProductFromCartErrorMessage,
  });

  factory CartState.initial() {
    return CartState(
      // =================== Get Cart Products States ===================
      getCartProductsState: GetCartProductsState.initial,
      hasDiscount: false,
      discountPercentage: 0.0,
      cartProducts: [],
      // =================== Add Product To Cart States ===================
      addProductToCartState: AddProductToCartState.initial,
      // =================== Delete Product From Cart States ===============
      deleteProductFromCartState: DeleteProductFromCartState.initial,
    );
  }

  CartState copyWith({
    // =================== Get Cart Products States ===================
    GetCartProductsState? getCartProductsState,
    List<CartItem>? cartProducts,
    Map<String, dynamic>? cartBill,
    String? getCartErrorMessage,
    bool? hasDiscount,
    double? discountPercentage,
    // =================== Add Product To Cart States ===================
    AddProductToCartState? addProductToCartState,
    String? addProductToCartErrorMessage,
    // =================== Delete Product From Cart States ===============
    DeleteProductFromCartState? deleteProductFromCartState,
    String? deleteProductFromCartErrorMessage,
  }) {
    return CartState(
      getCartProductsState: getCartProductsState ?? this.getCartProductsState,
      cartProducts: cartProducts ?? this.cartProducts,
      getCartErrorMessage: getCartErrorMessage ?? this.getCartErrorMessage,
      cartBill: cartBill ?? this.cartBill,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      // =================== Add Product To Cart States ===================
      addProductToCartState:
          addProductToCartState ?? this.addProductToCartState,
      addProductToCartErrorMessage:
          addProductToCartErrorMessage ?? this.addProductToCartErrorMessage,
      // =================== Delete Product From Cart States ===============
      deleteProductFromCartState:
          deleteProductFromCartState ?? this.deleteProductFromCartState,
      deleteProductFromCartErrorMessage:
          deleteProductFromCartErrorMessage ??
          this.deleteProductFromCartErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    // =================== Get Cart Products States ===================
    getCartProductsState,
    cartProducts,
    getCartErrorMessage,
    cartBill,
    hasDiscount,
    discountPercentage,
    // =================== Add Product To Cart States ===================
    addProductToCartState,
    addProductToCartErrorMessage,
    // =================== Delete Product From Cart States ===============
    deleteProductFromCartState,
    deleteProductFromCartErrorMessage,
  ];
}
