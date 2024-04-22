import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/linear_percent_indecator.dart';
import 'package:petowner_frontend/features/pet%20profile/presentation/widgets/pet_type_bar.dart';

class PetBreedScreen extends StatelessWidget {
  const PetBreedScreen({super.key});

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
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search for Breed',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                      enabledBorder: customEnabledOutlinedBorder,
                      focusedBorder: customFocusedOutlinedBorder,
                      errorBorder: customErrorOutlinedBorder,
                      border: customEnabledOutlinedBorder,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: BreedNameListView()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PetYardTextButton(
                onPressed: () {
                  GoRouter.of(context).push(Routes.KPetInfo);

                },
                style: Styles.styles16BoldWhite,
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
