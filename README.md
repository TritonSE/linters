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
      npm install --save-dev eslint eslint-config-airbnb-base eslint-config-prettier prettier $(npm info "eslint-config-airbnb-base@latest" peerDependencies | grep -Eo "'?[^':]+'?:" | tr -d " :'")
      ```

      (The part of the command in `$( ... )` retrieves the peer dependencies for `eslint-config-airbnb-base`.)

   1. Frontend (note that `create-react-app` should have installed `eslint` already):

      ```sh
      npm install --save-dev eslint-config-airbnb @babel/eslint-parser eslint-config-prettier prettier $(npm info "eslint-config-airbnb@latest" peerDependencies | grep -Eo "'?[^':]+'?:" | tr -d " :'")
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

1. If your frontend is in a subdirectory of the backend, you'll need to follow some additional instructions to ensure that the frontend and backend are linted separately.

   1. Backend:

      Add the frontend directory to an `.eslintignore` file (replace `frontend` with the name of your frontend directory):

      ```sh
      echo frontend >> .eslintignore
      ```

   1. Frontend:

      Add `"root": true` to your `.eslintrc.json` to avoid using the backend's ESLint config for the frontend. See [this link](https://eslint.org/docs/user-guide/configuring/configuration-files#cascading-and-hierarchy) for more details.

1. Download the config files from this repo:

   1. Backend:

      ```sh
      for file in .eslintrc.js .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
      ```

   1. Frontend:

      ```sh
      for file in .eslintrc.js .prettierrc.json .env.development; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
      ```

      > Our ESLint config is stricter than the one that comes with Create React App, so it will produce errors instead of warnings in many cases. However, the default webpack configuration causes the build to fail when there are lint errors. The environment variable in `.env.development` fixes this by treating errors as warnings. Make sure that this file is committed to Git; [it is safe to do so](https://create-react-app.dev/docs/adding-custom-environment-variables/#adding-development-environment-variables-in-env). Note that this functionality requires a recent version of `react-scripts`, so you may have to update that package to 4.0.3+. If it still doesn't work, try deleting `node_modules` and trying again, since old versions of `node_modules/react-scripts/config/webpack.config.js` don't load this environment variable.

1. Add these scripts to your `package.json`:

   ```sh
   npm set-script format "prettier --write ."
   npm set-script lint-fix "eslint --fix --cache --report-unused-disable-directives . ; prettier --write ."
   npm set-script lint-check "eslint --cache --report-unused-disable-directives . && prettier --check ."
   ```

   `npm run format` reformats your code without doing any linting. `npm run lint-fix` automatically fixes some lint errors and reformats the code. `npm run lint-check` doesn't modify any files, and exits non-zero if there are any lint errors or code style discrepancies; this is intended for a Git pre-commit hook or a CI/CD check.

1. Try it out:

   ```sh
   npm run lint-check
   ```

1. Stage and commit the modified files.

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

1. Stage and commit the `.husky` directory, along with your `package.json` and `package-lock.json` for the backend and frontend. (You'll need to use `git commit --no-verify` if there are unfixed lint errors at the moment.)

## CircleCI Configuration

See the [sample `config.yml`](.circleci/config.yml). You'll need to change the directory names for the frontend and backend if they're different for your project.

## To Do

1. Test the ESLint configuration on more code from past projects.
1. Improve README.
1. Add support for Jest.
