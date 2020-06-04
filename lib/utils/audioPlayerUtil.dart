

import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/event/audio_event.dart';
// import 'package:course/event/audioEvent.dart';
// import 'package:course/event/baseEvent.dart';
// import 'package:course/event/event.dart';
// import 'package:course/event/eventDispatcher.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:course/utils/platformUtil.dart';
import 'package:flutter/widgets.dart';

// https://www.myinstants.com//media/sounds/kids_cheering.mp3  细路庆祝
// https://www.myinstants.com//media/sounds/tuturu_1.mp3 细路庆祝1
// https://www.myinstants.com/media/sounds/holy-shit.mp3 holy shit
// https://www.myinstants.com/media/sounds/fuckoff.mp3 fuckoff
 
// enum AudioPlayerState {
//   stop, play, pause,
// }

enum AudioPoolType {
  background, effects, voice, asset
}


class AudioPool {
  static Map<AudioPoolType, AudioPlayerUtil> _pool = {};
  static final _instance = AudioPool._internal();
  factory AudioPool () {
    return _instance;
  }

  AudioPool._internal();
  static AudioPool get instance {
    return new AudioPool();
  }
  static _getAudioPlayer(AudioPoolType poolType) {
    poolType = poolType??AudioPoolType.voice;
    PlayerMode mode = PlayerMode.MEDIA_PLAYER;
    AudioPlayerUtil temp = _pool[poolType];
    if(temp == null) {
      _pool[poolType] = AudioPlayerUtil(null, mode: mode);
    }
    return _pool[poolType];
  }
  static AudioEvent _buildPoolCompleteEvent(AudioPoolType poolType, AudioEventParams params) {
    if (poolType == null) {
      return null;
    }
    params?.poolType = poolType;
    if (poolType == AudioPoolType.asset) {
      return AudioEvent(event: Events.AUDIO_ASSET_ON_COMPLETE, params: params);
    } else if (poolType == AudioPoolType.background) {
      return AudioEvent(event: Events.AUDIO_BACKGROUND_ON_COMPLETE, params: params);
    } else if (poolType == AudioPoolType.voice) {
      return AudioEvent(event: Events.AUDIO_VOICE_ON_COMPLETE, params: params);
    } else if (poolType == AudioPoolType.effects) {
      return AudioEvent(event: Events.AUDIO_EFFECT_ON_COMPLETE, params: params);
    }
    return null;
  }
  static _attachListener(AudioPlayerUtil player, AudioPoolType poolType, Function(AudioEvent) onComplete) {
    if (player != null) {
      player.onComplete = (e) {
        AudioEvent event = _buildPoolCompleteEvent(poolType, e?.params);
        if (event != null)
          EventUtil.fire(event);

        if (onComplete != null)
          onComplete(event);
        
        return Future.value(event);
        // Map<String, dynamic> data = { "url": player.url, "isLocal": player.isLocal };
        // eventDispatcher.fire<AudioEvent>(EventBuilder.build<AudioEvent>(event, data: player));
      };
    }
    return Future.value(null);
  }
  static Future<AudioEvent> play({ AudioPoolType poolType, String url, bool isLocal:false, Function(AudioEvent) onComplete }) async {
    if (!isLocal && poolType == AudioPoolType.asset) {
      isLocal = true;
    }
    poolType = isLocal ? AudioPoolType.asset : poolType;
    
    AudioPlayerUtil ap = _getAudioPlayer(poolType);
    ap.url = url;
    ap?.stop();
    _attachListener(ap, poolType, onComplete);
    return await ap?.play(url:url, isLocal: isLocal);
  }
  static Future<int> pause({ AudioPoolType poolType, bool isLocal: false }) async {
    AudioPlayerUtil ap = _getAudioPlayer(poolType);
    return await ap?.pause();
  }
  static Future<int> stop({ AudioPoolType poolType }) async {
    AudioPlayerUtil ap = _getAudioPlayer(poolType);
    return await ap?.stop();
  }
  static stopAll() {
    _pool?.values?.forEach((AudioPlayerUtil player) {
      // print(player.url);
      player?.stop();
    });
  }
  static playAll() {
    _pool?.values?.map((AudioPlayerUtil player) {
      player?.play();
    });
  }
}

final AudioPool audioPool = AudioPool.instance;

class AudioPlayerUtil {
  Key key;
  String url;
  bool isLocal = false;
  AudioPlayer _audioPlayer;
  AudioCache _audioCache;
  PlayerMode mode;
  Function onPositionChange, onDurationChange, onComplete, onStateChange, onError;
  StreamSubscription _positionSubscription, _durationSubscription, _completeSubscription, _stateSubscription, _errorSubscription;

