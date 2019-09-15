<a href="https://lambdaschool.com/">
    <img src="https://res.cloudinary.com/endrsd/image/upload/v1567546601/lambda_logo_ffimws.png" title="Lambda School Logo" width="200" align="right">
</a>

# The 'ENDRSD' iOS App

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

<p align="center">
    <a href="https://endrsd.com/">
        <img src="https://res.cloudinary.com/endrsd/image/upload/v1568002293/new_logo_ltlpkr.png" alt="New ENDRSD logo" width="400">
    </a>
</p>

<p align="center">
    <img src="v1_1_3_demo.gif" alt="GIF walk-through" width="300">
</p>

## Project Overview

"ENDRSD" is a capstone project that was built as a centralized location for Lambda School students to access track-specific career endorsement requirements, as well as provide students with a fun and engaging way to track their career endorsement progress.

Demo the app by downloading it from TestFlight.

<br>

## Contributors

|                                                                                         [Alex Mata](https://github.com/alexander-frost)                                                                                         |                                                                                      [Sameera Roussi](https://github.com/sameeraleola)                                                                                       |                                                                                        [Victor Ruiz](https://github.com/vicxruiz)                                                                                        |
| :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [<img src="https://media.licdn.com/dms/image/C5603AQHRbpDk-q8wRQ/profile-displayphoto-shrink_800_800/0?e=1571270400&v=beta&t=XbAXxDFqp9HpJcXDp0YdgiuPXrFp7667PY8pg8lOKuA" width = "120" />](https://github.com/alexander-frost) | [<img src="https://media.licdn.com/dms/image/C4E03AQHYAtIXaf1z4Q/profile-displayphoto-shrink_800_800/0?e=1571270400&v=beta&t=HHc-X-kcoeFuu1MTYQHGde9M3aa1WJEVOk-98OfAhEs" width = "120" />](https://github.com/sameeraleola) | [<img src="https://media.licdn.com/dms/image/C4E03AQF02srF_ss_iQ/profile-displayphoto-shrink_800_800/0?e=1571270400&v=beta&t=pBz0Pm1cHfDOdUN6wCq6qYDM8rlrHKaNhwsHn8MFUO0" width = "120" />](https://github.com/vicxruiz) |
|                                                                  [<img src="https://github.com/favicon.ico" width="25"> ](https://github.com/alexander-frost)                                                                   |                                                                  [<img src="https://github.com/favicon.ico" width="25"> ](https://github.com/sameeraleola)                                                                   |                                                                  [<img src="https://github.com/favicon.ico" width="25"> ](https://github.com/vicxruiz)                                                                   |
|                                                 [ <img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="25"> ](https://www.linkedin.com/in/alexandert3977/)                                                 |                                                [ <img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="25"> ](https://www.linkedin.com/in/sameeraroussi/)                                                |                                                [ <img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="25"> ](https://www.linkedin.com/in/vicxruiz/)                                                 |

<br>
<br>

[ENDRSD Trello Board](https://trello.com/b/hKTAKrBD/endrsd)

<p>
    <a href="https://trello.com/b/hKTAKrBD/endrsd">
        <img src="https://res.cloudinary.com/endrsd/image/upload/v1568019708/endrsd_trello_jg6kdd.png" alt="ENDRSD Trello Board" width="500">
    </a>
</p>

[ENDRSD Release Canvas v1.0](https://www.notion.so/ENDRSD-v1-0-3e87edcf085e45dc993422f0668e0842)

<p>
    <a href="https://www.notion.so/ENDRSD-v1-0-3e87edcf085e45dc993422f0668e0842">
        <img src="https://res.cloudinary.com/endrsd/image/upload/v1568019704/release_canvas_1_sm4hdq.png" alt="ENDRSD Notion document release canvas v1.0" width="500">
    </a>
</p>

[UX Design files](https://www.figma.com/file/ZiMbxLkmEXaZQBB8BMoEAg/web_release-v1?node-id=253%3A220)

<p>
    <a href="https://www.figma.com/file/ZiMbxLkmEXaZQBB8BMoEAg/web_release-v1?node-id=253%3A220">
        <img src="https://res.cloudinary.com/endrsd/image/upload/v1568180387/ios_mockup_iju8ud.png" alt="Figma design mockups for iOS" width="500">
    </a>
</p>

### Key Features

- Students can create their own user accounts and passwords on iOS devices
- Users are able to login & logout on iOS devices to protect their career endorsement information
- With proper credentials, students are able to view a list of their track-specific career endorsement requirements on iOS devices
- Students are able to track their overall endorsement progress on iOS devices, as well as stay up-to-date on the progress being made towards individual requirements for endorsement
- Students can access static resources pertaining to specific endorsement requirements on their iOS devices, such as Airtable forms and lecture videos

# Authentication

#### JSON Web Tokens

- A self-contained token which has authentication information, expiration information, and other user properties.
- JWTs don't have sessions to manage (stateless).
- No database table is required, which means fewer database queries.
- Can be used across multiple services.

#### Bcrypt.js

- Protects against 'rainbow table attacks'.
- Resistant to brute-force search attacks.

## Requirements

- iOS 8.0+
- Xcode 10.3
- Cocoa Pods

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a [code of conduct](./CODE_OF_CONDUCT.md). Please follow it in all your interactions with the project.

### Issue/Bug Request

    ## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a [code of conduct](./code_of_conduct.md). Please follow it in all your interactions with the project.

### Issue/Bug Request

**If you are having an issue with the existing project code, please submit a bug report under the following guidelines:**

- Check first to see if your issue has already been reported.
- Check to see if the issue has recently been fixed by attempting to reproduce the issue using the latest master branch in the repository.
- Create a live example of the problem.
- Submit a detailed bug report including your environment & browser, steps to reproduce the issue, actual and expected outcomes, where you believe the issue is originating from, and any potential solutions you have considered.

### Feature Requests

We would love to hear from you about new features which would improve this app and further the aims of our project. Please provide as much detail and information as possible to show us why you think your new feature should be implemented.

### Pull Requests

If you have developed a patch, bug fix, or new feature that would improve this app, please submit a pull request. It is best to communicate your ideas with the developers first before investing a great deal of time into a pull request to ensure that it will mesh smoothly with the project.

Remember that this project is licensed under the MIT license, and by submitting a pull request, you agree that your work will be, too.

#### Pull Request Guidelines

- Ensure any install or build dependencies are removed before the end of the layer when doing a build.
- Update the README.md with details of changes to the interface, including new plist variables, exposed ports, useful file locations and container parameters.
- Ensure that your code conforms to our existing code conventions and test coverage.
- Include the relevant issue number, if applicable.
- You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

### Attribution

These contribution guidelines have been adapted from [this good-Contributing.md-template](https://gist.github.com/PurpleBooth/b24679402957c63ec426).

## Meta

Distributed under the XYZ license. See `LICENSE` for more information.

[https://github.com/labs15-career-endorsement-tracker/iOS](https://github.com/labs15-career-endorsement-tracker/iOS)

[swift-image]: https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
