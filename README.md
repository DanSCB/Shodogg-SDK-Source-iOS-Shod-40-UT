Shodogg SDK Source - iOS
================
This is the iOS source code for the Shodogg SDK that clients use in their apps to discover devices and launch apps.

A first step after downloading this source code is running 'pod install' from the ShodoggMIDKit folder.

DO NOT MERGE THIS CODE WITH THE CLIENT CODE!

Only the generated library / framework should be included in the client project.

Unit Tests: The SDK source code does not run on the Xcode device simulators (this seems to be something internal to the LGConnect SDK). Unit tests, properly, are meant to run on the simulator. Therefore, in order to allow unit tests to work, a minimal device user interface was created for them, built from the same start view controller used in the diagnostic app.

-----

Documentation for this SDK currently resides at [here](https://shodogg.atlassian.net/wiki/display/UBE/Device+Discovery)
