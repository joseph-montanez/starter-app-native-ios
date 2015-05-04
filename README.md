[![travis build](https://api.travis-ci.org/joseph-montanez/starter-app-native-ios.png)](https://travis-ci.org/joseph-montanez/starter-app-native-ios) 
[![Code Climate](https://codeclimate.com/github/joseph-montanez/starter-app-native-ios/badges/gpa.svg)](https://codeclimate.com/github/joseph-montanez/starter-app-native-ios)

# Starter App

A basic intro, login, facebook login, registration, and chat system. Currently this project only supports iOS 8 and is a Swift project.

## Getting Started

This project is packaged together with [CocoaPods](https://cocoapods.org), so you will need to install that before you can began with this starter application.

### How to Install CocoaPods

As a note if you have the beta version of CocoaPods, please update before attempting. Swift is a recent addition to CocoaPods, and there has been new releases and bug fixes recently.

	sudo gem install cocoapods
	
### How to Update CocoaPods

	sudo gem update cocoapods
	
## How to Set Up The Project

After Cocoapods is installed, you can then run the CocoaPods setup.

	pod install
	
Once the command is ran several lines of text will show up in your terminal i.e

	Analyzing dependencies
	Downloading dependencies
	Using Dollar (2.1.1)
	Using OMGHTTPURLRQ (2.1)
	Using PromiseKit (1.4.2)
	Using Realm (0.91.1)
	Generating Pods project
	Integrating client project
	
After that has finished its process a new file is created, **Starter App.xcworkspace**. This is the file you want to open in XCode.

## Project Structure

The goal of this project is to get you on the right track and apart of that is knowing where to put logic and where to put files.

 - **Services**: This folder is for replacement logic needed for testing, or replacing logic. For example, all Http requests have its own service that be swapped out for testing this way we don't need a REST server for testing. Also this lets you swap out libraries, for example this project uses AlamoFire for HTTP requests, but wrapping this into a service we can now change out AlamoFire for another library if needed. This type of development is known as dependency injection or DI for short.
 - **UI**: This folder is to support reusable UI elements, this can be further organized to have more sub folders for say buttons versus views.
 - **Segues**: This folder is for custom screen transitions, which for iOS is called *segues* (/ˈseɡwā,ˈsā-/).
 - **Api**: This folder is to support the backend REST API. The only job these classes should is take the bare minimum data, send it to the *Http Service*, and relay that back. Logic to deal with how the data is organized should be kepted out of these classes. There should be zero logic on dealing with the response.
 - **Tasks**: This folder is to support task based / async work. A task can a few results, such as success and failure methods. A task can also be continued, paused, and emit progress. This is a really powerful concept to learn and can help facilitate concepts like Promises, or Futures. The point of this is to avoid callback hell since much of this is asynchronous, but also present it in a synchronous way. Here is an example:
 
        let task = LocalStorageTask()
        //-- Get storage from disk
        task.getStorage()
            //-- See if there is a UUID assigned
            .then(task.checkUUID)
            //-- Check if there is a token
            .then(task.getToken)
            //-- Check to see if token is authorized
            .then(task.isAuthorized)    
 In that example, the application is going to disk, then network and validating information long the way. The end result is to get a pure object that I can then use. At this point as a programmer wanting to consume the object I can do the following:
 
            //-- Check to see if token is authorized
            .then(task.isAuthorized)
            .success { storage -> LocalStorage in
            	//... my logic here
            }
            .failure { (error: NSError?, isCancelled: Bool) -> LocalStorage in
            	//... my logic here
            }
- **Models**: This folder is for classes / object to saved to disk for now... This is suppose to be simplified objects, but logic like validation, remote requests such as HTTP request might leak into here. *However* when it comes to validation, there is a big difference from validating a form of a ViewController, and validating data added to the model. Here is a good example to grasp, if you are implementing permissions, these permissions should not be in the model, of lets say a shopping list model, but in the ViewController or respective place.
- **Utils**: This folder is just for helper functions used around the application.
- **Controllers**: This folder is for ViewControllers used in iOS.
- **ViewModels**: This folder is to compliment ViewController's state. The way to think about this is, your ViewController should handle events, startup, shutdown, resume, but it should not handle how the data effects a model. So the way to understand a view model, is to separate data, from the controller. If you have a text field, that value is stored in the UI, then it needs to be separated into the view state. So the ViewController will handle sending the data from and to the view model to update the UI. By keeping these concepts apart you can then safely implement stateful ViewControllers. It falls into play when you need to the state of a ViewController and save it to disk, so if your application does to background and then gets destroyed, you can recover with the last informaiton. 

## Suggested Software

On OSX there are various tools to help create iOS Applications. Here is a list that I suggest:

 - Gimp - General Graphics Editor
 - Inkscape - Vector Editor
 - Mou - Markdown Editor
 - Prepo - Icon and Artist resizer for iOS
 - Cyberduck - SFTP/FTP/S3/Google Drive Software
 - Shuttle - Manage SSH
 