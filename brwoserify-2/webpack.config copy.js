// Copied from: https://github.com/comunica/comunica/blob/master/packages/actor-init-sparql/webpack.config.js
const path = require('path');
const ProgressPlugin = require('webpack').ProgressPlugin;
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin");

module.exports = {
  entry: [
    path.resolve(__dirname, 'index.js'),
    'url-search-params-polyfill'
  ],
  output: {
    filename: 'ldflex-quickstart-browser.js',
    path: __dirname,
    libraryTarget: 'var',
    library: 'createPath'
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
      },
    ]
  },
  // resolve: {
  //   alias: {
  //     '@comunica/actor-init-sparql-solid': require.resolve('./packages/actor-init-sparql-solid')
  //   }
  // },
  mode: 'development',
  optimization: {
    usedExports: true
  },
  plugins: [
    new NodePolyfillPlugin(),
    new ProgressPlugin(),
  ]
};
