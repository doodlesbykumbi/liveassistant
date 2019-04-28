# LiveAssistant

The LiveAssistant pipeline is composed of 3 parts, gst-launch that captures mic input and pipes it to stdin, a Go binary that pipes stdin to the Google Cloud Speech API, and a bash script that processes the transcript line by line .

### Requirements

+ Authenticated via `gcloud`
+ Install `gts-launch`

#### Authentication

* Create a project with the [Google Cloud Console][cloud-console], and enable
  the [Speech API][speech-api].

#### gst-launch

To install `gts-launch` on OSX:
```bash
brew install gstreamer gst-libav gst-plugins-ugly gst-plugins-base gst-plugins-bad gst-plugins-good
```

[cloud-console]: https://console.cloud.google.com
[speech-api]: https://console.cloud.google.com/apis/api/speech.googleapis.com/overview?project=_

## Usage

Run the command below to kick off the pipeline:
```bash
./pipeline.sh
```

```
initialising...
start by saying 'calculate'
waiting for instructions to calculate...
 9354 + 2228 = 11582
 6 * 6 = 36
stopped calculating
2019/04/27 00:01:35 WARNING: Speech recognition request exceeded limit of 60 seconds.
2019/04/27 00:01:35 Could not recognize: code:11 message:"Exceeded maximum allowed stream duration of 305 seconds." 
exit status 1
```

## Build and run from scratch

Before building  you must first install `Go` followed by the Speech API client:

```bash
go get -u cloud.google.com/go/speech/apiv1
```

Build:

```bash
go build -o ./out/liveassistant ./liveassistant.go
```

`gst-launch` can be used to capture audio from the mic. For example `./testdata/audio.raw` was generated using:

```bash
gst-launch-1.0 -q osxaudiosrc ! \
 audioconvert ! \
 audioresample ! \
 audio/x-raw,channels=1,rate=16000 ! \
 filesink location=./testdata/audio.raw
```

Pipe the output to the `liveassistant`:
```bash
cat ./testdata/audio.raw | \
  ./out/liveassistant
```
```
calculate
  something
  anything
```
