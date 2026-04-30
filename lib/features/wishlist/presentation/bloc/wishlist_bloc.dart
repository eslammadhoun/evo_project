import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Usecases/get_wishlist.dart';
import '../../Domain/Usecases/toggle_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final ToggleWishlist toggleWishlistUsecase;

  WishlistBloc({required this.getWishlist, required this.toggleWishlistUsecase})
    : super(WishlistState.initial()) {
    on<GetWishlistEvent>(_getWishlist);
    on<ToggleWishlistEvent>(_toggleWishlist);
  }

  Future<void> _getWishlist(
    GetWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    await blocRequestHandeler(
      request: () => getWishlist(),
      onLoading: () =>
          emit(state.copyWith(getWishlistState: GetWishlistState.loading)),
      onSuccess: (list) => emit(
        state.copyWith(
          getWishlistState: GetWishlistState.success,
          wishlist: list,
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          getWishlistState: GetWishlistState.failure,
          errorMessage: errorMessage,
        ),
      ),
    );
  }

  Future<void> _toggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final currentList = List<WishlistItem>.from(state.wishlist);

    final exists = currentList.any(
      (item) => item.productId == event.item.productId,
    );

    // 🔥 Optimistic Update (تحديث فوري)
    if (exists) {
      currentList.removeWhere((item) => item.productId == event.item.productId);
    } else {
      currentList.add(event.item);
    }

    emit(state.copyWith(wishlist: currentList));

    // 🔥 Sync مع DB
    try {
      await toggleWishlistUsecase(event.item, exists);
    } catch (e) {
      // rollback في حال فشل
      final rollbackList = List<WishlistItem>.from(state.wishlist);

      if (exists) {
        rollbackList.add(event.item);
      } else {
        rollbackList.removeWhere(
          (item) => item.productId == event.item.productId,
        );
      }

      emit(state.copyWith(wishlist: rollbackList));
    }
  }
}
