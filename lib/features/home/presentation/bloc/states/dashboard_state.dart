import 'package:equatable/equatable.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';

enum GetDashboardStates { initial, loading, failure, success }

class DashboardState extends Equatable {
  final GetDashboardStates getDashboardState;
  final String? getDashboardErrorMessage;
  final DashboardEntity? dashboardEntity;
  final List<BannerEntity>? topBanners;
  final List<BannerEntity>? footerBanners;

  const DashboardState({
    required this.getDashboardState,
    this.getDashboardErrorMessage,
    this.dashboardEntity,
    this.topBanners,
    this.footerBanners,
  });

  factory DashboardState.initial() {
    return DashboardState(
      getDashboardState: GetDashboardStates.initial,
      topBanners: [],
      footerBanners: [],
    );
  }

  DashboardState copyWith({
    GetDashboardStates? getDashboardState,
    String? getDashboardErrorMessage,
    DashboardEntity? dashboardEntity,
    List<BannerEntity>? topBanners,
    List<BannerEntity>? footerBanners,
  }) {
    return DashboardState(
      getDashboardState: getDashboardState ?? this.getDashboardState,
      getDashboardErrorMessage:
          getDashboardErrorMessage ?? this.getDashboardErrorMessage,
      dashboardEntity: dashboardEntity ?? this.dashboardEntity,
      topBanners: topBanners ?? this.topBanners,
      footerBanners: footerBanners ?? this.footerBanners,
    );
  }

  @override
  List<Object?> get props => [
    getDashboardState,
    getDashboardErrorMessage,
    dashboardEntity,
    topBanners,
    footerBanners,
  ];
}
