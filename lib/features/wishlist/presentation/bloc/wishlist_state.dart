import 'package:equatable/equatable.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

enum GetWishlistState { initial, loading, failure, success }

class WishlistState extends Equatable {
  final GetWishlistState getWishlistState;
  final List<WishlistItem> wishlist;
  final String? errorMessage;

  const WishlistState({
    required this.getWishlistState,
    required this.wishlist,
    this.errorMessage,
  });

  factory WishlistState.initial() {
    return const WishlistState(
      getWishlistState: GetWishlistState.initial,
      wishlist: [],
    );
  }

  WishlistState copyWith({
    GetWishlistState? getWishlistState,
    List<WishlistItem>? wishlist,
    String? errorMessage,
  }) {
    return WishlistState(
      getWishlistState: getWishlistState ?? this.getWishlistState,
      wishlist: wishlist ?? this.wishlist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [getWishlistState, wishlist, errorMessage];
}
