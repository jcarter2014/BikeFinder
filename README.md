# BikeFinder
Find bikeshare bikes in DC!

Each annotation on the map view shows the number of bikes available at that station. 

The second tab is a list of stations, ordered by proximity to the user. 

I've contacted a few other bikeshare programs and have heard back from Jump Mobility and will add their API in the future.

It takes a few runs on Xcode for the project to run correctly.  I'm unsafely unwrapping some strings and they sometimes return nil, so I need to go back and unwrap those optionals safely so that the app doesn't crash on launch.
