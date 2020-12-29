# Reatfulness Flutter

Sample application for Restfulness API in flutter

# How to Use
#### Step 1:
Download or clone this repo by using this link:
```bash
git clone https://github.com/Restfulness/Restfulness-flutter-app.git
```
#### Step 2:
Go to project root and execute the following command in console to get the required dependencies:
```bash
flutter pub get 
```
And if your are using Andriod Studio go to __pubspec.yaml__ file and click on __Pub get__. after that, you're good to go!
## Usage
Make sure [Restfulness-core-api](https://github.com/Restfulness/Restfulness-core-api) is running on your infrastructure, then go to __main.dart__ and change __AppConfig__. if your server is not running on localhost change __apiBaseUrl__ to your server IP
```dart
   AppConfig(
      flavor: Flavor.DEV,
      color: Colors.blue,
      values: AppValues(apiBaseUrl: 'http://localhost:5000'));
```
__NOTE:__ In the Login screen you can configure your server address by taping on the __Gear__ icon :gear: on the top right.
## Signing the app
To publish on the Play Store, you need to give your app a digital signature. Use the following instructions to sign your app.
##### Create a keystore
You can create one key by running the following steps.

On Mac/Linux, use the following command:
```
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```
On Windows:
```
keytool -genkey -v -keystore c:\Users\USER_NAME\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
```
change __USER_NAME__ to the desierd one.
##### Reference the keystore from the app
Create a file named __<app dir>/android/key.properties__ that contains a reference to your keystore:
```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
```
##### Configure signing in gradle

Configure signing mode for your app by editing the __<app dir>/android/app/build.gradle__ file.

Go to this line and change __.debug__ to __.release__
```
 buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
```

For more information, you can check this link [Build and release an Android app](https://flutter.dev/docs/deployment/android)
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
