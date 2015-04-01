# Using Braintree iOS SDK without Cocoa Pods

This guide shows how to build a Braintree framework from Braintree iOS SDK sources. We will be able to install Braintree SDK to any iOS app just by dragging the `Braintree.framework` into the project. This method works on iOS 7 and 8 in Objective-C and Swift apps. 

### Create new Application project

First, we need to create a project that will be used to build the Braintree framework.

* File > New > Project > Application > Single View Application.
* Set "BraintreeFrameworkBuilder" as "Product Name". No other name will work with this tutorial.
* Set Objective-C as language.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/00_create_builder_project.png' alt='Create Braintree framework builder project' >

### Create Cocoa Touch Framework the target

* File > New > Target > Framework & Library > Cocoa Touch Framework.
* Use "Braintree" as "Product Name". No other name will work.
* Use Objective-C as "Language".

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/001_createBraintree_target.png' alt='Add braintree target' >

### Add braintree source code files to target

* Remove the automatically generated `Braintree.h` file from the "Braintree" group in project navigator. Select "Move to trash" for it.
* Clone braintree_ios repository to some separate directory:

```
git clone https://github.com/braintree/braintree_ios.git
```

Those files are temporary so you can clone it into the Downloads or Documents directory, for example.

* Drag the **contents** of braintree_ios/Braintree/ directory you just cloned into the Braintree group in Xcode. Important: drag not the "braintree_ios/Braintree/" directory, but all the files and folders from it. Your project navigator will look like this:

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/01_braintree_target_group_structure.png' alt='braintree target structure in project navigator' >

* Paste the following code into `Braintree.h` file after `#import <UIKit/UIKit.h>` line.

```
FOUNDATION_EXPORT double BraintreeVersionNumber;
FOUNDATION_EXPORT const unsigned char BraintreeVersionString[];
```

You `Braintree.h` file will look like this:

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/03_export_framework_version.png' alt='Export braintree framework version' >

### Setup Braintree target

* Add "MessageUI" and "MobileCoreServices" frameworks into "Braintree" target > "Build Phases" > "Link Binary With Libraries".

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/04_link_binary_with_libraries.png' alt='Link binary with libraries' >

* Add `-ObjC` into "Braintree" target > "Build Phases" > "Other Linker Flags".

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/05_add_linker_flag.png' alt='Add linker flag' >

### Set iOS deployment target version

Set a lower iOS deployment target version if you want to use the Braintree framework in an app that supports earlier versions of iOS. I set it to version 7.0.

* Use lower iOS version in Project settings > Info > iOS Deployment Target.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/09_ios_deployment_target.png' sec='Set iOS deployment target version' >

### Using BraintreeSDK in View Controller

Let’s try using BraintreeSDK in View Controller.

* Add `#import <Braintree/Braintree.h>` to your `ViewController.m`.
* Build the project. You will see `'Braintree/Braintree.h' file not found` error.

### Making headers public

We need to make some header files in the Braintree framework public.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/02_make_header_public.png' alt='Change header to public in Xcode' >

* Change "Target Membership" of Braintree.h to "public".
* Build again. You will see a new error: `'Braintree/Braintree-API.h' file not found`. Find `Braintree-API.h` file and make it "public".
I use `Command-Shift-o` shortcut in Xcode to find files quickly.
* Now build again. You will see `File not found` error message for yet another file. Find the file and make it "public"
* Repeat "Build > Find > Make public" steps until there are no more errors.
* In addition to `File not found` error you will also see `Include of non-modular header inside framework module …` errors. Make those complaining files "public" as well.
1. I went through 33 header files in total, the work took about 10 minutes.

### Add scripts for building Braintree framework

* Create `scripts` directory in your project root. I do it from a Terminal.

```
cd <your BraintreeFrameworkBuilder project directory>
mkdir scripts
```

* Add two script files to `scripts` directory: [build_framework.sh](https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/scripts/build_framework.sh) and
[common.sh](https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/scripts/common.sh).

```
cd scripts
curl -O https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/scripts/build_framework.sh
curl -O https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/scripts/common.sh
```

Your scripts directory will look like this in relation to your project directory:

<img src='https://github.com/exchangegroup/braintree-framework-builder/blob/master/graphics/06_scripts.png' alt='Scripts in project directory' >

* Add 'execute' permissions to those two scripts.

```
chmod 764 build_framework.sh
chmod 764 common.sh
```

### Build

* Run `build_framework.sh` script from the Terminal:

```
./build_framework.sh
```

It will build a universal framework into "mybuild/Braintree.framework". When build finishes
it opens a Finder containing `Braintree.framework` file.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/07_build_finished.png' alt='Finished building the framework' >


In addition to code the framework contains two bundles with localization strings. That's where frameworks are handy - they can contain resources.

If you have problem building the framework, check `PROJECT_NAME=BraintreeFrameworkBuilder` line in `build_framework.sh`. It needs to be the name of your project.

### Add `Braintree.framework` to your app

Finally! You can use the `Braintree.framework` file in your app.

* In your app, select its target, "General" tab and look for "Embedded Binaries" section.
* Drag the `Braintree.framework` file you built in previous step into "Embedded Binaries".

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/08_drag_framework.png' alt='Drag braintree framework to Embedded Binaries' >

### Use Braintree SDK in an Objective-C app

* Add `#import <Braintree/Braintree.h>` into your view controller.
* Instantiate a Braintree object in your view controller: `[[Braintree alloc] init];`.

My View Controller code looked like that:

```Objective-C
#import "ViewController.h"
#import <Braintree/Braintree.h>

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[Braintree alloc] init];
}

@end
```

* Run the app. If it runs it means that our Braintree SDK integration is working correctly.

### Use Braintree SDK in a Swift app

To use Braintree SDK in a Swift app you will need to import its header in a bridging header.

* To create a bridging header, select File > New > Source > Objective-C File. Name it anything you want, it will be a temporary file.
* Click "Yes" in the next dialog that asks if you would like to configure a bridging header.

<img src='https://raw.githubusercontent.com/exchangegroup/braintree-framework-builder/master/graphics/10_add_bridging_header.png' alt='Configure bridging header dialog' >

* Xcode will create a header file with a similar name, like `MyApp-Bridging-Header.h`.

* Import Braintree in your bridging header file:

```
#import <Braintree/Braintree.h>
```

* Instantiate a `Braintree` object in your view controller to check that it's working.


```Swift
import UIKit

class ViewController: UIViewController {
  var braintree: Braintree?

  override func viewDidLoad() {
    super.viewDidLoad()

    braintree = Braintree()
  }
}
```

* Run the app to check if it's working.

### Job's done!

We have built the Braintree.framework. This is what I think is good about it:

* We can now use Braintree in any Swift or Objective-C iOS app by just dragging the `Braintree.framework` file into "Embedded Binaries" section.
* Your app will build quickly because Braintree source files have been already built into the framework.

## Reference

These are the materials I used to make this guide.

* "Building Modern Frameworks" WWDC 2014 video: https://developer.apple.com/videos/wwdc/2014/#416

* Xcode 6 iOS Creating a Cocoa Touch Framework: http://stackoverflow.com/a/26691080/297131

* Creating a static library in iOS tutorial: http://www.raywenderlich.com/41377/creating-a-static-library-in-ios-tutorial

* Script for building combining iphoneos and iphonesimulator schemes and combining them into a universal framework: https://gist.github.com/cconway25/7ff167c6f98da33c5352






