import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/data/repo/home_repo_impl.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';
import 'package:petowner_frontend/features/home/presentation/view_model/Home_providers/home_providers_cubit.dart';

class ServiceProvidersScreen extends StatelessWidget {
  const ServiceProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18.sp,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Providers Screen',
          style: Styles.styles18SemiBoldBlack,
        ),
        centerTitle: true,
      ),
      body: const ServiceProvidersBody(),
    );
  }
}

class ServiceProvidersBody extends StatelessWidget {
  const ServiceProvidersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 18.sp,
                color: Colors.black.withOpacity(0.5),
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5))),
            ),
          ),
          heightSizedBox(20),
          BlocProvider(
            create: (context) => HomeProvidersCubit(HomeRepoImpl(
              apiService: ApiService(
                dio: Dio(),
              ),
            ))
              ..getAllProviders(),
            child: BlocBuilder<HomeProvidersCubit, HomeProvidersState>(
              builder: (context, state) {
                if (state is HomeProvidersSuccess) {
                  // print(state.providersList.length);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.providersList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ProviderListItem(
                          id: state.providersList[index].data![0].providerId ??
                              -1,
                          userName:
                              state.providersList[index].data![0].username ??
                                  'no name',
                        );
                      },
                    ),
                  );
                } else if (state is HomeProvidersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HomeProvidersFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                return const Center(
                  child: Text('OOPS'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderListItem extends StatelessWidget {
  const ProviderListItem({super.key, required this.userName, required this.id});
  final String userName;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.pushNamed(Routes.kProviderProfile, extra: id);
            },
            child: Material(
              color: Colors.white,
              elevation: 1.0,
              borderRadius: BorderRadius.circular(10.0.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0.r),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/1.png'),
                      ),
                    ),
                  ),
                  widthSizedBox(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Styles.styles16w600,
                      ),
                      heightSizedBox(4),
                      Text(
                        'Pet Boarder | Pet Walker',
                        style: Styles.styles12NormalHalfBlack,
                      ),
                      heightSizedBox(4),
                      const RatingRowWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}