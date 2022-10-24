library flutter_media_controls;

import 'package:flutter/material.dart';

enum PlayerState {
  playing(1),
  paused(2),
  ended(3);

  const PlayerState(this.value);
  final num value;
}

class FlutterMediaControls extends StatefulWidget {
  const FlutterMediaControls({
    super.key,
    required this.onTogglePlay,
    required this.playerState,
  });

  final Function onTogglePlay;
  final PlayerState playerState;

  @override
  State<FlutterMediaControls> createState() => _FlutterMediaControlsState();
}

class _FlutterMediaControlsState extends State<FlutterMediaControls> {
  double opacity = 0;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      opacity = 1;
      isVisible = true;
    });
  }

  onToggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      opacity = opacity == 0 ? 1 : 0;
    });
  }

  getPlayerStateIcon(PlayerState playerState) {
    if (playerState == PlayerState.playing) {
      return Icon(Icons.play_arrow);
    }

    if (playerState == PlayerState.paused) {
      return Icon(Icons.pause);
    }

    return Icon(Icons.replay);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: onToggleVisibility,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    //color: Colors.green,
                    ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  //color: Colors.orange,
                  child: Center(
                    child: Container(
                      color: Colors.purple,
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () => widget.onTogglePlay(),
                        icon: getPlayerStateIcon(widget.playerState),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.red,
                          highlightColor: Colors.red,
                          focusColor: Colors.red,
                          hoverColor: Colors.red,
                          surfaceTintColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  //color: Colors.blue,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red[700],
                      inactiveTrackColor: Colors.red[100],
                      thumbColor: Colors.redAccent,
                      overlayColor: Colors.red.withAlpha(32),
                    ),
                    child: Slider(
                      activeColor: Colors.amber,
                      thumbColor: Colors.red,
                      value: 0,
                      max: 100,
                      onChanged: (double value) {
                        // setState(() {
                        //   _currentSliderValue = value;
                        // });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
