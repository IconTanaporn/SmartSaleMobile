import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../models/common/key_model.dart';
import '../common/loading/loading.dart';
import '../common/text/text.dart';

class FilterDrawer extends ConsumerWidget {
  final FutureProvider<List<KeyModel>> listProvider;
  final StateProvider<KeyModel> selectedProvider;
  final Function(KeyModel) onChanged;

  const FilterDrawer({
    super.key,
    required this.selectedProvider,
    required this.listProvider,
    required this.onChanged,
  });

  @override
  Widget build(context, ref) {
    final list = ref.watch(listProvider);
    final selected = ref.watch(selectedProvider);

    onRefresh() {
      return ref.refresh(listProvider);
    }

    onTap(key) {
      if (selected != key) {
        onChanged(key);
      }
    }

    return Drawer(
      child: SafeArea(
        left: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: CustomText(
                Language.translate('common.filter'),
                fontSize: FontSize.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: AppColor.grey5,
                thickness: 1,
                height: 1,
              ),
            ),
            list.when(
              error: (err, stack) => IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: Loading(),
              ),
              data: (data) {
                return Column(
                  children: data.map((key) {
                    bool isSelected = selected == key;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        selected: isSelected,
                        tileColor: AppColor.grey5,
                        selectedTileColor: AppColor.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? AppColor.red : AppColor.grey5,
                          ),
                        ),
                        visualDensity: const VisualDensity(vertical: -3),
                        title: CustomText(
                          key.name,
                          fontSize: FontSize.title,
                          color: isSelected ? AppColor.red : AppColor.black2,
                        ),
                        onTap: () => onTap(key),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
