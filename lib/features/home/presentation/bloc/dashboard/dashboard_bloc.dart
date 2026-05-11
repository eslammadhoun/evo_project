import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/home/domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/domain/usecases/get_dashboard.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUsecase getDashboardUsecase;

  DashboardBloc({
    required this.getDashboardUsecase,
  }) : super(DashboardState.initial()) {
    on<GetDashboardEvent>(_onGetDashboard);
  }

  Future<void> _onGetDashboard(
    GetDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    await blocRequestHandler<DashboardEntity>(
      request: () => getDashboardUsecase(),
      onLoading: () => emit(
        state.copyWith(
          getDashboardState: GetDashboardStates.loading,
        ),
      ),
      onSuccess: (dashboardEntity) => emit(
        state.copyWith(
          getDashboardState: GetDashboardStates.success,
          dashboardEntity: dashboardEntity,
          topBanners: dashboardEntity.banners['top_banner'] ?? [],
          footerBanners: dashboardEntity.banners['footer_banner'] ?? [],
        ),
      ),
      onError: (errorMessage) => emit(
        state.copyWith(
          getDashboardState: GetDashboardStates.failure,
          getDashboardErrorMessage: errorMessage,
        ),
      ),
    );
  }
}
