#!/bin/sh

GREEN='\033[0;32m'
BLUE='\033[1;34m'
ERR="\033[1;31m"
NC='\033[0m'

echo 
echo "${GREEN}Furbishing a Polymer 3 project${NC}"
echo

if ! type "node" > /dev/null; then
    echo "${ERR}Node not found!" 1>&2
    echo "Please follow the install instructions at https://nodejs.org/en/ then try again${NC}" 1>&2
    exit
fi

if ! type "yarn" > /dev/null; then
    echo "${ERR}Yarn not found!" 1>&2
    echo "Please follow the install instructions at https://yarnpkg.com/en/docs/install then try again${NC}" 1>&2
    exit
fi

if ! type "polymer" > /dev/null; then
    echo "${BLUE}Furbish:${NC} Installing Polymer CLI"
    npm install -g polymer-cli
fi

echo "${BLUE}Furbish:${NC} Initialising Project (Yarn)"
yarn init

echo "${BLUE}Furbish:${NC} Setting Project to 'flat' (package.json)"
node > package.flat.json <<EOF
    var data = require('./package.json')
    data.flat = true
    console.log(JSON.stringify(data, null, 2))
EOF
rm ./package.json
mv ./package.flat.json ./package.json

echo "${BLUE}Furbish:${NC} Adding dependencies (Yarn)"
yarn add @polymer/polymer@next @webcomponents/webcomponentsjs@^1.0.11

echo "${BLUE}Furbish:${NC} Creating index.html"
cat << EOF > index.html
<!doctype html>
<html>
  <head>
    <script src="node_modules/@webcomponents/webcomponentsjs/webcomponents-loader.js"></script>
    <script type="module" src="src/my-app.js"></script>
  </head>
  <body>
    <my-app></my-app>
  </body>
</html>
EOF

echo "${BLUE}Furbish:${NC} Creating my-app.js"
mkdir ./src
cat << 'EOF' > src/my-app.js
import { Element } from '../node_modules/@polymer/polymer/polymer-element.js'

export class MyApp extends Element {
  constructor() {
    super()
    this.name = '3.0 preview'
  }
  static get properties() {
    name: {
      Type: String
    }
  }
  static get template() {
    return `<div>This is my [[name]] app.</div>`
  }
}

customElements.define('my-app', MyApp)
EOF

echo 
echo "${GREEN}SUCCESS! Your project directory is fully furbished!"
echo 
echo "To run your project please use the following command(s):"
echo "  polymer serve --npm"
echo "${NC}"