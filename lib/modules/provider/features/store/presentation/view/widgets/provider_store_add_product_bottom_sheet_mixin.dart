import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/toaster_utils.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import '../../../data/model/provider_store_model.dart';
import '../../../data/model/provider_store_request_model.dart';
import 'provider_store_add_product_bottom_sheet.dart';

mixin ProviderStoreAddProductBottomSheetMixin
    on State<ProviderStoreAddProductBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameArController;
  late final TextEditingController nameEnController;
  late final TextEditingController descriptionArController;
  late final TextEditingController descriptionEnController;
  late final TextEditingController priceController;
  late final TextEditingController quantityController;

  final ValueNotifier<bool> isSavingNotifier = ValueNotifier<bool>(false);

  String? selectedCategoryId;
  String? imagePath;

  bool get isEditing => widget.product != null;

  List<ProviderStoreCategoryModel> get categories =>
      widget.store.categories.where((category) => category.id != 'all').toList();

  ProviderStoreCategoryModel get initialCategoryValue =>
      categories.firstWhere(
        (category) => category.id == selectedCategoryId,
        orElse: () => categories.isNotEmpty
            ? categories.first
            : const ProviderStoreCategoryModel(id: '', name: ''),
      );

  void initVariables() {
    nameArController = TextEditingController(text: widget.product?.name ?? '');
    nameEnController = TextEditingController(text: widget.product?.name ?? '');
    descriptionArController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    descriptionEnController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    priceController = TextEditingController(
      text: widget.product?.price.toStringAsFixed(0) ?? '0',
    );
    quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '1',
    );
    selectedCategoryId = widget.product?.categoryId;
    imagePath = widget.product?.imagePath;
  }

  void disposeVariables() {
    nameArController.dispose();
    nameEnController.dispose();
    descriptionArController.dispose();
    descriptionEnController.dispose();
    priceController.dispose();
    quantityController.dispose();
    isSavingNotifier.dispose();
  }

  Future<void> submit() async {
    log("form valid: ${formKey.currentState?.validate()}");
    log(  "nameAr: ${nameArController.text.trim()}");
    log(  "nameEn: ${nameEnController.text.trim()}");
    log(  "descriptionAr: ${descriptionArController.text.trim()}");
    log(  "descriptionEn: ${descriptionEnController.text.trim()}");
    log(  "price: ${priceController.text.trim()}");
    log(  "quantity: ${quantityController.text.trim()}"); 
    if ((formKey.currentState?.validate()??true )) return;

    final fallbackCategory = categories.isNotEmpty ? categories.first : null;
    final categoryId = selectedCategoryId ?? fallbackCategory?.id;

    if (categoryId == null) {
      Toaster.showToast(LocaleKeys.provider_store_fields_product_category.tr());
      return;
    }

    final image =
        (imagePath != null &&
            imagePath!.isNotEmpty &&
            !imagePath!.startsWith('http') &&
            !imagePath!.startsWith('assets/'))
        ? File(imagePath!)
        : null;

    isSavingNotifier.value = true;

    final request = ProviderStoreProductRequestModel(
      storeCategoryId: categoryId,
      price: priceController.text.trim(),
      quantity: quantityController.text.trim(),
      nameAr: nameArController.text.trim(),
      nameEn: nameEnController.text.trim(),
      descriptionAr: descriptionArController.text.trim(),
      descriptionEn: descriptionEnController.text.trim(),
      image: image,
    );

    final cubit = context.read<ProviderStoreCubit>();
    final failure = isEditing
        ? await cubit.updateProduct(widget.product!.id, request)
        : await cubit.addProduct(request);

    if (!mounted) return;

    isSavingNotifier.value = false;

    if (failure != null) {
      Toaster.showToast(failure.message);
      return;
    }

    widget.onSaved?.call();
    BaseRouter.pop();
    Toaster.showToast(
      isEditing
          ? LocaleKeys.provider_store_messages_saved.tr()
          : LocaleKeys.provider_store_messages_product_added.tr(),
      isError: false,
    );
  }
}
