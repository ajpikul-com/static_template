`npm install` will install webpack.

It looks for a main.js in one of two folders:

The build scripts automatically try to detect webpack, if it's there, it uses it first for a `ts/` folder, if not, then a `js/` folder.

Ultimately, its compiled towards the js folder in raw before the `contate` build scripts copy it over verbatim.
