# SearchApp
Search App is a basic image search app which uses image search api from [pixabay.com](pixabay.com) to search and display images, in a collection view with a 2x2 grid. You can select any image, see the full preview in an image view with content mode as aspectFit. User can scroll through the available images (which are fetched currently on the main page.) No api call will be made in detail page.

## How to run the app?
To run this app, you will need to have [cocoapods-keys](https://github.com/orta/cocoapods-keys) plugin installed, it is used to hide the api-key for pixabay.com as its good security practice to keep production keys out of developer hands.

Run this command to install cocoapods-keys. 
```
$ gem install cocoapods-keys
```

Run 

```
pod install
```

it should now ask you to enter the apikey. Pls enter the key provided in email.

### How cocoapods-keys works?

Key names are stored in ~/.cocoapods/keys/ and key values in the OS X keychain. When you run pod install or pod update, an Objective-C class is created with scrambled versions of the keys, making it difficult to just dump the contents of the decrypted binary and extract the keys. At runtime, the keys are unscrambled for use in your app.

The generated Objective-C classes are stored in the Pods/CocoaPodsKeys directory, so if you're checking in your Pods folder, just add Pods/CocoaPodsKeys to your .gitignore file. CocoaPods-Keys supports integration in Swift or Objective-C projects.

You can read more about [Cocoapods-keys here](https://github.com/orta/cocoapods-keys)


## SearchApp 


