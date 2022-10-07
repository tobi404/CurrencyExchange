# Welcome

### Intro

*Thank you for time spent reviewing this project*

I want to mention that the task was pretty interesting to acomplish. It had simple idea but behind have manu edge cases that could be covered. With this project I have tried to showcase my skills as developer, as much as I could within a timeframe I had. Hopefully most of the code written is self explanatory. The only thing I would like to talk about is an architecture.


### Modular architecture (a.k.a. Clean Architecutre)

Whenever I encountered uncle Bob's clean architecture concepts I was instantly hooked on it. Shortly, the idea behind is to separate project into logical parts and handle them in isolation. In iOS world there are many approaches for separation like: nested project, or projects within xcworkspace, cocoapods or the one I have used Swift Package manager. 

<div align="center">
    <img src="https://miro.medium.com/max/1380/0*Kb5wZ_jkTq4XAVB_" alt="">
</div>

The main module is CEAPP, which "can see" every other modules and help to "glue them" together.  

The presentation module is project file itself. Which has all the UI handling and app specific logic (APPdelegate, SceneDelegate, etc.).

The CEDomain module is responsible for modular interconnectivity. It has no dependencies and talks to everything else by dependency inversion design pattern. 

The CECore module handles networking and can have local storage management as well.

Such segregation allows us to replace core module in the future if for example project moved from realm database to core data. Other parts of the project will be untouched. Or even better, if company desides to create ipad or macOS version of the app, just create separated project and add CEAPP SPM the rest will be transfered automatically.

