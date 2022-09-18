# mobile_test_flutter

Lists all messages and their details from JSONPlaceholder

## Dependencies

[flutter_bloc](https://pub.dev/packages/flutter_bloc)  Library that allows the management of states in a simple and well-structured way
[equatable](https://pub.dev/packages/equatable)  Library that allows the comparison of objects in a customized way without the need to add or overwrite code. It is also essential when using bloc
[dio](https://pub.dev/packages/dio)  Library that facilitates and allows http queries
[connectivity_plus](https://pub.dev/packages/connectivity_plus)  Very important library to detect network changes and manage eventual connectivity through a stream.
[sqflite](https://pub.dev/packages/sqflite) Library that allows to interact with the local database of the mobile device

## Architecture
The architecture manages 4 layers, UI, Bloc/Cubits, Repository and Data Provider. Each layer has a fundamental role. UI, is only in charge of displaying the information and listening to the changes of the Bloc/Cubits. Bloc/Cubit, is in charge of the logical presentation of the information obtained from the Repository. Repository, manages the multiple resources from which the information can be obtained. Data Providers, can be an API or a DB.

![Bloc pattern](https://i.imgur.com/M0RLHiN.png)

This architecture is very similar to the well-known Model-View-ViewModel architecture.

## Installation
To build the final application, you must have the flutter sdk installed, as well as the android sdk. Finally you must execute the command `flutter build apk`. This command will generate an .apk file that will allow you to install the application on an android device. This file can be installed on an emulator or a cell phone using the following command `adb install <path-to-apk>`.

