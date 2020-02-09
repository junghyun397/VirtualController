# VirtualThrottle

🕹 Customizable Virtual Flight-Throttle/Controller; **VFT**: **V**FT **F**light **T**hrottle.

❤️ Built with [Flutter](https://github.com/flutter/flutter)(Moblie App) and Python(Device Server).

![all_in_one](https://user-images.githubusercontent.com/32453112/74083264-58513e00-4aa5-11ea-9a04-3be17603bb64.gif)

# Main Features

- Supports **all games** that support joystick input
- Support **WIFI**, **USB Serial**(WIP), **Bluetooth**(WIP) for connecting Mobile App with Device Server
- Places and **customize** components to [configure panels](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#eng-help-how-to-place-and-modify-components-to-build-panel)
- Provides 5 components
  - [Slider](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#slider)
  - [Button](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#button)
  - [Toggle Button](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#toggle-button)
  - [Toggle Switch](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#toggle-switch)
  - [Hat Switch](https://github.com/junghyun397/VirtualThrottle/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#hat-switch)
- **Simple** usage and [manual](https://github.com/junghyun397/VirtualThrottle/wiki)

# Install VFT

Currently, this project only support Android and Windows. Please download the Mobile App from the [release page](https://github.com/junghyun397/VirtualThrottle/releases) or [Google Play](http://cloud.do1ph.in) and [download]((https://github.com/junghyun397/VirtualThrottle/releases)) and execution Device Server. A complete installation course [tutorial](https://github.com/junghyun397/VirtualThrottle/wiki/STEP-BY-STEP:-how-to-install-VFT-Flight-Throttle) is available.

# Build and Run with flutter
```sh
# get pub package dependencies
flutter pub get

# generate l10n support Strings
flutter pub global run intl_utils:generate

# run app in your device with flutter! 
flutter run
```