# TuneMachine

> A time machine for your Spotify tunes!

This project is the result of the [ScottyLabs][sl]' team at a16z's Battle of the
Hacks v2 in June 2015.

See it live at <http://tunemachine.herokuapp.com>.

TuneMachine lets you take snapshots of your Spotify playlists and restore to a
specific version at any time. It has a super simple interface. Once you log in,
you see all of your playlists. From here, you can see a list of snapshots you've
taken of each playlist, and for each snapshot you can see a quick overview of
what the playlist looked like at that point in time. This makes it super useful
for keeping track of what's changed over time inside collaborative playlists.


## Setup

There are two ways to get set up; you can get set up for
[development](#development) or for [The Real World](#the-real-world).

### Development

The development environment requires a Node.js setup.

```console
$ git clone https://github.com/jez/tunemachine
$ npm install

# If you want a fancy development environment:
$ npm install -g nodemon
```

Next, either install the [Heroku toolbelt][toolbelt], or make sure you have the
[foreman][foreman] gem installed.

```console
Install the Heroku toolbelt package installer from Heroku

or

$ brew install heroku-toolbelt
$ gem install foreman
```

Next up, you'll need to create an __[application on Spotify][spotify-app]__
to get an app `client_id` and `client_secret`. Add a Redirect URI, and point it
at `http://localhost:5000/auth/oauth2callback`.

Replace `MYAPP_NAME` as necessary. Hit "Save". Once you have a client id and
client secret, fill in the appropriate values in `.env.template` after renaming
it to `.env`.

```console
$ cp .env.template .env

(Edit .env)
```

You can ignore the other values that were in `.env.template.` They have sane
defaults configured in `config.coffee`.

Last up, let's install MongoDB:

```console
$ brew install mongo
```

You should now be all good to get started developing. This is a bunch of
commands that might be useful:

```bash
# To start the mongo instance:
$ mongod --dbpath ./data

# To run, watching for changes to backend coffee files:
NODE_ENV=development npm start

# To run, not watching for changes on the backend
npm start

# To watch and recompile frontend static assets
npm run watch

# To compile the frontend static assets once
npm run build

# To clean all compiled static assets
npm run clean
```


### The Real World

This app can be deployed with Heroku.

```console
$ git clone https://github.com/jez/tunemachine
```

Next, either install the [Heroku toolbelt][toolbelt], or make sure you have the
[foreman][foreman] gem installed.

```console
Install the Heroku toolbelt package installer from Heroku

or

$ brew install heroku-toolbelt
$ gem install foreman
```

You'll need to choose a name (like "myapp") for your app on Heroku, then create
it at the command line:

```console
$ heroku create <myapp's name>
```

Next up, you'll need to create an __[application on Spotify][spotify-app]__
to get an app `client_id` and `client_secret`. Add a Redirect URI, and point it
at `http://MYAPP_NAME.herokuapp.com/auth/oauth2callback`.

Replace `MYAPP_NAME` as necessary. Hit "Save". Once you have a client id and
client secret, fill in the appropriate values in `.env.template` after renaming
it to `.env.prod`.

You'll also want to uncomment `DOMAIN` and set it to
`http://MYAPP_NAME.herokuapp.com`.

```console
$ cp .env.template .env.prod

(Edit .env.prod)
```

The last thing to configure is setting up a MongoDB database. You can either use
a free service like MongoLab for this or set up and host your own. Once you have
a database URI that you can use to connect to the database, add it in
`.env.prod` as `DB_URL`.

Now push this config to Heroku:

```console
$ heroku config:push -e .env.prod
```

We should now be good to go. Push the code to Heroku to deploy:

```console
$ git push heroku master
```

## License

MIT License. See LICENSE.


[sl]: https://scottylabs.org

[toolbelt]: https://toolbelt.heroku.com/
[foreman]: https://github.com/ddollar/foreman
[spotify-app]: https://developer.spotify.com/my-applications/
