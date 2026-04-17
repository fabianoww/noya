# NOYA

[Versão em português](README_pt.md)

NOYA is a mobile app that help you keep track of your personal finances. Unlike other similar apps, it does not access your bank accounts neither your credit card invoice, relying only on your discipline of register every transaction. This approach may be cumbersome, but it preserve a precious aspect these days: your privacy. Thereby, the goal of NOYA is to provide tools to assist you to make this routine a little easier, in addition to allow you to analyse your financial income and outcome.

Still on the privacy subject, the data registered on NOYA app are stored on the local device, on the app private storage area, without sending it to external world without explict request (backup). Furthermore, the creator of NOYA app, Fabiano Oliveira, determined that the software is _open-source_. Thus, in case of any doubts of what NOYA is doing with your data, you (or some programmer of your trust) can check the source code to make sure of it. You are also free to clone the project and use the source code according to the terms of the [license](LICENSE).

NOYA is free-to-use, with no ads inside the app. The creator Fabiano Oliveira built it to his personal use and, imagining that other people may face similar needs, turn the app public. If you want to report a bug or suggest an improvement, feel free to create an issue [clicking here](https://github.com/fabianoww/noya/issues/new). However, please note that this project is supported, at this moment, by a single person on his free time. Thus, it may take a while to answer those issues.

If this app help you in any way and you want to show your gratitude, you can by me a coffe through the button below:

<a href="https://www.buymeacoffee.com/fabianooliveira" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-orange.png" alt="Gostou? Me pague um café!"  style="height: 51px !important;width: 217px !important;" ></a>

## Installation

NOYA is built using [Flutter](https://flutter.dev) toolkit. It's highly recommended that you follow the ["get started" documentation](https://flutter.dev/docs/get-started/install) to setup your development environment.

### Requirements

* Flutter SDK 3.41.6
* Android SDK 36
* Git 2.43 or later
* A mobile device (physical or virtual)

### Cloning the project

Clone the project into your local Git repository using SSH:
```
git clone git@github.com:fabianoww/noya.git
```
or HTTPS:
```
git clone https://github.com/fabianoww/noya.git
```

### Running

To run the app, you'll need an runtime device, wich can be an mobile phone or an virtual device. To list the Android devices available, run the command below:
```
flutter devices
```
If at least one item is shown, you're good to go.

**Important note:** To use an physical mobile phone, you'll need to [enable the USB Debugging](https://developer.android.com/studio/run/device).
```
flutter run
```

## Technical procedures

### Generate the app launcher icon

Place the image assets on the following folder:
```
assets\launcher
```

**Important note:** Keep the same file names and image resolution.

Generate the launcher icons through the command below:

```
flutter packages pub run flutter_launcher_icons:main
```

### Internacionalization (i18n)

The app currently supports the following languages:
* English
* Portuguese

To include a new language, it's highly recommended the use of the [Flutter Intl extension](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) on VSCode. Once this extension is installed, you can open the Command Pallete (Ctrl+3) and type:
```
Flutter Intl: Add locale
```
It will be required the code of the location that you're adding. Then, just edit the corresponding .arb file under the following path:
```
lib\l10n
```
You can use the existing .arb files on this folder as a template.

## Support

If you're looking for help, feel free to [open an issue on this project](https://github.com/fabianoww/noya/issues/new). It might take a while (since I'm one man army), but I'll do my best! 😄

## Authors and acknowledgment
* Fabiano Oliveira - https://fabiano.dev

## License
This open-source project is licensed under [GNU General Public License v3.0](LICENSE).