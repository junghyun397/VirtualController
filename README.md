# VirtualThrottle

🕹 Customizable Virtual Flight-Throttle/Controller; **VFT**: **V**FT **F**light **T**hrottle.

❤️ Built with [Flutter](https://github.com/flutter/flutter)(Moblie App) and Python(Device Server).

![panel](https://user-images.githubusercontent.com/32453112/74082809-04dcf100-4aa1-11ea-96a1-7d76846a1b8f.png)

# Main Features

- Supports **all games** that support joystick input
- Places and **customize** components to configure panels
    ![build_panel](https://user-images.githubusercontent.com/32453112/74082756-9435d480-4aa0-11ea-9cc3-682f4910f13d.gif)
- Provides 5 components
  - Slider

    ![component_slider](https://user-images.githubusercontent.com/32453112/74082760-96982e80-4aa0-11ea-890b-7aac9f20ffcd.gif)
  - Button
  
    ![component_button](https://user-images.githubusercontent.com/32453112/74082758-95ff9800-4aa0-11ea-9b69-6a70b634e473.gif)
  - Toggle Button
  
    ![component_toggle](https://user-images.githubusercontent.com/32453112/74082762-9730c500-4aa0-11ea-9ef0-c50618d494d4.gif)
  - Toggle Switch

    ![component_switch](https://user-images.githubusercontent.com/32453112/74082761-9730c500-4aa0-11ea-91c7-6aa2bfad9c88.gif)
  - Hat Switch
  
    ![component_hat](https://user-images.githubusercontent.com/32453112/74082759-95ff9800-4aa0-11ea-877d-3ce28ff5c805.gif)
- **Simple** usage and manuals

# Install VFT

Currently, this project only support Android and Windows. Please download the app from the [release page](https://github.com/junghyun397/VirtualThrottle/releases) or [Google Play](http://cloud.do1ph.in). A complete installation course [tutorial](https://github.com/junghyun397/VirtualThrottle/wiki/STEP-BY-STEP:-how-to-install-VFT-Flight-Throttle) is available.

# Build and Run with flutter
```sh
# get pub package dependencies
flutter pub get

# generate l10n support Strings
flutter pub global run intl_utils:generate

# run app in your device with flutter! 
flutter run
```