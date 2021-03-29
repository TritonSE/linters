# Linters

## Download `.gitignore` Template

Initialize your repository's `.gitignore` with the Node.js template from [`github/gitignore`](https://github.com/github/gitignore):

1. `cd` into your project's root directory.

1. Download the template:

   ```sh
   curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore
   ```

## Install ESLint and Prettier

You will need to complete these steps **twice**: once for the backend and once for the frontend.

1. `cd` into your backend or frontend directory.

1. Download the ESLint and Prettier config files from this repo:

   ```sh
   for file in .eslintrc.js .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Install packages.

   1. Backend:

      ```sh
      npm install --save-dev eslint eslint-config-airbnb-base eslint-config-prettier prettier
      ```

   1. Frontend (note that `create-react-app` should have installed `eslint` already):

      ```sh
      npm install --save-dev eslint-config-airbnb eslint-config-prettier prettier
      ```

1. Run this command and answer the prompts appropriately for your backend or frontend. When prompted to select the config file format, **choose JSON**:

   ```sh
   npx eslint --init
   ```

1. Add this command to the `scripts` property of your `package.json':

   ```json
   "lint": "npx eslint --cache --fix --report-unused-disable-directives . && prettier --write ."
   ```

1. Try it out:

   ```
   npm run lint
   ```

## To Do

1. Add instructions for setting up a local Git hook. Ideally, this would be set up when someone clones the repo and runs `npm install` in *either* the frontend or backend directories.
1. Improve README.
1. Add instructions for setting up CI/CD.
