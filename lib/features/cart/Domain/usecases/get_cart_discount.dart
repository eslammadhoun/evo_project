import 'package:evo_project/features/cart/Data/datasources/cart_local_datasource.dart';

class GetCartDiscountState {
  final CartLocalDataSource cartLocalDataSource;
  const GetCartDiscountState({required this.cartLocalDataSource});

  Future<Map<String, dynamic>> call() async {
    return cartLocalDataSource.getDiscountState();
  }
}
