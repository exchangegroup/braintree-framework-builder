### Create new Application project

1. File > New > Project > Application > Single View Application
1. Set “Product Name” as “BraintreeFrameworkBuilder” and Objective-C as language.

### Create Cocoa Touch Framework target

1.  File > New Target > Framework & Library > Cocoa Touch Framework.
1. Use “Braintree” as “Product Name”. No other name will work.
1. Use Objective-C as “Language”.

### Add braintree source code files to target

1. Remove `Braintree.h` file from the “Braintree” group in project navigator. Select “Move to trash”.
1. Clone braintree_ios repository to some separate directory: `git clone https://github.com/braintree/braintree_ios.git`
1. Drag the contents of braintree_ios/Braintree/ directory into the Braintree group in Xcode. Important: drag not the “Braintree” directory, but all the files and folders from it. The child groups of “Braintree” group will be “3D-Secure”, “API” etc. “Copy items if needed” is checked. 

1. Paste the following code into Braintree.h after `#import <UIKit/UIKit.h>` line.

```
FOUNDATION_EXPORT double BraintreeVersionNumber;
FOUNDATION_EXPORT const unsigned char BraintreeVersionString[];
```

1. In “Braintree” target, “Build Phases”, “Link Binary With Libraries” add “MessageUI” and “MobileCoreServices” frameworks.

### Using BraintreeSDK in View Controller

Let’s try using BraintreeSDK in View Controller. 

1. Add `#import <Braintree/Braintree.h>`. to the top of `ViewController.m`. 
1. Build the project. You will see `'Braintree/Braintree.h' file not found` error. 

### Making headers public

We need to make some header files in the Braintree framework public.

1. Change “Target Membership” of Braintree.h to “public”.
1. Build again. You will see a new error: `/Users/evgenyneu/code/ios/demo/braintree/BraintreeFrameworkBuilder/Braintree/Braintree.h:7:9: 'Braintree/Braintree-API.h' file not found`. Find `Braintree-API.h` file and make it `Public`.
You can easily find a file by pressing Command-Shift-O.
1. Now build again. You will see `File not found` error message for yet another file. Find the file and make it `Public`
1. Repeat Build > Find > Make Public loop until there are no more errors.
1. You will also see the following errors `Include of non-modular header inside framework module …`, make those files “Public” as well.

### Add scripts for building framework.



I changed 33 files to Public which took me 10 minutes.






