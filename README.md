# Using Braintree iOS SDK without Cocoa Pods

This guides shows how to build a `Braintree.framework` file from Braintree iOS SDK sources.
It is done to integrate Braintree SDK into an iOS project without using CocoaPods.

### Create new Application project

1. File > New > Project > Application > Single View Application.
1. Set "BraintreeFrameworkBuilder" as "Product Name" and Objective-C as language.

### Create Cocoa Touch Framework target

1.  File > New Target > Framework & Library > Cocoa Touch Framework.
1. Use "Braintree" as "Product Name". No other name will work.
1. Use Objective-C as "Language".

### Add braintree source code files to target

1. Remove the automatically generated `Braintree.h` file from the "Braintree" group in project navigator. Select "Move to trash" for it.
1. Clone braintree_ios repository to some separate directory: `git clone https://github.com/braintree/braintree_ios.git`
1. Drag the **contents** of braintree_ios/Braintree/ directory you just cloned into the Braintree group in Xcode. Important: drag not the "Braintree" directory, but all the files and folders from it. Your project navigatin will look like this:

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

### Add scripts for building framework.

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

### Check if it's working

1. Add `#import <Braintree/Braintree.h>` into your view controller.
1. Call a Braintree method in your view controller, like this: `Braintree *braintree = [Braintree braintreeWithClientToken: @"my token"];`

The app will crash with an error message from Braintree: "BTClient could not initialize because the provided clientToken was invalid". That means our integration is working correctly.






