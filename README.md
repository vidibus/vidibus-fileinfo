# Vidibus::Fileinfo [![](http://stillmaintained.com/vidibus/vidibus-fileinfo.png)](http://stillmaintained.com/vidibus/vidibus-fileinfo)

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

``` shell
# Set path to ImageMagick and FFmpeg executables
ENV["PATH"] = "#{ENV["PATH"]}:/opt/local/bin"
```

Example for production environment on Debian:

``` shell
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
:content_type      # content type of image, e.g. "image/jpeg"
:orientation       # visual position e.g. 6 (right top). See "Exif orientation" for more
:quality           # quality of image
```

This gem currently support these image formats:

```
jpg, jpeg, png, gif
```

### Video files

For videos, a different hash will be returned:

``` ruby
:width             # width of video (without anamorphosis), e.g. 1920
:height            # height of video, e.g. 1080
:aspect_ratio      # aspect ratio of video on display (DAR), e.g. 1.777778
:size              # file size in bytes, eg. 20883991
:duration          # duration of video in seconds, e.g. 44.82
:content_type      # content type of video, e.g. "video/mp4"
:frame_rate        # frames per second, e.g. 29.97
:bit_rate          # overall bit rate (video + audio) in bit, e.g. 600000
:video_codec       # codec of video stream, e.g. "h264 (Main)"
:audio_codec       # codec of audio stream, e.g. "aac"
:audio_sample_rate # sample rate of audio stream, e.g. 48000
```

These video formats are currently supported:

```
3g2, 3gp, asf, avi, dv, f4p, f4v, flv, ivf, m21, mj2, mjpg, mkv, mov, mp4,
mpeg, mpg, mxf, ogg, ogv, rm, ts, webm, wmv
```

## Copyright

Copyright (c) 2011-2012 Andre Pankratz. See LICENSE for details.
