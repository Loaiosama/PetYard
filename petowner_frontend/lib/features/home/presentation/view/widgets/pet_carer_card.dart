import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/data/model/provider_sorted/provider_sorted.dart';

class PetCarerCardWidget extends StatelessWidget {
  final ProviderSorted provider;

  const PetCarerCardWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  '${Constants.profilePictures}/${provider.image}',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          widthSizedBox(18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.username ?? 'N/A',
                style: Styles.styles18BoldBlack,
              ),
              heightSizedBox(6),
              Row(
                children: [
                  Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black.withOpacity(0.4),
                    size: 18.sp,
                  ),
                  widthSizedBox(4),
                  Text(
                    provider.phone ?? 'N/A',
                    style: Styles.styles12RegularOpacityBlack,
                  ),
                ],
              ),
              heightSizedBox(6),
              RatingRowWidget(
                rating: provider.averageRating?.toDouble() ?? 0.0,
                count: provider.reviewCount,
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30.0.r),
            ),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ServiceListModal(provider: provider);
                  },
                );
              },
              icon: Tooltip(
                message: 'Book Service',
                child: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black.withOpacity(0.5),
                  size: 22.0.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingRowWidget extends StatelessWidget {
  const RatingRowWidget({
    super.key,
    this.rating,
    this.count,
  });

  final double? rating;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 16.sp,
        ),
        widthSizedBox(5),
        Text('${rating?.toStringAsFixed(2) ?? '4.8'} (${count ?? '4,279'})',
            style: Styles.styles12RegularOpacityBlack),
      ],
    );
  }
}

class ServiceListModal extends StatelessWidget {
  final ProviderSorted provider;

  const ServiceListModal({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Services Offered by ${provider.username}',
            style: Styles.styles18BoldBlack,
          ),
          ...?provider.services?.map((service) => ListTile(
                title: Text(service.type ?? 'N/A'),
                onTap: () {
                  GoRouter.of(context).push(Routes.kProviderProfile, extra: {
                    'id': provider.providerId,
                    'serviceName': service.type,
                  });
                },
              )),
        ],
      ),
    );
  }
}
