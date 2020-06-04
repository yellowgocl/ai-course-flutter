import 'dart:async';

import 'package:course/models/event/base_event.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';

enum Events {
  CALL_ON_GAME_INIT,
  CALL_GAME_INIT_ERROR,
  CALL_ON_ACCESSTOKEN,
  CALL_UPDATE_ACCESSTOKEN,
  CALL_GO_BACK,
  ACTION_RECORD,
  ACTION_REPEAT_QUESTION,
  ACTION_CONTINUE,
  ACTION_CANCEL,
  ACTION_BUTTON_PLAY,
  ACTION_BUTTON_PAUSE,
  ACTION_BUTTON_PLAY_AND_PAUSE,
  ACTION_BUTTON_QUIT_GAME,
  ACTION_BUTTON_QUIT_APP,
  ACTION_BUTTON_CHANGE_COURSE,
  AUDIO_ON_PLAY,
  AUDIO_ON_PAUSE,
  AUDIO_ON_STOP,
  AUDIO_ON_COMPLETE,
  AUDIO_ON_ERROR,
  AUDIO_ASSET_ON_COMPLETE,
  AUDIO_BACKGROUND_ON_COMPLETE,
  AUDIO_VOICE_ON_COMPLETE,
  AUDIO_EFFECT_ON_COMPLETE,
  VIDEO_ON_PLAY,
  VIDEO_ON_PAUSE,
  VIDEO_ON_STOP,
  VIDEO_ON_COMPLETE,
  VIDEO_REPLAY,
}

class EventUtil {
  static final EventBus eventBus = EventBus();
  static Events getEvent(val){
    if (val is Events) {
      return val;
    }
    Events result;
    if (val is String) {
      result = _getEventByName(val);
    } else if (val is int) {
      result = _getEventByIndex(val);
    } else if (val is Map) {
      if (val.containsKey('event')) {
        result = _getEventByName(CollectionUtil.get(val, key: 'event'));
      } else if (val.containsKey('eventIndex')) {
        result = _getEventByIndex(CollectionUtil.get(val, key: 'event', defaultValue: -1));
      }
    }
    return result;
  }

  static Events _getEventByName(String eventName) {
    Events result;
    for (Events event in Events.values) {
        result = eventName == describeEnum(event) ? event : null;
        if (result != null) break;
      }
    return result;
  }
  static Events _getEventByIndex(int eventIndex) {
    Events result;
    if (eventIndex >= 0 && eventIndex < Events.values.length) {
      result = Events.values[eventIndex];
    }
    return result;
  }

  static bool fire<T extends BaseEvent> (T event) {
    if (event.isVaild) {
      eventBus.fire(event);
    }
    return event.isVaild;
  }

  static Stream<T> on<T extends BaseEvent>() {
    return eventBus.on<T>();
  }
  static StreamSubscription listen<T extends BaseEvent> (Function(T) onData, { Function onError, Function onDone, bool cancelOnError: true }) {
    return on<T>().listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}