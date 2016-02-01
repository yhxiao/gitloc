# LocationKit iOS
## The most advanced location manager

[Homepage](https://locationkit.io) | [Community](https://community.locationkit.io) | [Documentation](https://docs.locationkit.io) | [Blog](https://locationkit.io/blog) | [FAQs](https://locationkit.io/developer/faqs-for-android-ios-developers-location-accuracy/) | [Pricing](https://locationkit.io/pricing/) | [Developer Dashboard](https://dashboard.locationkit.io)

[![LocationKit-iOS](https://img.shields.io/badge/LocationKit-iOS-orange.svg)](https://docs.locationkit.io) [![CocoaPods](https://img.shields.io/cocoapods/v/LocationKit.svg?style=flat-square)](https://cocoapods.org/pods/LocationKit) [![CocoaPods](https://img.shields.io/cocoapods/p/LocationKit.svg?style=flat-square)](https://cocoapods.org/pods/LocationKit)

This is the public repo for LocationKit for iOS.

LocationKit is the most advanced location manager available today, created by
SocialRadar after years of extensive research into location services on mobile
devices. It is free (as in beer) and rich in functionality.

We do offer [paid tiers](https://locationkit.io/pricing) for more detailed
analytics, custom reporting, and other advanced features, but all features of
our base SDK and lowest tier of analytics will be free always.

LocationKit features:

* Always-on background location
* Higher accuracy location than either Apple or Google's raw location services
* Lower battery drain than running the GPS all the time on high while getting
  nearly the same accuracy
* Contextual location data
* Automatic venue recognition
* Best of breed location analytics dashboard

For more details on the above, see [our Blog](https://locationkit.io/blog), [our
website](https://locationkit.io), or our [full documentation](https://docs.locationkit.io)

To get started, sign up for a
[free developer account](https://dashboard.locationkit.io) and get your API token
immediately!

### Getting Help

[Click here](https://docs.locationkit.io/#getting-help) for a whole list of
resources on getting help with LocationKit.

### CocoaPods

Install the latest [LocationKit CocoaPod](https://cocoapods.org/pods/LocationKit)
by adding the following to your Podfile:

```ruby
pod 'LocationKit', '~> 3.0'
```

#### Full step-by-step instructions:

If you already have an existing project set up with CocoaPods, skip to step 3 below:

1. If you don't yet have CocoaPods installed, run `gem install cocoapods`
1. Then, from your project root, run `pod init` to get started with CocoaPods.
   That'll create a `Podfile` in your project directory
1. Edit it and add `pod 'LocationKit', '~> 3.0'` to that Podfile, making sure
   LocationKit is included for your intended target.
1. If you have specified a platfrom (e.g. `platform :ios, '8.0'`), make sure
   you specify iOS 8.0 or greater. LocationKit is provided as a Dynamic
   Framework and as a result is only compatible with iOS 8.0 and above.
1. Add the `use_frameworks!` flag to your `Podfile`

For a full example, below a full example Podfile:

```ruby
# Your app's Podfile

platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
    pod 'LocationKit', '~> 3.0'
end
```

### Carthage

If you're just getting started with Carthage, check out their
[getting started guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios).

Add the following to your `Cartfile`:

```
github "LocationKit/locationkit-ios" ~> 3.0
```

### Manual Installation

We generally recommend CocoaPods or Carthage for installing LocationKit as they
are both far easier to update to the latest version, but we understand it can be
difficult to retrofit an existing project so we also provide LocationKit as a
.Framework for manual integration.

1. Download the latest [LocationKit .framework](/releases)
2. Unzip it and you should have `LocationKit.framework`
3. In your Project Settings, under General, scroll down to "Linked Frameworks
   and Libraries" and hit the Plus button
4. Click the "Add Other..." button and pick `LocationKit.framework` from the
   place where you unzipped it
5. Hit the plus button again and add `CoreLocation.framework`, `MapKit.framework`
   and `SystemConfiguration.framework`
6. Under Build Settings > Linking > Other Linker Flags add `-ObjC`

*Swift Only*
You'll need to add an Objective-C Bridging Header to use LocationKit in a Swift
project since it's written in Objective-C.

1. Add a new File to your project, it will be an Objective-C file and it will be
   a header file. Give it a name like "<YourProjectName>-Bridging-Header.h"
2. In that file, add one line: `#import <LocationKit/LocationKit.h>`
3. Under "Build Settings > Swift Compiler - Code Generation > Objective-C Bridging
   Header" add a value of "<YourProjectName>/<YourProjectName>-Bridging-Header.h"

### Cordova

See [github.com/socialradar/Cordova-LocationKit](https://github.com/socialradar/Cordova-LocationKit) for more details.

### Proudly engineered in Washington, D.C.
