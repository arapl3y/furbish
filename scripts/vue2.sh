#!/bin/sh

GREEN='\033[0;32m'
BLUE='\033[1;34m'
ERR="\033[1;31m"
NC='\033[0m'
PACKAGES="axios vee-validate vuex"
# DEV_PACKAGES="esdoc eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y@5"

echo 
echo "${GREEN}Furbishing a Vue 2 project${NC}"
echo

if ! type "node" > /dev/null; then
    echo "${ERR}Node not found!" 1>&2
    echo "Please follow the install instructions at https://nodejs.org/en/ then try again${NC}" 1>&2
    exit
fi


if ! type "vue" > /dev/null; then
    echo "${ERR} Vue CLI not found!" 
    echo "Installing Vue CLI"
    npm install -g vue-cli
fi


# TODO: Add customisation for template name
read -p "What would you like your app to be called? " appname

echo
echo "${BLUE}Furbish:${NC} Initialising Vue project using Webpack template"
echo

vue init webpack $appname
cd ./$appname


if ! type yarn > /dev/null; then
    echo
    echo "${BLUE}Furbish:${NC} Installing initial dependencies with npm"
    echo

    npm install

    echo
    echo "${BLUE}Furbish:${NC} Installing additional dependencies: $PACKAGES"
    echo

    npm install --save $PACKAGES
else
    echo
    echo "${BLUE}Furbish:${NC} Installing initial dependencies with yarn"
    echo
    yarn install
    echo
    echo "${BLUE}Furbish:${NC} Installing additional dependencies: $PACKAGES"
    echo
    yarn add $PACKAGES
fi

# Set up file architecture
echo
echo "${BLUE}Furbish:${NC} Setting up file architecture"
echo

cd ./src
rm assets/logo.png components/Hello.vue App.vue

cat << EOF > App.vue
<template>
  <div id="app">
    <h1>Hello</h1>
  </div>
</template>

<script>
export default {
  name: 'app',
};
</script>

<style>

</style>
EOF

if [ -d ./router ] 
then
    cd ./router
    rm index.js
    cat << EOF > index.js
    import Vue from 'vue'
    import Router from 'vue-router'

    Vue.use(Router)

    export default new Router({
        routes: []
    })
EOF
fi

# TODO: Add .editorconfig and .eslintrc

# Return to root directory
cd ..


echo 
echo "${GREEN}SUCCESS! Your project directory is fully furbished! ${NC}"
echo 
echo "${GREEN}Booting up dev server now...${NC}" 
echo 

# Start dev server
if ! type yarn > /dev/null; then
   npm start
else
   yarn start
fi