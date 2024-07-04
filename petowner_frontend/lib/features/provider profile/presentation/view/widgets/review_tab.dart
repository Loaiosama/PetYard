import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/provider%20profile/data/repos/provider_info_repo.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view%20model/provide_info_cubit/provider_info_cubit.dart';

class ReviewsTabColumn extends StatelessWidget {
  const ReviewsTabColumn({super.key, required this.providerId});
  final int providerId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderInfoCubit(
          ProviderInfoRepo(apiService: ApiService(dio: Dio())))
        ..fetchProviderRatings(providerID: providerId),
      child: BlocBuilder<ProviderInfoCubit, ProviderInfoState>(
        builder: (context, state) {
          if (state is ProviderRatingLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryGreen,
              ),
            );
          } else if (state is ProviderRatingFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is ProviderRatingSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSizedBox(12),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.providerRatings.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ReviewListItem(
                        image: state.providerRatings[index].ownerImage ?? '',
                        rate: state.providerRatings[index].rateValue ?? 0,
                        review: state.providerRatings[index].comment ?? '',
                        reviewrName:
                            state.providerRatings[index].ownerName ?? '',
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text('Something went wrong!'),
          );
        },
      ),
    );
  }
}

class ReviewListItem extends StatelessWidget {
  const ReviewListItem(
      {super.key,
      required this.rate,
      required this.reviewrName,
      required this.review,
      required this.image});
  // final int review = 4;
  final int rate;
  final String reviewrName;
  final String review;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      '${Constants.profilePictures}/$image',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthSizedBox(6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewrName,
                    style: Styles.styles14w600,
                  ),
                  heightSizedBox(4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rate ? Colors.yellow : Colors.grey,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  heightSizedBox(4),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60.0.w),
            child: Text(
              review,
              style: Styles.styles12NormalHalfBlack,
            ),
          ),
        ],
      ),
    );
  }
}
