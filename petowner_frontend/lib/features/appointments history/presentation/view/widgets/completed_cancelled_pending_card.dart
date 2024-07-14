import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/networking/api_service.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/loading_button.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/appointments%20history/data/repo/appointment_histor_repo_impl.dart';
import 'package:petowner_frontend/features/appointments%20history/presentation/view%20model/appointments%20history/appointments_history_cubit.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';

class CompletedCancelledPendingTabCard extends StatelessWidget {
  const CompletedCancelledPendingTabCard({
    super.key,
    required this.appointmentStatus,
    required this.statusColor,
    required this.service,
    required this.providerName,
    required this.providerImage,
    this.boardingStartDate,
    this.boardingEndDate,
    required this.slotPrice,
    required this.status,
    this.providerId,
    this.groomingStartTime,
    this.groomingEndTime,
    this.rate,
    this.rateCount,
  });
  final int? providerId;
  final String appointmentStatus;
  final Color statusColor;
  final String service;
  final String providerName;
  final String providerImage;
  final DateTime? boardingStartDate;
  final DateTime? boardingEndDate;
  final DateTime? groomingStartTime;
  final DateTime? groomingEndTime;
  final num slotPrice;
  final String status;
  final num? rate;
  final dynamic rateCount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Material(
        elevation: 1.0,
        type: MaterialType.card,
        // borderRadius: BorderRadius.circular(10.0.r),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 14.0.h, left: 16.0.w, bottom: 14.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointmentStatus,
                          style: Styles.styles12RegularOpacityBlack.copyWith(
                            color: statusColor,
                          ),
                        ),
                        heightSizedBox(4),
                        if (service == 'Boarding')
                          Text(
                            '${DateFormat('EEEE, d MMM').format(boardingStartDate ?? DateTime.now())} | ${DateFormat('EEEE, d MMM').format(boardingEndDate ?? DateTime.now())}',
                            style: Styles.styles12RegularOpacityBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (service == 'Grooming')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, d MMM, yyyy')
                                    .format(groomingStartTime!),
                                style: Styles.styles12NormalHalfBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${DateFormat('hh:mma').format(groomingStartTime!.add(const Duration(hours: 3)).toUtc())} - '
                                '${DateFormat('hh:mma').format(groomingEndTime!.add(const Duration(hours: 3)).toUtc())} ',
                                style: Styles.styles12NormalHalfBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        if (service == 'Walking' || service == 'Sitting')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '-From Wednesday, 08 May 2023',
                                DateFormat('EEEE, d MMM, yyyy')
                                    .format(groomingStartTime!),
                                style: Styles.styles12NormalHalfBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                // '-From Wednesday, 08 May 2023',
                                '${DateFormat('hh:mma').format(groomingStartTime!.add(const Duration(hours: 3)))} - '
                                '${DateFormat('hh:mma').format(groomingEndTime!.add(const Duration(hours: 3)))} ',
                                style: Styles.styles12NormalHalfBlack,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                      ],
                    ),
                    status == 'completed'
                        ? Padding(
                            padding: EdgeInsets.only(right: 14.0.w),
                            child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => RatingReviewSheet(
                                        providerId: providerId ?? -1,
                                        providerName: providerName),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: kPrimaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0.r),
                                    // side: BorderSide(color: borderColor!),
                                  ),
                                ),
                                child: Text(
                                  'Rate',
                                  style: Styles.styles14NormalBlack
                                      .copyWith(color: Colors.white),
                                )),
                          )
                        : const SizedBox(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: const Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                // 'assets/images/1.png',
                                '${Constants.profilePictures}/$providerImage'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      widthSizedBox(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            providerName,
                            style: Styles.styles16BoldBlack.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          heightSizedBox(4),
                          Text(
                            'Pet $service',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                          heightSizedBox(2),
                          RatingRowWidget(
                            rating: rate ?? 0.0,
                            count: rateCount ?? '0.0',
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '$slotPrice/EGP',
                        style: Styles.styles12w600,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingReviewSheet extends StatefulWidget {
  final String providerName;
  final int providerId;
  const RatingReviewSheet(
      {super.key, required this.providerName, required this.providerId});

  @override
  RatingReviewSheetState createState() => RatingReviewSheetState();
}

class RatingReviewSheetState extends State<RatingReviewSheet> {
  double rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.providerName,
                style: Styles.styles16w600,
              ),
              heightSizedBox(16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rate) {
                  setState(() {
                    rating = rate;
                  });
                },
              ),
              heightSizedBox(16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                controller: _reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review here',
                ),
              ),
              heightSizedBox(16),
              BlocProvider(
                create: (context) => AppointmentsHistoryCubit(
                    AppointmentHistoryImpl(apiService: ApiService(dio: Dio()))),
                child: BlocConsumer<AppointmentsHistoryCubit,
                    AppointmentsHistoryState>(
                  listener: (context, state) {
                    var cubit =
                        BlocProvider.of<AppointmentsHistoryCubit>(context);
                    if (state is AddRatingSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Rating & Review Added Successfully. Thank you!'),
                        ),
                      );
                      Navigator.pop(context);
                      cubit.fetchCompletedReservations();
                    } else if (state is AddRatingFailure) {
                      // Handle failure state
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    var cubit =
                        BlocProvider.of<AppointmentsHistoryCubit>(context);
                    if (state is AddRatingLoading) {
                      return LoadingButton(
                        height: 50.h,
                      );
                    }
                    return PetYardTextButton(
                      style: Styles.styles16BoldWhite,
                      height: 50.h,
                      radius: 16.0.r,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          cubit.addRatingAndReview(
                              providerId: widget.providerId,
                              rate: rating,
                              review: _reviewController.text);
                        }
                      },
                      text: 'Submit',
                    );
                  },
                ),
              ),
              heightSizedBox(16),
            ],
          ),
        ),
      ),
    );
  }
}
