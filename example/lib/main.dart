import 'package:flutter/material.dart';
import 'package:flutter_media_controls/flutter_media_controls.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _videoPlayerController;
  PlayerState _playerState = PlayerState.paused;

  @override
  void initState() {
    super.initState();
    _playerState = PlayerState.paused;
    _videoPlayerController = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        _videoPlayerController.play();
        _videoPlayerController.setVolume(0.0);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _playerState = PlayerState.playing;
        });
      });
    _videoPlayerController.addListener(checkPlayerState);
    _videoPlayerController.addListener(onProgressUpdate);
  }

  checkPlayerState() {
    _playerState = _videoPlayerController.value.isPlaying
        ? PlayerState.playing
        : PlayerState.paused;

    setState(() {
      _playerState = _playerState;
    });

    // Implement your calls inside these conditions' bodies :
    //   print('video Started');
    // }

    // if(videoPlayerController.value.position == videoPlayerController.value.duration) {
    //   print('video Ended');
    // }
  }

  onProgressUpdate() {
    _videoPlayerController.value.position;
    //print("TEST " + _videoPlayerController.value.position.toString());
  }

  onTogglePlay() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 640,
          height: 360,
          child: Stack(
            children: [
              _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : Container(),
              FlutterMediaControls(
                playerState: _playerState,
                onTogglePlay: () => onTogglePlay(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
