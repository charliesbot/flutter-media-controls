# Flutter Media Controls
Link: [Link to this doc](#)

Author(s): Charlie L

Status: [Draft, Ready for review, In Review, Reviewed]

Last Updated: 2022-10-18

## Contents
- Goals
- Non-Goals
- Background
- Overview
- Detailed Design
  - Solution 1
    - Frontend
    - Backend
  - Solution 2
    - Frontend
    - Backend
- Considerations
- Metrics

## Links
- [A link](#)
- [Another link](#)

## Objective
Migrate *React Native Media Controls* to Flutter

Lately, I've been using Flutter instead of React Native,
and therefore is more useful to me to maintain this library in Dart.

The goal is to have a 1:1 feature parity between RN Media Controls and Flutter Media Controls

![React Native Media Controls Preview](https://user-images.githubusercontent.com/10927770/80893585-89967000-8c88-11ea-83af-2a028115ee12.gif)

## Goals
- Support play / pause button, player slider, show / hide overlay
- Support custom colors
- Support Full Screen Buttton

## Non-Goals
- Don't support toolbar

## Detailed Design

![video_player_flow](https://user-images.githubusercontent.com/10927770/196586974-a4e57c22-d2af-4c7e-b78d-1d133a2c905f.png)

## Solution: Flutter Implementation

### Background Overlay
We need a Container with a background color and an `onPress` event to toggle between play / pause state

And as a child a Column component to render:
- Spacer
- Play / Pause Button
- Slider

### Overlay Animation
This is described in the [Flutter Official Guide](https://docs.flutter.dev/cookbook/animation/opacity-animation)

We can use a state to toggle between play and pause state

```dart
AnimatedOpacity(
  // If the widget is visible, animate to 0.0 (invisible).
  // If the widget is hidden, animate to 1.0 (fully visible).
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  child: Overlay()
  ),
)
```

### Play / Pause Button
#### Solution 1 (**Preferred**)
We can use an IconButton to render this button, which support full customization

For the icons, we can use: 
- play_arrow
- pause
- replay

```dart
Container(
    height: 100,
    width: 100,
    child: IconButton(
        icon: const Icon(Icons.play_arrow),
        style: IconButton.styleFrom(
            foregroundColor: colors.onPrimary,
            backgroundColor: colors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            hoverColor: colors.onPrimary.withOpacity(0.08),
        )
    ),
```
#### Solution 2
We can create our own CustomButton
```dart
InkWell(
    height: 100,
    width: 100,
    child: Container(
      child: Icon(
        icon: const Icon(Icons.play_arrow),
      )
    )
  ),
```
We decided to not continue with this approach because it means supporting our own implementation when there's already an IconButton that does exactly what we are looking for

### Slider
[Use Flutter Native Slider](https://api.flutter.dev/flutter/material/Slider-class.html)

Slider supports the following customizations:
 - Thumb shape
 - Track shape
 - Thumb color
 - Track color

 By using SliderTheme as a parent of Slider, we can customize both the thumb and track components.

 ```dart
  SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.red[700],
        inactiveTrackColor: Colors.red[100],
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 10.0,
        thumbColor: Colors.redAccent,
        overlayColor: Colors.red.withAlpha(32),
      ),
      child: Slider(
      activeColor: Colors.amber,
      thumbColor: Colors.red,
      value: _currentSliderValue,
      max: 100,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    )
    );
 ```
### Component API
## Props
| Prop         | Type     | Optional | Default                | Description                                                          |
|--------------|----------|----------|------------------------|----------------------------------------------------------------------|
| themeColor    | string   | Yes      | rgba(12, 83, 175, 0.9) | Change custom color to the media controls                            |
| isLoading    | boolean  | Yes      | false                  | When is loading                                                      |
| isFullScreen | boolean  | Yes      | false                  | To change icon state of fullscreen                                   |
| fadeOutDelay | number   | Yes      | 5000                   | Allows to customize the delay between fade in and fade out transition|
| progress     | number   | No       |                        | Current time of the media player                                     |
| duration     | number   | No       |                        | Total duration of the media                                          |
| playerState  | number   | No       |                        | Could be PLAYING, PAUSED or ENDED (take a look at constants section) |
| onTogglePlay | function | No       |                        | Triggered when the play/pause button is pressed. It returns the new toggled value (PLAYING or PAUSED)                     |
| onReplay     | function | Yes      |                        | Triggered when the replay button is pressed                          |
| onSeek       | function | No       |                        | Triggered when the user released the slider                          |
| onSeeking    | function | Yes      |                        | Triggered when the user is interacting with the slider               |
