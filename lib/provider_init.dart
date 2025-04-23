
import 'package:couplink_app/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderInit extends ConsumerStatefulWidget {
  final Widget child;
  const ProviderInit({super.key, required this.child});

  @override
  ConsumerState<ProviderInit> createState() => _ProviderInitState();
}

class _ProviderInitState extends ConsumerState<ProviderInit> {

  init() async {
    await ref.read(userProvider.notifier).init();
  }

  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
