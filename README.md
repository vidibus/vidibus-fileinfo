# Vidibus::Fileinfo [![](http://travis-ci.org/vidibus/vidibus-fileinfo.png)](http://travis-ci.org/vidibus/vidibus-fileinfo) [![](http://stillmaintained.com/vidibus/vidibus-fileinfo.png)](http://stillmaintained.com/vidibus/vidibus-fileinfo)

Returns information like the width, height and bits about an image or video file.

This gem is part of [Vidibus](http://vidibus.org), an open source toolset for building distributed (video) applications.

## Installation

Add the dependency to the Gemfile of your application:

gem "vidibus-fileinfo"

Then call bundle install on your console.

## System requirements

In order to perform the file inspection, ImageMagick and FFmpeg executables are required.

Unless ruby already knows about those tools, you'll have to define the path somewhere.
In a Rails environment, a good place would be your development.rb and production.rb.

Example for development environment on OSX:

```
# Set path to ImageMagick and FFmpeg executables
ENV["PATH"] = "#{ENV["PATH"]}:/opt/local/bin"
```

Example for production environment on Debian:

```
# Set path to ImageMagick and FFmpeg executables
ENV["PATH"] = "#{ENV["PATH"]}:/usr/bin/"
```

## Usage

Obtaining information from a file is easy:

``` ruby
Fileinfo("path/to/myfile.png")
# => {:width => 300, height => 200, ... }
```

### Image files

For images, a hash with following data will be returned:

``` ruby
:width             # width of image
:height            # height of image
:size              # file size in bytes
:bit               # depth in bit
:content_type      # content type of image, e.g. "jpeg"
```

This gem currently support these image formats:

```
jpg, jpeg, png, gif
```

### Video files

For videos, a different hash will be returned:

``` ruby
:width             # width of video
:height            # height of video
:size              # file size in bytes
:duration          # duration of video in seconds
:fps               # frames per second
:bitrate           # overall bit rate (video + audio)
:video_codec       # codec of video stream, e.g. "h264"
:audio_codec       # codec of audio stream, e.g. "aac"
:audio_sample_rate # sample rate of audio stream, e.g. 48000
```

These video formats are currently supported:

```
avi, flv, h261, h263, h264, ipod, m4v, mov, mp4, mpeg, mxf, ogg
```

## Copyright

Copyright (c) 2011 Andre Pankratz. See LICENSE for details.