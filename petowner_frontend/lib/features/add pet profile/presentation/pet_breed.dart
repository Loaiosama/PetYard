import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/data/models/pet_model.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/add%20pet%20profile/presentation/widgets/pet_type_bar.dart';

class PetBreedScreen extends StatelessWidget {
  final PetModel petModel;
  const PetBreedScreen({
    super.key,
    required this.petModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PetTypeBar(
              step: '2',
              subtitle: 'Breed',
            ),
            heightSizedBox(10),
            const LinearIndicator(
              percent: 0.4,
            ),
            heightSizedBox(20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search For Breed',
                        fillColor: Colors.grey.withOpacity(0.2),
                        hintStyle: Styles.styles12NormalHalfBlack
                            .copyWith(fontSize: 14.sp),
                        filled: true,
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 16.sp,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: BreedNameListView()),
            Padding(
              padding:
                  EdgeInsets.only(left: 20.0.w, right: 20.0.w, bottom: 20.0.h),
              child: PetYardTextButton(
                onPressed: () {
                  petModel.breed = "Scottish Fold";
                  context.pushNamed(Routes.kAddPetInfo, extra: petModel);
                },
                style: Styles.styles14NormalBlack.copyWith(color: Colors.white),
                height: 50.h,
                text: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreedNameListView extends StatefulWidget {
  const BreedNameListView({super.key});

  @override
  State<BreedNameListView> createState() => _BreedNameListViewState();
}

class _BreedNameListViewState extends State<BreedNameListView> {
  int selectedIndex = -1;
  late String breed;
  void handleSelection(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = -1;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return BreedNameItem(
          onTap: () {
            handleSelection(index);
          },
          isSelected: index == selectedIndex,
        );
      },
    );
  }
}

class BreedNameItem extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;

  const BreedNameItem({super.key, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(10),
          InkWell(
              onTap: onTap,
              splashColor: kPrimaryGreen.withOpacity(0.3),
              child: SizedBox(
                // height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scottish Fold',
                      style: Styles.styles14NormalBlack.copyWith(),
                    ),
                    isSelected ? const Icon(Icons.check) : Container(),
                  ],
                ),
              )),
          const Divider(),
        ],
      ),
    );
  }
}
