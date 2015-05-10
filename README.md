# The Webapp for the duse platform
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
> **Warning:** This implementation has not been tested in production nor has it been examined by a security audit.
> All uses are your own responsibility.

This app implements all client functionality encapsulated in AngularDart.
In order to set this up, clone this repository. Then `cd` into the repo
and run `pub get`. This will fetch all required dependencies.

The Webapp needs a duse instance to communicate with. You need to specify
an environment variable called `DUSE_URL`. This variable should contain an
URL which points to the duse instance, ending with `v1` (this app
uses the first api version). 

In order to fetch bootstrap and other dependencies, don't forget to run
`bower install`.

To finally run the app, run `pub serve`.
