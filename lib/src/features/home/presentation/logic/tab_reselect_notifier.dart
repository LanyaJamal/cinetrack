import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef TabReselect = ({int index, int tick});

class TabReselectNotifier extends Notifier<TabReselect> {
  @override
  TabReselect build() => (index: -1, tick: 0);

  void reselect(int index) => state = (index: index, tick: state.tick + 1);
}

final tabReselectProvider = NotifierProvider<TabReselectNotifier, TabReselect>(
  TabReselectNotifier.new,
);
