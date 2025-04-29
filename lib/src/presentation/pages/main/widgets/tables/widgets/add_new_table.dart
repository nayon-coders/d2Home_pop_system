import 'package:admin_desktop/generated/assets.dart';
import 'package:admin_desktop/src/models/data/table_model.dart';
import 'package:admin_desktop/src/presentation/components/components.dart';
import 'package:admin_desktop/src/presentation/pages/main/widgets/tables/widgets/table_form_field.dart';
import 'package:admin_desktop/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:admin_desktop/src/core/constants/constants.dart';
import 'package:admin_desktop/src/core/utils/utils.dart';
import 'package:admin_desktop/src/core/utils/validator_utils.dart';
import '../riverpod/tables_provider.dart';
import 'custom_drop_down_field.dart';

class AddNewTable extends ConsumerStatefulWidget {
  const AddNewTable({super.key});

  @override
  ConsumerState<AddNewTable> createState() => _AddNewTableState();
}

class _AddNewTableState extends ConsumerState<AddNewTable> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController count;
  late TextEditingController tax;

  @override
  void initState() {
    name = TextEditingController();
    count = TextEditingController();
    tax = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(tablesProvider.notifier)
          .setSection(index: ref.watch(tablesProvider).selectSection);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    count.dispose();
    tax.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(tablesProvider.notifier);
    final state = ref.watch(tablesProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: REdgeInsets.only(top: 5),
              child: Text(
                AppHelpers.getTranslation(TrKeys.addNewTable),
                style: GoogleFonts.inter(
                  color: AppStyle.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
            ),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: AppStyle.black, size: 24.r)),
          ],
        ),
        Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                24.r.verticalSpace,
                CustomDropDownField(
                  iconData:  FlutterRemix.building_line,
                  list: state.sectionListTitle,
                  onChanged: (value) =>
                      notifier.setSection(title: value.toString()),
                  value: state.sectionListTitle[state.selectSection],
                ),
                12.r.verticalSpace,
                TableFormField(
                  prefixSvg: Assets.svgDine,
                  validator: ValidatorUtils.validateEmpty,
                  hintText: TrKeys.tableName,
                  textEditingController: name,
                ),
                12.r.verticalSpace,
                TableFormField(
                  prefixSvg: Assets.svgAvatar,
                  inputType: TextInputType.number,
                  validator: ValidatorUtils.validateEmpty,
                  hintText: TrKeys.personCount,
                  textEditingController: count,
                ),
                12.r.verticalSpace,
                TableFormField(
                  prefixSvg: Assets.svgTax,
                  inputType: TextInputType.number,
                  validator: ValidatorUtils.validateEmpty,
                  hintText: TrKeys.tax,
                  textEditingController: tax,
                ),
                30.verticalSpace,
                LoginButton(
                    title: AppHelpers.getTranslation(TrKeys.create),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        notifier.addTable(
                          tableModel: TableModel(
                            name: name.text,
                            chairCount: int.tryParse(count.text) ?? 4,
                            tax: int.tryParse(tax.text) ?? 0,
                            shopSectionId: state.selectAddSection,
                          ),
                          context: context,
                        );
                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
