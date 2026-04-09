# NOYA

NOYA is a mobile app that help you keep track of your personal finances. Unlike other similar apps, it does not access your bank accounts neither your credit card invoice, relying only on your discipline of register every transactoin. This approach may be more cumbersome, but it preserve a precious thing these days: your privacy. Thereby, the goal of NOYA is to provide tools to assist you to make this routine a little easier, in addition to allow you to analyse your financial income and outcome.

To reinforce the attention regarding the user's privacy, the creator of NOYA app, Fabiano Oliveira, determined that the software is open-source. Thus, in case of any doubts of what NOYA is doing with your data, you (or some programmer of your trust) can check the source code to make sure of it. You are also free to clone the project and use the source code according to the terms of the [license](LICENSE.md).

NOYA is also free-to-use, with no ads inside the app. The creator Fabiano Oliveira built it to his personal use and, imagining that other people may face similar needs, turn the app public. If you want to report a bug or suggest an improvement, feel free to create an issue [clicking here](https://gitlab.com/fabianoww/noya/-/issues). However, please note that this project is supported, at this moment, by a single person on his free time. Thus, it may take a while to answer those issues. If this app help you in any way and you want to show your gratitude, you can by me a coffe through the button below:

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
git clone git@gitlab.com:fabianoww/noya.git
```
or HTTPS:
```
git clone https://gitlab.com/fabianoww/noya.git
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

### Generate the app laucher icon

Place the image assets on the following folder:
```
assets\launcher
```

**Important note:** Keep the same file names and image resolution.

Generate the launcher icons through the command below:

```
flutter packages pub run flutter_launcher_icons:main
```

### i18n

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

### Google API

Noya uses Google API to backup data on Google Drive (optionally). In order to use this, you'll need to follow the steps on [this article](https://medium.com/better-programming/the-minimum-guide-for-using-google-drive-api-with-flutter-9207e4cb05ba).

### App signing

In order to be able to use Google Drive, it's required that your app is signed. You'll need to generate a public/private key pair in a keystore file. Then, create the file _[PROJECT_ROOT]\android\key.properties_ with the following content:
```
keyAlias=[YOUR KEY ALIAS]
keyPassword=[YOUR KEY PASSWORD]
storeFile=[YOUR KEYSTORE PATH]
storePassword=[YOUR KEYSTORE PASSWORD]
```

## Support

If you're looking for help, feel free to [open an issue on this project](https://gitlab.com/fabianoww/noya/-/issues/new). It might take a while (since I'm one man army), but I'll do my best! :)

## Authors and acknowledgment
* Fabiano Oliveira - https://fabiano.dev

## License
This open-source project is licensed under [Creative Commons Attribution-NonCommercial 4.0 International Public License](https://creativecommons.org/licenses/by-nc/4.0/legalcode).

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Licença Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a>