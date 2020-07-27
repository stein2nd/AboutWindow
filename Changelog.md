# DCOAboutWindow Changelog
## v0.4.0
* Fix typo in preprocessor delegate method name.
* Implement alternative for deprecation.

## v0.3.1
* Make version string selectable.

## v0.3.0
* Support for Carthage added by [@hankinsoft](https://github.com/hankinsoft).
* Support for Dark Mode added by [@balthisar](https://github.com/balthisar).

## v0.2.0
* Optionally display acknowledgments inside the window, instead of through an external editor.

Set `useTextViewForAcknowledgments` to `YES` to enable this feature.

* Improve Auto Layout constrains. The image view now remains the same width, while the text fields can become wider.

## v0.1.0
* Improved localization support
* Improved auto-layout constraints to handle resizing better

You can toggle (off by default) resizing by setting the `NSWindow`'s `styleMask`. Check out the [example project](https://github.com/DangerCove/DCOAboutWindowExample) to see how this works.

## v0.0.2
* Switched to using 'Acknowledgments' instead of 'Acknowledg_e_ments' to be more consistent and prevent incompatibility with [Acknowledge](https://github.com/DangerCove/Acknowledge). **NOTE:** Make sure you change the filename of your acknowledgments and any setters/getters.

## v0.0.1
* Initial release.
