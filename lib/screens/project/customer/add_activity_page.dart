import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';

import '../../../api/api_client.dart';
import '../../../api/api_controller.dart';
import '../../../components/common/background/default_background.dart';
import '../../../components/common/input/input.dart';
import '../../../components/common/show_picker.dart';
import '../../../components/common/text/text.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../utils/utils.dart';
import '../leads/lead/calendar_page.dart';

final dateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
final eventProvider = StateProvider<KeyModel?>((ref) => null);
final subEventProvider = StateProvider<KeyModel?>((ref) => null);

final eventListProvider = FutureProvider<List<KeyModel>>((ref) async {
  List list = await ApiController.eventList();

  final activities =
      list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();

  ref.read(eventProvider.notifier).state = activities.first;
  return activities;
});

final subEventListProvider = FutureProvider<List<KeyModel>>((ref) async {
  final event = ref.watch(eventProvider);

  if (event != null) {
    List list = await ApiController.subEventList(event.id);

    final subEvents =
        list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();

    ref.read(subEventProvider.notifier).state = subEvents.first;
    return subEvents;
  }

  return [];
});

class CreateActivityInput {
  final String projectId, type, refId, detail;

  CreateActivityInput({
    this.projectId = '',
    this.type = '',
    this.refId = '',
    this.detail = '',
  });
}

final createActivityProvider = FutureProvider.autoDispose
    .family<bool, CreateActivityInput>((ref, input) async {
  final dateTime = ref.read(dateTimeProvider);
  final event = ref.read(eventProvider);
  final subEvent = ref.read(subEventProvider);

  final date = IconFrameworkUtils.dateFormat.format(dateTime);
  final hour = DateFormat('HH:mm').format(dateTime);

  try {
    IconFrameworkUtils.startLoading();
    await ApiController.createActivity(
      input.projectId,
      input.type.characters.first,
      input.refId,
      event?.id,
      subEvent?.id,
      date,
      hour,
      input.detail,
    );
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('common.alert.save_complete'),
    );
    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.fail'),
      detail: e.toString(),
    );
  }

  return false;
});

@RoutePage()
class AddActivityPage extends ConsumerWidget {
  AddActivityPage({
    @PathParam.inherit('projectId') this.projectId = '',
    @PathParam.inherit('refId') this.referenceId = '',
    @PathParam.inherit('stage') this.stage = '',
    @PathParam.inherit('timestamp') this.timestamp = '',
    super.key,
  });

  final String projectId, referenceId, stage, timestamp;
  final TextEditingController description = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController hour = TextEditingController();

  initInput(ref) async {
    final DateTime dateTime = timestamp == ''
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(int.tryParse(timestamp) ?? 0);
    date.text = IconFrameworkUtils.dateFormat.format(dateTime);
    hour.text = DateFormat('HH:mm').format(dateTime);

    await IconFrameworkUtils.delayed();
    ref.read(dateTimeProvider.notifier).state = dateTime;
  }

  @override
  Widget build(context, ref) {
    initInput(ref);

    final eventList = ref.watch(eventListProvider);
    final subEventList = ref.watch(subEventListProvider);
    final event = ref.watch(eventProvider);
    final subEvent = ref.watch(subEventProvider);

    showDatePicker() async {
      final dateTime = ref.read(dateTimeProvider);

      final picked = await ShowPicker.selectDate(dateTime);

      date.text = IconFrameworkUtils.dateFormat.format(picked);
      ref.read(dateTimeProvider.notifier).state = picked;
    }

    showTimePicker() async {
      final dateTime = ref.read(dateTimeProvider);

      final picked = await ShowPicker.selectTime(dateTime);

      hour.text = DateFormat('HH:mm').format(picked);
      ref.read(dateTimeProvider.notifier).state = picked;
    }

    onSave() async {
      final success = await ref.read(createActivityProvider(CreateActivityInput(
        projectId: projectId,
        type: stage,
        refId: referenceId,
        detail: description.text,
      )).future);

      if (success) {
        context.router.pop();
        return ref.refresh(calendarProvider(referenceId));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.activity.create.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      Language.translate('screen.activity.create.sub_title'),
                      color: AppColor.red,
                      fontSize: FontSize.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InputListTile(
                  controller: date,
                  labelText: Language.translate('module.activity.date'),
                  trailing: const Icon(
                    Icons.calendar_month,
                    size: 30,
                  ),
                  onTap: showDatePicker,
                ),
                const SizedBox(height: 15),
                InputListTile(
                  controller: hour,
                  labelText: Language.translate('module.activity.time'),
                  onTap: showTimePicker,
                ),
                const SizedBox(height: 15),
                InputDropdown(
                  labelText: Language.translate('module.activity.event'),
                  value: event,
                  items: eventList.value ?? [],
                  isLoading: eventList.isLoading,
                  onChanged: (v) => ref.read(eventProvider.notifier).state = v,
                ),
                const SizedBox(height: 15),
                InputDropdown(
                  labelText: Language.translate('module.activity.sub_event'),
                  value: subEvent,
                  items: subEventList.value ?? [],
                  isLoading: subEventList.isLoading,
                  onChanged: (v) =>
                      ref.read(subEventProvider.notifier).state = v,
                  // hintText: '-',
                ),
                const SizedBox(height: 15),
                InputTextArea(
                  controller: description,
                  labelText: Language.translate('module.activity.description'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: IconFrameworkUtils.getWidth(0.45),
                  child: CustomButton(
                    onClick: onSave,
                    text: Language.translate('common.save'),
                    // disable: !checkValidate(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