  AudioPlayerState _state = AudioPlayerState.STOPPED;
  Duration _progress;
  Duration _duration;
  String assetPrefix;

  Completer completer;

  AudioPlayerUtil(this.url, {this.isLocal:false, this.key, this.mode:PlayerMode.MEDIA_PLAYER, this.onComplete, this.onDurationChange, this.onError, this.onPositionChange, this.onStateChange, this.assetPrefix: ''}) {
    _audioCache = AudioCache(prefix: assetPrefix);
    _initialized();
  }

  get isPlaying => _state == AudioPlayerState.PLAYING;
  get isPaused => _state == AudioPlayerState.PAUSED;
  get isStoped => _state == AudioPlayerState.STOPPED;
  get durationText => _duration?.toString()?.split('.')?.first ?? '';
  get progressText => _progress?.toString()?.split('.')?.first ?? '';

  void _initialized() {
    this.key = this.key??UniqueKey();
    completer = Completer<AudioEvent>();
    _progress = Duration();
    _audioPlayer = AudioPlayer(mode: mode);
    _audioCache.fixedPlayer = _audioPlayer;
    _durationSubscription = _audioPlayer.onDurationChanged.listen(_onDurationChange);
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen(_onPositionChange);
    _completeSubscription = _audioPlayer.onPlayerCompletion.listen(_onComplete);
    _errorSubscription = _audioPlayer.onPlayerError.listen(_onError);
  }
  void _onPositionChange(Duration p) {
    // print(p);
    _progress = p;
    if (this.onPositionChange != null) {
      this.onPositionChange(p);
    }
  }
  void _onDurationChange(Duration d) {
    _duration = d;
    if (platformUtil.platformData.platform == PlatformType.IOS) {
      // set atleast title to see the notification bar on ios.
      // _audioPlayer.setNotification(title: 'app name');
    }
    if (this.onDurationChange != null) {
      this.onDurationChange(_duration);
    }
  }
  void _onComplete(event) {
    _progress = _duration;
      AudioEvent event = AudioEvent(event: Events.AUDIO_ON_COMPLETE, params: AudioEventParams(duration: _progress, src: url));
      EventUtil.fire(event);
      if (completer?.isCompleted != true) {
        completer?.complete(event);
      }
    if (this.onComplete != null) {
      this.onComplete(event);
    }
  }
  void _onError(String error) {
    print('audio player error: $error');
    _state = AudioPlayerState.STOPPED;
    _duration = Duration(seconds: 0);
    _progress = Duration(seconds: 0);
    completer?.completeError('audio player error: $error');
  }

  Future<AudioEvent> play({String url, bool isLocal}) async {
    final p = (_progress != null && 
      _duration != null && 
      _progress.inMilliseconds > 0 && 
      _progress.inMilliseconds < _duration.inMilliseconds)
      ? _progress
      : null; 
    if (isLocal != null && this.isLocal != isLocal) {
      this.isLocal = isLocal;
    }
    if (url != null && url.length > 0 && url != this.url) {
      this.url = url;
    }
    if (this.url == null) {
      return AudioEvent(event: Events.AUDIO_ON_ERROR);
    }
    AudioPlayer player = _audioPlayer;
    int result = 0;
    if (this.isLocal) {
      await _audioCache.play(this.url);
      result = player.state == AudioPlayerState.PLAYING ? 1 : 0;
    } else {
      result = await player.play(this.url, isLocal: this.isLocal, position: p);
    }
    // print('androidplayerutil:play$result');
    AudioEvent event = AudioEvent(id: key, event: Events.AUDIO_ON_PLAY, params: AudioEventParams(duration: _progress, src: url));
    if (result == 1) {
      _state = AudioPlayerState.PLAYING;
      EventUtil.fire(event);
    }
    return event;
  }
  Future<int> pause() async {
    // print('audioplayerutil:pause');
    final result = await _audioPlayer.pause();
    if (result == 1) {
      _state = AudioPlayerState.PAUSED;
      EventUtil.fire(AudioEvent(event: Events.AUDIO_ON_PAUSE, params: AudioEventParams(duration: _progress, src: url)));
    }

    return result;
  }
  Future<int> stop() async {
    // print('audioplayerutil:stop');
    final result = await _audioPlayer.stop();
    if (result == 1) {
      _state = AudioPlayerState.STOPPED;
      _progress = Duration();
      EventUtil.fire(AudioEvent(event: Events.AUDIO_ON_STOP, params: AudioEventParams(duration: _progress, src: url)));
    }
    return result;
  }
  void dispose() {
    _audioPlayer?.stop();
    _audioPlayer?.release();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _completeSubscription?.cancel();
    _errorSubscription?.cancel();
    _stateSubscription?.cancel();
  }

}