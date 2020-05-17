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

![ezgif-1-84eb6c69519b](https://user-images.githubusercontent.com/5212286/82136852-a8236c00-982f-11ea-8ca8-342835c6dbd9.gif)

![ezgif-1-ccbe5c441ae6](https://user-images.githubusercontent.com/5212286/82136877-0d775d00-9830-11ea-86eb-569d5aa4ed78.gif)

![ezgif-1-7e979e0be398](https://user-images.githubusercontent.com/5212286/82136897-58917000-9830-11ea-939c-8690f0df1c35.gif)


## Persistance 
There are two flows for persistance. Since the data set was small and contained only 10 recent searches, database is not used. The flows are : 
1. Saving data in plist. (PersistanceTask)
2. Saving data in UserDefaults. (WriterTask)

Only one is active at a time. Both of the classes which are responsible for writing data into storage are conforming to Persister protocol, which makes it easy to replace the underlying storage without impacting any other code. For example, 
in class Builder, at line 27 and 40

```
let persitanceTask = PersistanceTask() //WriterTask.shared()
```
if we remove ```PersistanceTask()``` and uncomment ```WriterTask.shared()``` the data storage for furthur requests should change from UserDefaults to plist. 
Note: we are not migrating data between UserDefaults and Plist, if we switch between different persistances storage. 








