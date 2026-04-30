import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final filePath = pickedFile.path;

    // context.read<UploadBloc>().add(UploadImageEvent(filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.menu,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.cart,
              text: 'My Profile',
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  _profileAcount(context: context),
                  const SizedBox(height: 30),
                  _profileWidget(
                    context: context,
                    title: 'My Orders',
                    iconName: 'orders_icon',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(2),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Payment method',
                    iconName: 'credit-card',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(0),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Delivery address',
                    iconName: 'map-pin',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(0),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Promocodes & gift cards',
                    iconName: 'gift',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(0),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Sign out',
                    iconName: 'log-out',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: StatefulBuilder(
                            builder: (context, setState) =>
                                _signOutPubup(context: context),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Widget
  Widget _profileAcount({required BuildContext context}) {
    return Padding(
      padding: Spacing.appPadding,
      child: Row(
        children: [
          Container(
            width: 60.w(context),
            height: 60.h(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.w(context)),
              color: Color(0xffECF3FA),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.w(context)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'lib/assets/images/image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  isEditing
                      ? Center(
                          child: InkWell(
                            onTap: () => _pickAndUploadImage(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffDBE9F5).withAlpha(150),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Edit',
                                style: context.textStyles.bodyMedium,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Callie Mosley',
                        style: context.textStyles.headlineSmall,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isEditing
                            ? AppLogger.info('Editng Done...')
                            : AppLogger.info('Editng Now...');
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          isEditing
                              ? 'lib/assets/icons/check.svg'
                              : 'lib/assets/icons/edit-pin.svg',
                          color: isEditing ? Color(0xff00824B) : null,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'calliemosley@mail.com',
                  style: context.textStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Item Widget
  Widget _profileWidget({
    required BuildContext context,
    required String title,
    required String iconName,
    required void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              left: BorderSide(color: Color(0xffDBE9F5), width: 1),
              top: BorderSide(color: Color(0xffDBE9F5), width: 1),
              right: BorderSide.none,
              bottom: BorderSide(color: Color(0xffDBE9F5), width: 1),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('lib/assets/icons/$iconName.svg'),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: context.textStyles.bodyLarge!.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colors.secondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign out pubup
  Widget _signOutPubup({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.h(context),
            height: 50.h(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: BoxBorder.all(color: context.colors.primary, width: 1.5),
            ),
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/icons/log-out.svg',
                width: 24.w(context),
                color: context.colors.primary,
              ),
            ),
          ),
          SizedBox(height: 14.h(context)),
          Text(
            'Are You Sure You Want To\nSign Out ?',
            style: TextStyles.headingsH4.copyWith(),
          ),
          SizedBox(height: 30.h(context)),
          Row(
            children: [
              Expanded(
                child: GlobalButton(
                  text: 'CANCEL',
                  onTap: () => Navigator.of(context).pop(),
                  height: 50.h(context),
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GlobalButton(
                      text: 'SURE',
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      height: 50.h(context),
                      isFilled: false,
                      child: state is AuthLoading
                          ? const AppLoadingIndicator(size: 30, strokeWidth: 4)
                          : null,
                    );
                  },
                  listener: (context, state) {
                    if (state is LogoutSuccess) {
                      context.go(RoutePaths.signin, extra: {'has_back': false});
                    }

                    if (state is AuthError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                      context.pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
