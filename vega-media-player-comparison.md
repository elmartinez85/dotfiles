# Vega OS Media Player Comparison Matrix

> **Document Version:** 1.0
> **Last Updated:** February 2026
> **Target Platform:** Amazon Vega OS (Fire TV)
> **Source:** Official Amazon Developer Documentation (v0.22)

---

## Executive Summary

This document compares the three media players officially supported by Amazon Vega OS for Fire TV applications: **Shaka Player**, **dash.js**, and **hls.js**.

### Requirements Analysis

| Requirement | Shaka Player | dash.js | hls.js |
|-------------|:------------:|:-------:|:------:|
| **HLS Streaming** | ✅ | ❌ | ✅ |
| **WebVTT Subtitles** | ✅ | ✅ | ✅ |
| **DFXP/TTML Subtitles** | ✅ | ✅ | ❌ |
| **Meets All Requirements** | ✅ **Yes** | ❌ No | ❌ No |

### Recommendation

**Shaka Player** is the only player that meets all three requirements (HLS + WebVTT + DFXP/TTML).

---

## 1. Player Overview

| Attribute | Shaka Player | dash.js | hls.js |
|-----------|--------------|---------|--------|
| **Maintainer** | Google | DASH Industry Forum | video-dev community |
| **Open Source Repo** | [shaka-project/shaka-player](https://github.com/shaka-project/shaka-player) | [Dash-Industry-Forum/dash.js](https://github.com/Dash-Industry-Forum/dash.js) | [video-dev/hls.js](https://github.com/video-dev/hls.js) |
| **Primary Protocol** | Multi-protocol | DASH | HLS |
| **Vega Maturity** | Most mature | Newest | Moderate |
| **Amazon Sample App** | ✅ [vega-video-sample](https://github.com/AmazonAppDev/vega-video-sample) | ❌ | ❌ |

---

## 2. Vega OS Version Support

### Shaka Player (Recommended)

| Version | Status | Key Features |
|---------|--------|--------------|
| **4.8.5-r1.5** | ✅ Latest | DTS audio, TTML playback fixes, duplicate segment prevention |
| **4.8.5-r1.4** | Current | MPEG2 video codec support |
| **4.8.5-r1.3** | Current | Codec switch fixes, AV sync on seek/variant switch |
| **4.8.5-r1.2** | Current | MediaSource reset optimization, manifest update fixes |
| **4.6.18-r2.16** | Current | Codec switch bug fixes |
| **4.6.18-r2.15** | Current | DASH nativization fixes |
| **4.3.6-r2.5** | ⚠️ EOL Sept 1, 2025 | Headless JS playback support |

### dash.js

| Version | Status | Key Features |
|---------|--------|--------------|
| **5.0.0-r1.5** | ✅ Latest | CC/Subtitles fixes, ClearKey DRM, ABR switching |
| **5.0.0-r1.4** | Initial | First Vega release |

### hls.js

| Version | Status | Key Features |
|---------|--------|--------------|
| **1.5.11-r1.6** | ✅ Latest | Captions rendering fixes |
| **1.5.11-r1.5** | Current | Headless JS playback support |

---

## 3. Streaming Protocol Support

| Protocol | Shaka Player | dash.js | hls.js |
|----------|:------------:|:-------:|:------:|
| **HLS (HTTP Live Streaming)** | ✅ | ❌ | ✅ |
| **MPEG-DASH** | ✅ | ✅ | ❌ |
| **MSS (Smooth Streaming)** | ✅ | ✅ | ❌ |
| **Progressive MP4/MP3** | ✅ | ❌ | ❌ |
| **Low-Latency HLS (LL-HLS)** | ✅ | ❌ | ✅ |
| **Low-Latency DASH (LL-DASH)** | ✅ | ✅ | ❌ |

**Winner:** Shaka Player (supports all protocols)

---

## 4. Subtitle/Caption Support

| Format | Shaka Player | dash.js | hls.js | Notes |
|--------|:------------:|:-------:|:------:|-------|
| **WebVTT** | ✅ | ✅ | ✅ | Web standard, widely used |
| **TTML/DFXP** | ✅ | ✅ | ❌ | Required for broadcast content |
| **CEA-608** | ✅ | ✅ | ✅ | US broadcast standard |
| **CEA-708** | ✅ | ✅ | ✅ | US digital broadcast |
| **SRT** | ✅ | ❌ | ❌ | Common user format |
| **IMSC1** | ✅ | ✅ | ❌ | TTML profile for streaming |

### DFXP/TTML Details

- **DFXP** (Distribution Format Exchange Profile) is the original W3C specification
- **TTML** (Timed Text Markup Language) is the evolved standard
- They are functionally equivalent for subtitle rendering
- Shaka Player 4.8.5-r1.5 includes specific TTML playback fixes

**Winner:** Shaka Player (full subtitle format support including DFXP/TTML)

---

## 5. DRM Support

| DRM System | Shaka Player | dash.js | hls.js |
|------------|:------------:|:-------:|:------:|
| **Widevine L1/L3** | ✅ | ✅ | ✅ |
| **PlayReady SL3000** | ✅ | ✅ | ✅ |
| **ClearKey** | ✅ | ✅ (r1.5+) | ❌ |
| **Secure Video Buffers** | ✅ | ✅ | ✅ |

### DRM Configuration (All Players)

```typescript
const content = {
  secure: 'true',  // Enable secure video buffers for L1
  uri: 'https://example.com/stream.m3u8',
  drm_scheme: 'com.widevine.alpha',  // or 'com.microsoft.playready'
  drm_license_uri: 'https://license.example.com/widevine'
};
```

**Vega OS Supported DRM:** Widevine (L1) and PlayReady (SL3000)

---

## 6. Video Codec Support

| Codec | Shaka Player | dash.js | hls.js | Vega HW Decode |
|-------|:------------:|:-------:|:------:|:--------------:|
| **H.264 (AVC)** | ✅ | ✅ | ✅ | ✅ 4K@60fps |
| **H.265 (HEVC)** | ✅ | ✅ | ✅ | ✅ 4K@60fps |
| **VP8** | ✅ | ✅ | ❌ | ✅ |
| **VP9** | ✅ | ✅ | ❌ | ✅ |
| **AV1** | ✅ | ✅ | ❌ | ✅ |
| **MPEG-2** | ✅ (4.8.5+) | ❌ | ❌ | ✅ |
| **MPEG-4** | ✅ | ✅ | ❌ | ✅ |

---

## 7. Audio Codec Support

| Codec | Shaka Player | dash.js | hls.js | Vega Support |
|-------|:------------:|:-------:|:------:|:------------:|
| **AAC (LC/HE/HEv2)** | ✅ | ✅ | ✅ | ✅ |
| **MP3** | ✅ | ✅ | ✅ | ✅ |
| **Dolby AC-3** | ✅ | ✅ | ❌ | ✅ Passthrough |
| **Dolby E-AC-3** | ✅ | ✅ | ❌ | ✅ Passthrough |
| **Dolby AC-4** | ✅ | ✅ | ❌ | ✅ |
| **DTS** | ✅ (4.8.5+) | ❌ | ❌ | ✅ |
| **Opus** | ✅ | ✅ | ❌ | ✅ |
| **FLAC** | ✅ | ✅ | ❌ | ✅ |

---

## 8. Container Format Support

| Container | Shaka Player | dash.js | hls.js |
|-----------|:------------:|:-------:|:------:|
| **fMP4 (CMAF)** | ✅ | ✅ | ✅ |
| **MPEG-2 TS** | ✅ | ✅ | ✅ |
| **WebM** | ✅ | ✅ | ❌ |
| **Raw AAC** | ✅ | ❌ | ✅ |
| **Raw MP3** | ✅ | ❌ | ✅ |

---

## 9. ABR (Adaptive Bitrate) Configuration

| Setting | Shaka Player | dash.js | hls.js |
|---------|:------------:|:-------:|:------:|
| **ABR Enabled** | ✅ Configurable | ✅ (r1.5+) | ✅ |
| **Default Max Width (TV)** | 3840 | 3840 | 3840 |
| **Default Max Height (TV)** | 2160 | 2160 | 2160 |
| **Default Max Width (Non-TV)** | 1919 | 1919 | 1919 |
| **Default Max Height (Non-TV)** | 1079 | 1079 | 1079 |

### Shaka Player ABR Configuration

```typescript
const playerSettings: ShakaPlayerSettings = {
  secure: false,
  abrEnabled: true,
  abrMaxWidth: 3840,
  abrMaxHeight: 2160,
};
```

---

## 10. Integration Complexity

### Required Dependencies (All Players)

```json
{
  "xmldom": "0.6.0",
  "base-64": "1.0.0",
  "fastestsmallesttextencoderdecoder": "1.0.22"
}
```

### Polyfill Requirements

| Polyfill | Shaka Player | dash.js | hls.js |
|----------|:------------:|:-------:|:------:|
| DocumentPolyfill | ✅ Built-in | ⚠️ Manual | ⚠️ Manual |
| ElementPolyfill | ✅ Built-in | ⚠️ Manual | ⚠️ Manual |
| TextDecoderPolyfill | ✅ Built-in | ⚠️ Manual | ⚠️ Manual |
| W3CMediaPolyfill | ✅ Built-in | ⚠️ Manual | ⚠️ Manual |
| MiscPolyfill | ✅ Built-in | ⚠️ Manual | ⚠️ Manual |

### Setup Steps Comparison

| Step | Shaka Player | dash.js | hls.js |
|------|:------------:|:-------:|:------:|
| Download package | ✅ | ✅ | ✅ |
| Run setup.sh | ✅ | ✅ | ✅ |
| Copy src/* | ✅ | ✅ | ✅ |
| Copy dist/ | ✅ | ✅ | ✅ |
| Copy polyfills/ | ❌ | ❌ | ✅ |
| Install polyfills in code | ❌ | ✅ | ✅ |
| **Total Steps** | **4** | **5** | **6** |

**Winner:** Shaka Player (simplest integration)

---

## 11. Component Naming

| Component | Shaka Player | dash.js | hls.js |
|-----------|--------------|---------|--------|
| Video Surface | `KeplerVideoSurfaceView` | `VegaVideoSurfaceView` | `KeplerVideoSurfaceView` |
| Captions View | `KeplerCaptionsView` | `VegaCaptionsView` | `KeplerCaptionsView` |

**Note:** dash.js uses different component naming (`Vega*` vs `Kepler*`).

---

## 12. Special Features

| Feature | Shaka Player | dash.js | hls.js |
|---------|:------------:|:-------:|:------:|
| **Headless JS Playback** | ✅ | ❌ | ✅ |
| **MPEG-2 Video** | ✅ | ❌ | ❌ |
| **DTS Audio** | ✅ | ❌ | ❌ |
| **HLS Sequence Mode** | ✅ | N/A | ❌ |
| **Offline Storage** | ✅ | ❌ | ❌ |
| **Trick Play** | ✅ | ✅ | ❌ |
| **Thumbnail Previews** | ✅ | ✅ | ❌ |

### HLS Sequence Mode (Shaka Player)

For HLS streams with MPEGTS content that has out-of-order timestamps:

```typescript
player.current.player.configure('manifest.hls.sequenceMode', true);
```

---

## 13. Code Examples

### Shaka Player Implementation (Recommended)

```typescript
import * as React from 'react';
import { useRef, useState, useEffect } from 'react';
import { Platform, View, StyleSheet } from 'react-native';
import {
  VideoPlayer,
  KeplerVideoSurfaceView,
  KeplerCaptionsView,
} from '@amazon-devices/react-native-w3cmedia';
import { ShakaPlayer, ShakaPlayerSettings } from './shakaplayer/ShakaPlayer';

const AUTOPLAY = true;

const content = {
  secure: 'false',
  uri: 'https://example.com/news/stream.m3u8',
  drm_scheme: '',
  drm_license_uri: '',
};

export const VideoPlayerComponent = () => {
  const player = useRef<any>(null);
  const videoPlayer = useRef<VideoPlayer | null>(null);

  const playerSettings: ShakaPlayerSettings = {
    secure: false,
    abrEnabled: true,
    abrMaxWidth: Platform.isTV ? 3840 : 1919,
    abrMaxHeight: Platform.isTV ? 2160 : 1079,
  };

  const initializeVideoPlayer = async () => {
    videoPlayer.current = new VideoPlayer();
    global.gmedia = videoPlayer.current;
    await videoPlayer.current.initialize();
    videoPlayer.current.autoplay = false;

    // Initialize Shaka Player
    player.current = new ShakaPlayer(videoPlayer.current, playerSettings);
    player.current.load(content, AUTOPLAY);
  };

  useEffect(() => {
    initializeVideoPlayer();
    return () => {
      player.current?.unload();
      videoPlayer.current?.deinitialize();
    };
  }, []);

  const onSurfaceViewCreated = (surfaceHandle: string) => {
    videoPlayer.current?.setSurfaceHandle(surfaceHandle);
    videoPlayer.current?.play();
  };

  const onCaptionViewCreated = (captionsHandle: string) => {
    videoPlayer.current?.setCaptionViewHandle(captionsHandle);
  };

  return (
    <View style={styles.container}>
      <KeplerVideoSurfaceView
        style={styles.video}
        onSurfaceViewCreated={onSurfaceViewCreated}
        onSurfaceViewDestroyed={(h) => videoPlayer.current?.clearSurfaceHandle(h)}
      />
      <KeplerCaptionsView
        style={styles.captions}
        onCaptionViewCreated={onCaptionViewCreated}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000' },
  video: { zIndex: 0 },
  captions: {
    width: '100%',
    height: '100%',
    position: 'absolute',
    backgroundColor: 'transparent',
    zIndex: 2,
  },
});
```

---

## 14. Troubleshooting

### Shaka Player Build Issues

| Issue | Solution |
|-------|----------|
| `GLIBC_2.27 not found` | Use Node 16.20.2: `nvm use 16.20.2` |
| ESLint config "google" not found | Remove `.eslintrc.js` from parent directories |
| Build doesn't complete | Replace `git+ssh` with `https` in `package-lock.json` |

### dash.js / hls.js Build Issues

| Issue | Solution |
|-------|----------|
| Unable to resolve base-64/xmldom | `npm install --save base-64 xmldom` |

---

## 15. Decision Matrix

### By Use Case

| Requirement | Recommended Player | Reason |
|-------------|-------------------|--------|
| HLS + WebVTT + DFXP/TTML | **Shaka Player** | Only option meeting all three |
| HLS + DASH support | Shaka Player | Only multi-protocol player |
| DASH only | Shaka or dash.js | Both work well |
| HLS only, no TTML needed | hls.js | Lighter weight |
| Offline playback | Shaka Player | Only option with storage |
| Dolby audio passthrough | Shaka or dash.js | hls.js lacks support |
| MPEG-2 legacy content | Shaka Player | Exclusive support |
| Simplest integration | Shaka Player | No manual polyfills |

### Score Card

| Criteria | Shaka Player | dash.js | hls.js |
|----------|:------------:|:-------:|:------:|
| HLS Support | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ |
| WebVTT Support | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| DFXP/TTML Support | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ |
| DRM Support | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Codec Support | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Setup Simplicity | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Vega Maturity | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Bundle Size | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Total** | **38/40** | **28/40** | **28/40** |

---

## 16. Final Recommendation

### For Local News Application: **Shaka Player**

**Reasons:**

1. **Meets All Requirements**
   - ✅ HLS streaming support
   - ✅ WebVTT subtitle support
   - ✅ DFXP/TTML subtitle support

2. **Technical Advantages**
   - Multi-protocol flexibility (HLS + DASH)
   - Simplest integration (built-in polyfills)
   - Most Vega releases (10+ vs 2)
   - Best codec support (MPEG-2, DTS)
   - Offline storage capability

3. **Amazon Support**
   - Official sample app uses Shaka
   - Most extensive documentation
   - Active patch releases

4. **Future-Proof**
   - Supports emerging codecs (AV1)
   - Low-latency streaming ready
   - Trick play for TV UX

### Recommended Version

**Shaka Player 4.8.5-r1.5** (Latest)

- Includes TTML playback fixes
- DTS audio support
- Most stable release

---

## Appendix A: npm Package Scope

As of Vega SDK v0.21, the npm package scope changed:

| Old Scope | New Scope |
|-----------|-----------|
| `@amzn/react-native-w3cmedia` | `@amazon-devices/react-native-w3cmedia` |

Ensure you update imports when upgrading from older SDK versions.

---

## Appendix B: Quick Reference

### Shaka Player Setup Commands

```bash
# Download and extract
tar -xzf shaka-rel-v4.8.5-r1.5.tar.gz

# Run setup
cd shaka-rel/scripts
./setup.sh

# Copy to app
cp -r shaka-player/shaka-rel/src/* <app>/src/
cp -r shaka-player/dist <app>/src/shakaplayer/
```

### Content Configuration Template

```typescript
interface ContentConfig {
  secure: 'true' | 'false';
  uri: string;
  drm_scheme: '' | 'com.widevine.alpha' | 'com.microsoft.playready';
  drm_license_uri: string;
}

const newsContent: ContentConfig = {
  secure: 'false',
  uri: 'https://cdn.newsapp.com/live/stream.m3u8',
  drm_scheme: '',
  drm_license_uri: '',
};
```

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | February 2026 | Initial release |

---

*This document is based on Amazon Vega OS Developer Documentation v0.22 (Open Beta)*
