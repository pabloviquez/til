# How to play an audio file from the command line

In MAC there's an utility called: `afplay`

```
$ afplay -h

    Audio File Play
    Version: 2.0
    Copyright 2003-2013, Apple Inc. All Rights Reserved.
    Specify -h (-help) for command options

Usage:
afplay [option...] audio_file

Options: (may appear before or after arguments)
  {-v | --volume} VOLUME
    set the volume for playback of the file
  {-h | --help}
    print help
  { --leaks}
    run leaks analysis
  {-t | --time} TIME
    play for TIME seconds
  {-r | --rate} RATE
    play at playback rate
  {-q | --rQuality} QUALITY
    set the quality used for rate-scaled playback (default is 0 - low quality, 1 - high quality)
  {-d | --debug}
    debug print output
```

So you can do:

```
afplay 1-01\ Bohemian\ Rhapsody.mp3
```

Or better yet:

```
afplay 1-01\ Bohemian\ Rhapsody.mp3 &
songPid=$!
```

Then to kill it:
```
kill ${songPid}
```

