# Linters

## `.gitignore`

Initialize your repository's `.gitignore` with the Node.js template from [`github/gitignore`](https://github.com/github/gitignore):

1. `cd` into your project's root directory.

1. Download the template:

   ```sh
   curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore
   ```

## Linting Setup

You will need to complete these steps **twice**: once for the backend and once for the frontend.

1. `cd` into your backend or frontend directory.

1. Install packages.

   1. Backend:

      ```sh
      npm install --save-dev eslint eslint-config-airbnb-base eslint-plugin-import eslint-config-prettier prettier
      ```

   1. Frontend (note that `create-react-app` should have installed `eslint` already):

      ```sh
      npm install --save-dev eslint-config-airbnb eslint-plugin-import babel-eslint eslint-config-prettier prettier
      ```

1. Initialize a barebones ESLint config file with project-specific settings:

   ```sh
   npx eslint --init
   ```

   Follow the instructions below to answer the prompts. If you are prompted to install dependencies at any point, select "Yes".

   <dl>
     <dt>How would you like to use ESLint?</dt>
     <dd>To check syntax and find problems</dd>
     <dt>What type of modules does your project use?</dt>
     <dd>Answer as appropriate.</dd>
     <dt>What framework does your project use?</dt>
     <dd>Answer as appropriate.</dd>
     <dt>Does your project use TypeScript?</dt>
     <dd>Answer as appropriate.</dd>
     <dt>Where does your code run?</dt>
     <dd>Answer as appropriate. It will probably only be one of the two; you can press `i` to toggle.</dd>
     <dt>What format do you want your config file to be in?</dt>
     <dd>JSON</dd>
   </dl>

   If you answer a prompt incorrectly, you can simply rerun the command to try again.

1. Download the ESLint and Prettier config files from this repo:

   ```sh
   for file in .eslintrc.js .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Add these scripts to your `package.json`:

   ```sh
   npm set-script format "prettier --write ."
   npm set-script lint "eslint --fix --cache --report-unused-disable-directives . && prettier --write ."
   npm set-script lint-check "eslint --cache --report-unused-disable-directives . && prettier --check ."
   ```

   `npm run format` reformats your code without doing any linting. `npm run lint` lints and reformats; this is intended for a Git pre-commit hook. `npm run lint-check` doesn't modify any files, and exits non-zero if there are any lint errors or code style discrepancies; this is intended for CI/CD checks.

1. Try it out:

   ```sh
   npm run lint
   ```

1. Stage and commit the modified files (`.eslintrc.js .eslintrc.json .prettierrc.json package.json package-lock.json`).

## Git Hook Setup

1. Install [husky](https://typicode.github.io/husky) in **both** the backend and frontend:

   ```sh
   npm install --save-dev husky
   npm set-script prepare "cd .. && husky install .husky"
   npm run prepare
   ```

1. `cd` into your project's root directory.

1. Set up a Git hook to lint and reformat your code before committing.

   1. Download the pre-commit script from this repo:

      ```sh
      curl -o .husky/pre-commit https://raw.githubusercontent.com/TritonSE/linters/main/.husky/pre-commit
      ```

   1. Open `.husky/pre-commit` in your editor of choice, and edit the `node_dirs` variable to match your project's frontend and backend directories.

   1. Add execute permissions to the pre-commit script:

      ```sh
      chmod u+x .husky/pre-commit
      ```

   1. Verify that the pre-commit script runs when you commit:

      ```sh
      git commit
      ```

      If the lint check passes, you should see a message to that effect, and you should be able to commit. Otherwise, you should see a list of lint errors, and the commit should be aborted.

   1. Stage and commit the `.husky` directory.

## CircleCI Configuration

See the [`sample config.yml`](.circleci/config.yml). You'll need to change the directory names for the frontend and backend if they're different for your project.

## To Do

1. Test the ESLint configuration on more code from past projects.
1. Improve README.
1. Add support for Jest.
