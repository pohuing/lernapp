# lernapp

Dieses Projekt ist in [Flutter](https://flutter.dev/) gebaut. Und verwendet für widget-übergreifenden State
das [Bloc/Cubit pattern](https://bloclibrary.dev/#/gettingstarted).

Die Lernapp funktioniert auf Android, iOS, Windows und MacOS vollständig. Im Web gibt es ein paar
Einschränkungen [wie fehlende Transparenz beim Zeichnen in manchen Browsern](https://github.com/flutter/flutter/issues/48417).

## Build

Flutter benötigt die [flutter sdk](https://docs.flutter.dev/get-started/install) zum Erstellen der Anwendung. Je nach
Zielplattform werden noch zusätzliche Abhängigkeiten benötigt(MSVC für Windows builds, Android studio für Android
builds, XCode für iOS etc.).

Abgesehen davon wird nichts extra benötigt und die Anwendung kann für eine Zielplattform mit\
``flutter run``\
ausgeführt werden.

Ausführbare Anwendungsarchive können ebenfalls erstellt werden, Beispiele dafür können `.gitlab-ci.yml` entnommen
werden.

## Tests

Unit tests können einfach mit `flutter test` ausgeführt werden.

Integration Tests mit
``flutter drive flutter drive --driver=test/test_driver/integration_test.dart --target=test/integration_test/*test_name_hier*_test.dart --no-dds``.

Diese werden am besten auf dem Zielgerät ausgeführt, `flutter devices` gibt eine Liste an möglichen Zielplattformen aus.
Mit `flutter test ... -d <ziel>` kann das Ziel für tests angegeben werden.

Performance tests sollten zusätzlich mit `--profile` ausgeführt werden. Profiling Informationen werden in `build`
abgelegt und können im Chrome/Edge tracer oder mit [Perfetto](https://ui.perfetto.dev/) analysiert werden.

## Automatisches deployment von web artefakten

Die gitlab ci builds deployen von selbst auf einen per ssh erreichbaren Server, dafür sind drei Variablen in der
Projektkonfiguration notwendig:

- $DeployHost: The url or ip to feed into scp for deployment
- $DeployKey: A *file* type variable with the private key used to authenticate against the server
- $DeployUser: Username of the user to authenticate as on the server

Der deploy Befehl kopiert die web Dateien nach /var/www/html/lernapp, das Verzeichnis muss also fur $DeployUser
schreibbar sein

Des Weiteren lässt sich das Branding anpassen.
In [lib/generated/application_information/about_contents.dart](lib/generated/application_information/about_contents.dart)
lassen sich Versionsnummer und ein Hinweis in applicationLegalese ändern. Das Logo ist unter [images/logo](images/logo)
austauschbar.
Diese Werte werden alle in der Gitlab Ci in der `before_script` Stage durch Variablen ersetzt.