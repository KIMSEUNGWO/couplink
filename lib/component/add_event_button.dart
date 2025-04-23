
import 'package:couplink_app/entity/Event.dart';
import 'package:couplink_app/entity/event_entity.dart';
import 'package:couplink_app/widget/add_event_page.dart';
import 'package:flutter/material.dart';

class AddEventButton extends StatelessWidget {

  final Function(Event event)? add;
  final Function(Event event)? edit;

  const AddEventButton({
    super.key, required this.add, required this.edit
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddEventPage(
              type: AddEventType.NEW,
              add: add,
              edit: edit,
            );
          }, fullscreenDialog: true ));
        },
        splashColor: Colors.white.withAlpha(30),
        highlightColor: Colors.white.withAlpha(10),
        child: Ink(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFAEDDFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
