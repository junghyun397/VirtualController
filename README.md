# VirtualController

🕹 Customizable Virtual Flight-Throttle/Controller; **VFT**: **V**FT **F**light **T**hrottle.

❤️ Built with [Flutter](https://github.com/flutter/flutter)(Moblie App) and Python(Device Server).

![all_in_one](https://user-images.githubusercontent.com/32453112/74083264-58513e00-4aa5-11ea-9a04-3be17603bb64.gif)

## Main Features

- Supports **all games** that support joystick input
- Support **WIFI**, **USB Serial**(WIP), **Bluetooth**(WIP) for connecting Mobile App with Device Server
- Places and **customize** components to [configure panel](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#eng-help-how-to-place-and-modify-components-to-build-panel)
- Provides 5 components
  - [Slider](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#slider)
  - [Button](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#button)
  - [Toggle Button](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#toggle-button)
  - [Toggle Switch](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#toggle-switch)
  - [Hat Switch](https://github.com/junghyun397/VirtualController/wiki/HELP:-how-to-place-and-modify-components-to-build-panel#hat-switch)
- **Simple** usage and [manuals](https://github.com/junghyun397/VirtualController/wiki)

## Getting started

### Install VFT

Currently, this project only support Android and Windows. Please download the Mobile App from the [release page](https://github.com/junghyun397/VirtualController/releases) or [Google Play](https://play.google.com/store/apps/details?id=com.junghyun397.dev.virtual_flight_throttle) and [download]((https://github.com/junghyun397/VirtualController/releases)) and execution Device Server. A complete installation course [tutorial](https://github.com/junghyun397/VirtualController/wiki/STEP-BY-STEP:-how-to-install-VFT-Flight-Throttle) is available.

### Build and Run with flutter

#### Build App for your device
```sh
# 1. get pub package dependencies
flutter pub get

# 2. generate l10n support Strings
flutter pub global run intl_utils:generate

# 3. run app in your device with flutter! 
flutter run
```

#### Build Device Server for Windows
```sh
# 1. install requirement pip packages
pip install -r requirements.txt

# 2. build stand-alone deice server with cx-freeze
python windows_freeze_setup.py build

# 2.1. or build mono msi file.
python windows_freeze_setup.py bdist_msi
``` 
