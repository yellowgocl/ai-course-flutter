import 'package:course/models/base_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/models/remote/components/widget_option_data.dart';
import 'package:flutter/widgets.dart';

abstract class StatelessBaseComponent<T extends WidgetData> extends StatelessWidget {
  final T data;
  StatelessBaseComponent({Key key, this.data}): super(key: key);
  O getOption<O extends WidgetOptionData>() {
    return data?.option;
  }
}

abstract class StatefulBaseComponent<T extends WidgetData> extends StatefulWidget {
  final T data;
  StatefulBaseComponent({Key key, this.data}): super(key: key);
}

abstract class StatefulBaseComponentState<T extends StatefulBaseComponent> extends State<T> {
  O getOption<O extends WidgetOptionData>() {
    return widget?.data?.option;
  }

  D getData<D extends WidgetData>() {
    return widget?.data;
  }
}