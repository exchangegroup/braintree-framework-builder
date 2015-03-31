# Using Braintree iOS SDK without Cocoa Pods

This guides shows how to build a `Braintree.framework` file from Braintree iOS SDK sources.
It is done to integrate Braintree SDK into an iOS project without using CocoaPods.

### Create new Application project

1. File > New > Project > Application > Single View Application.
1. Set "BraintreeFrameworkBuilder" as "Product Name". No other name will work with this tutorial.
1. Set Objective-C as language.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/00_create_builder_project.png' alt='Create Braintree framework builder project' >

### Create Cocoa Touch Framework the target

1.  File > New > Target > Framework & Library > Cocoa Touch Framework.
1. Use "Braintree" as "Product Name". No other name will work.
1. Use Objective-C as "Language".

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/001_createBraintree_target.png' alt='Add braintree target' >

### Add braintree source code files to target

1. Remove the automatically generated `Braintree.h` file from the "Braintree" group in project navigator. Select "Move to trash" for it.
1. Clone braintree_ios repository to some separate directory:

```
git clone https://github.com/braintree/braintree_ios.git
```

Those files are temporary so you can clone it into the Downloads or Documents directory, for example.

Drag the **contents** of braintree_ios/Braintree/ directory you just cloned into the Braintree group in Xcode. Important: drag not the "Braintree" directory, but all the files and folders from it. Your project navigator will look like this:

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/01_braintree_target_group_structure.png' alt='braintree target structure in project navigator' >

Paste the following code into Braintree.h after `#import <UIKit/UIKit.h>` line.

```
FOUNDATION_EXPORT double BraintreeVersionNumber;
FOUNDATION_EXPORT const unsigned char BraintreeVersionString[];
```

### Setup Braintree target

1. Add "MessageUI" and "MobileCoreServices" frameworks into "Braintree" target > "Build Phases" > "Link Binary With Libraries" .
1. Add `-ObjC` into "Braintree" target > "Build Phases" > "Other Linker Flags".

### Using BraintreeSDK in View Controller

Let’s try using BraintreeSDK in View Controller.

1. Add `#import <Braintree/Braintree.h>`. to the top of `ViewController.m`.
1. Build the project. You will see `'Braintree/Braintree.h' file not found` error.

### Making headers public

We need to make some header files in the Braintree framework public.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/02_make_header_public.png' alt='Change header to public in Xcode' >

1. Change "Target Membership" of Braintree.h to "public".
1. Build again. You will see a new error: `'Braintree/Braintree-API.h' file not found`. Find `Braintree-API.h` file and make it "public".
I use Command-Shift-O shortcut in Xcode to find files quickly.
1. Now build again. You will see `File not found` error message for yet another file. Find the file and make it "public"
1. Repeat "Build > Find > Make public" steps until there are no more errors.
1. You will also see the following errors `Include of non-modular header inside framework module …`, make those files "public" as well.
1. I went through 33 header files in total, the work took about 10 minutes.

### Add scripts for building Braintree framework

1. Create `scripts` directory in your project root.
1. Add two script files to `scripts` directory: [build_framework.sh](https://github.com/exchangegroup/braintree-framework-builder/raw/master/scripts/build_framework.sh) and
[common.sh](https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/scripts/common.sh).
1. Add 'execute' permissions to those two scripts.

### Build

1. Run `build_framework.sh` script. It will build a universal framework, a Debug version. When build finishes
it will open a Finder containing `Braintree.framework` file. In addition to code the framework
file contains two bundles with localization strings.
1. If you have problem building it, check `PROJECT_NAME=BraintreeFrameworkBuilder` line in `build_framework.sh`. It needs to be the  name of the project.

### Add Braintree.framework to your app

Finally, you can use the `Braintree.framework` file in your app.

1. In your app, select its target, "General" tab and look for "Embedded Binaries" section.
1. Drag the `Braintree.framework` file you built in previous step into "Embedded Binaries".

### Check if Braintree SDK is working in your app

1. Add `#import <Braintree/Braintree.h>` into your view controller.
1. Call a Braintree method in your view controller, like this: `Braintree *braintree = [Braintree braintreeWithClientToken: @"my token"];`

The app will crash with an error message from Braintree: "BTClient could not initialize because the provided clientToken was invalid". That means our integration is working correctly.

## Reference

* "Building Modern Frameworks" WWDC 2014 video: https://developer.apple.com/videos/wwdc/2014/#416

* Xcode 6 iOS Creating a Cocoa Touch Framework: http://stackoverflow.com/a/26691080/297131

* Creating a static library in iOS tutorial: http://www.raywenderlich.com/41377/creating-a-static-library-in-ios-tutorial

* Script for building combining iphoneos and iphonesimulator schemes and combining them into a universal framework: https://gist.github.com/cconway25/7ff167c6f98da33c5352






