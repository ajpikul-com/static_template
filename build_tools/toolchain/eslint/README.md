`npm install eslint@latest`

If you want to use typescript linting:

`npm install typescript@latest`

Now you will set up a configuration:

`npm init` will generate a stub package.json file that the configurator wants. Change the name to something like eslint-toolchain (you can accept all other defaults).

`npx eslint --init` will bring up a list of configurations that you can walk through. Select 'y' and allow it to install dependencies for the typescript option if you desire.
