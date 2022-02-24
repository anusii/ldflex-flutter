// Copied from: https://github.com/comunica/comunica/blob/master/packages/actor-init-sparql/webpack.config.js
const path = require('path');
const ProgressPlugin = require('webpack').ProgressPlugin;
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin");
const webpack = require('webpack');

// https://stackoverflow.com/questions/44439909/confusion-over-various-webpack-shimming-approaches

module.exports = {
  entry: [
    path.resolve(__dirname, 'index.js'),
    // 'url-search-params-polyfill', 
    // 'fast-abort-controller',
    // 'core-js'
  ],
  output: {
    filename: 'ldflex-quickstart-browser.js',
    path: __dirname,
    libraryTarget: 'var',
    library: 'ldflex'
    // library: 'createPath'
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
      },
      { test: /\.ttl$/, use: 'raw-loader' },
      { test: /\.sparql$/, use: 'raw-loader' }
    ]
  },
  // resolve: {
  //   fallback: {
  //     "URLSearchParams": require.resolve("url-search-params-polyfill"),
  //     "AbortController": require.resolve("node-abort-controller"),
  //   }
  //   // alias: {
  //   //   '@comunica/actor-init-sparql-solid': require.resolve('./packages/actor-init-sparql-solid')
  //   // }
  // },
  mode: 'development',
  optimization: {
    usedExports: true
  },
  plugins: [
    new NodePolyfillPlugin(),
    new ProgressPlugin(),
    // new webpack.DefinePlugin({
    //   // 'RdfXmlParser.NCNAME_MATCHER': '/^([A-Za-z\xC0-\xD6\xD8-\xF6\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}_])([A-Za-z\xC0-\xD6\xD8-\xF6\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}_.0-9#xB7\u{0300}-\u{036F}\u{203F}-\u{2040}\-])*$/u',
    //   // module: {
    //     // exports: {
    //     //   RdfXmlParser: {
    //     //     // NCNAME_MATCHER: /^([A-Za-z\xC0-\xD6\xD8-\xF6\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}_])([A-Za-z\xC0-\xD6\xD8-\xF6\u{F8}-\u{2FF}\u{370}-\u{37D}\u{37F}-\u{1FFF}\u{200C}-\u{200D}\u{2070}-\u{218F}\u{2C00}-\u{2FEF}\u{3001}-\u{D7FF}\u{F900}-\u{FDCF}\u{FDF0}-\u{FFFD}\u{10000}-\u{EFFFF}_.0-9#xB7\u{0300}-\u{036F}\u{203F}-\u{2040}\-])*$/u,
    //     //     NCNAME_MATCHER: JSON.stringify('false')
          
    //     //   }
    //     // }
    //   // }
    //   'RdfXmlParser.NCNAME_MATCHER': JSON.stringify('false')
      
      
      
    //   // 'RdfXmlParser.NCNAME_MATCHER': 'true',
    // }),
    // new webpack.ProvidePlugin({
    //   'RdfXmlParser.NCNAME_MATCHER': 'true',
    // })
  ]
};
