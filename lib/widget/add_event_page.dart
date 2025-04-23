
import 'package:couplink_app/component/FontTheme.dart';
import 'package:couplink_app/component/custom_container.dart';
import 'package:couplink_app/component/date_picker.dart';
import 'package:couplink_app/component/dropdown.dart';
import 'package:couplink_app/component/snack_bar.dart';
import 'package:couplink_app/component/svg_icon.dart';
import 'package:couplink_app/component/toogle_button.dart';
import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/entity/event_entity.dart';
import 'package:couplink_app/service/SyncService.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddEventPage extends StatefulWidget {
  final AddEventType type;
  final Function(Event event)? add;
  final Function(Event event)? edit;
  const AddEventPage({super.key, required this.type, this.add, this.edit});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  // 제목
  final TextEditingController _titleController = TextEditingController();
  // 대상
  EventTarget _eventTarget = EventTarget.ME;
  // 시간
  final DateTimePick _dateTimePick = DateTimePick();
  // 공유 범위
  EventVisibility _eventPrivate = EventVisibility.SHARED;
  // 색상
  EventColor _eventColor = EventColor.AZURE;
  // 일정 추가 버튼 disabled
  bool _disabled = true;

  // 메모
  final TextEditingController _memoController = TextEditingController();


  _titleOnChanged(String title) {
    setState(() {
      _disabled = title.isEmpty;
    });
  }
  _selectEventTarget(EventTarget target) {
    setState(() {
      _eventTarget = target;
    });
  }
  _selectEventPrivate(EventVisibility private) {
    setState(() {
      _eventPrivate = private;
    });
  }
  _selectEventColor(EventColor color) {
    setState(() {
      _eventColor = color;
    });
  }

  _add() async {
    Event event = Event(
      eventId: const Uuid().v4(),
      userId: 1,
      title: _titleController.text,
      target: _eventTarget,
      startDate: _dateTimePick.startDateToFinal(),
      endDate: _dateTimePick.endDateToFinal(),
      visibility: _eventPrivate,
      color: _eventColor.colorValue,
      description: _memoController.text
    );
    widget.add!(event);
    await SyncService().createEvent(event);
  }

  @override
  void initState() {
    _dateTimePick.init();
    super.initState();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final safeArea = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type == AddEventType.NEW ? '새 일정 추가' : '일정 수정'),
          automaticallyImplyLeading: false,
          actions: [
            // 오른쪽에 X 버튼 추가
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    CustomContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextField(
                        controller: _titleController,
                        onChanged: _titleOnChanged,
                        hintText: '제목을 입력해주세요',
                        maxLength: 20,
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      children: EventTarget.values.map((target) =>
                        GestureDetector(
                          onTap: () {
                            _selectEventTarget(target);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _eventTarget != target
                                ? const Color(0xFFDFDFDF)
                                : target.color,
                            ),
                            child: Text(target.text,
                              style: FontTheme.of(context,
                                color: Colors.white,
                                size: FontSize.bodyMedium,
                                weight: FontWeight.w500
                              ),
                            ),
                          ),
                        )
                      ).toList(),
                    )
                  ],
                ),
                const SizedBox(height: 26,),
                DateRangeSelector(
                  dateTimePick: _dateTimePick
                ),
                // const SizedBox(height: 26,),
                // CustomContainer(
                //   child: EventFunction(
                //     title: '반복',
                //     child: Container(),
                //   ),
                // ),
                const SizedBox(height: 26,),
                CustomContainer(
                  child: EventFunction(
                    title: '공유',
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Dropdown.show(context,
                              items: EventVisibility.values,
                              initItem: _eventPrivate,
                              onSelected: _selectEventPrivate,
                              builder: (item) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.title,
                                      style: FontTheme.of(context,
                                        fontColor: FontColor.f1,
                                        weight: FontWeight.w400,
                                        size: FontSize.displaySmall,
                                      ),
                                    ),

                                    if (_eventPrivate == item)
                                      Icon(Icons.check_rounded,
                                        color: FontColor.f3.get(context),
                                      )
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(_eventPrivate.title,
                            style: FontTheme.of(context,
                              size: FontSize.bodyLarge,
                              fontColor: FontColor.f1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: FontColor.f3.get(context),)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26,),
                CustomContainer(
                  child: EventFunction(
                    title: '색상',
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Dropdown.show(context,
                              items: EventColor.values,
                              initItem: _eventColor,
                              onSelected: _selectEventColor,
                              builder: (item) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 20, height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: item.color,
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Text(item.title,
                                          style: FontTheme.of(context,
                                            fontColor: FontColor.f1,
                                            weight: FontWeight.w400,
                                            size: FontSize.displaySmall,
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (_eventColor == item)
                                      Icon(Icons.check_rounded,
                                        color: FontColor.f3.get(context),
                                      )
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 10, height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _eventColor.color
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Text(_eventColor.title,
                                style: FontTheme.of(context,
                                    size: FontSize.bodyLarge,
                                    fontColor: FontColor.f1
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: FontColor.f3.get(context),)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26,),
                CustomContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: CustomTextField(
                    controller: _memoController,
                    hintText: '내용을 입력해주세요',
                    minLines: 5,
                    maxLines: 10,
                    maxLength: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: keyboardHeight >= 50
              ? EdgeInsets.only(bottom: keyboardHeight + safeArea + 20)
              : const EdgeInsets.only(bottom: 20),
            height: 50,
            child: Row(
              children: [
                if (widget.type == AddEventType.EDIT)
                  GestureDetector(
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFFD8D8),
                      ),
                      child: Center(
                        child: SvgIcon.asset(sIcon: SIcon.trash),
                      ),
                    ),
                  ),
                if (widget.type == AddEventType.EDIT)
                  const SizedBox(width: 12,),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_disabled) return;
                      await _add();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _disabled
                          ? const Color(0xFF999999)
                          : Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Center(
                        child: Text(widget.type == AddEventType.NEW ? '일정 추가' : '일정 수정',
                          style: FontTheme.of(context,
                            color: Colors.white,
                            size: FontSize.displaySmall,
                            weight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
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

class DateRangeSelector extends StatefulWidget {
  final DateTimePick dateTimePick;

  const DateRangeSelector({
    super.key, required this.dateTimePick,
  });

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {


  _toggle(bool on) {
    setState(() {
      widget.dateTimePick.setIsAllDay(on);
    });
  }
  _setStartDate(DateTime dateTime) {
    setState(() {
      widget.dateTimePick.setStartDate(dateTime);

    });
  }
  _setStartTime(DateTime dateTime) {
    setState(() {
      widget.dateTimePick.setStartTime(dateTime);
    });
  }
  _setEndDate(DateTime dateTime) {
    setState(() {
      widget.dateTimePick.setEndDate(dateTime);
    });
  }
  _setEndTime(DateTime dateTime) {
    setState(() {
      widget.dateTimePick.setEndTime(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          EventFunction(
            title: '하루종일',
            child: ToggleButton(
              callback: () => widget.dateTimePick.isAllDay,
              onChanged: _toggle,
            )
          ),
          EventFunction(
            title: '시작',
            child: Row(

              children: [
                DatePickerWidget(
                  dateTime: widget.dateTimePick.startDate,
                  onDateChange: _setStartDate,
                ),
                if (!widget.dateTimePick.isAllDay)
                  const SizedBox(width: 7,),
                if (!widget.dateTimePick.isAllDay)
                  TimePickerWidget(
                    dateTime: widget.dateTimePick.startDate,
                    onTimeChange: _setStartTime,
                  ),
              ],
            ),
          ),
          EventFunction(
            title: '종료',
            child: Row(
              children: [
                DatePickerWidget(
                  dateTime: widget.dateTimePick.endDate,
                  onDateChange: _setEndDate,
                ),
                if (!widget.dateTimePick.isAllDay)
                  const SizedBox(width: 7,),
                if (!widget.dateTimePick.isAllDay)
                  TimePickerWidget(
                    dateTime: widget.dateTimePick.endDate,
                    onTimeChange: _setEndTime,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class EventFunction extends StatelessWidget {

  final String title;
  final Widget child;
  const EventFunction({
    super.key, required this.title, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: FontTheme.of(context,
              size: FontSize.bodyLarge,
              weight: FontWeight.w500
            ),
          ),
          child
        ],
      ),
    );
  }
}



class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? hintText;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;

  const CustomTextField({super.key, required this.controller, this.hintText, this.maxLength, this.minLines, this.maxLines, this.onChanged});

  static const _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: FontTheme.of(context,
          fontColor: FontColor.f1,
          weight: FontWeight.w400,
          size: FontSize.bodyLarge
      ),
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,

      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.zero,
        hintText: hintText,
        hintStyle: FontTheme.of(context,
            fontColor: FontColor.f3,
            weight: FontWeight.w400,
            size: FontSize.bodyLarge
        ),
        enabledBorder: _inputBorder,
        focusedErrorBorder: _inputBorder,
        focusedBorder: _inputBorder,
      ),
    );
  }
}

