# Reatfulness Flutter

Sample application for Restfulness API calling in flutter

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
And if your are using Andriod Studio go to __pubspec.yaml__ file and click on __Pub get__. after that you're good to go!
## Usage
Make sure you are implemented [Restfulness-core-api](https://github.com/Restfulness/Restfulness-core-api) and the server is running, then go to __main.dart__ and change __AppConfig__. if your server not running on localhost change __apiBaseUrl__ to your server IP
```dart
 var configuredApp = new AppConfig(
   appName: 'Restfulness Dev',
   build: 'development',
   apiBaseUrl: 'http://localhost:5000',
   child: App(),
  );
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
