# Linters

## Usage (For Developers)

_This assumes that linting has already been set up for your project._

1. Run `npm install` in _every_ directory of the project (backend and frontend).
1. Write code as usual and stage your changes.
1. Try to make a commit. The secret scan and lint check should run automatically.
1. Follow the prompts to address any recommendations or warnings.
1. If you're in a hurry, use `NO_LINT=1 git commit` to skip the lint check entirely.

## Initial Setup

### `.gitignore`

Initialize your repository's `.gitignore` with the Node.js template from [`github/gitignore`](https://github.com/github/gitignore):

1. `cd` into your project's root directory.

1. Download the template:

   ```sh
   curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Node.gitignore
   ```

### ESLint and Prettier

#### For Node.js Backends

1. `cd` into your backend directory.

1. Download some config files from this repository:

   ```sh
   for file in .eslintignore .prettierignore .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Install the necessary packages:

   ```sh
   npm install --save-dev eslint eslint-config-prettier eslint-plugin-import prettier
   ```

1. Create a baseline ESLint config:

   ```sh
   npm init @eslint/config
   ```

   Answer the prompts as follows:

   <dl>
     <dt>How would you like to use ESLint?</dt>
     <dd>To check syntax and find problems</dd>
     <dt>What type of modules does your project use?</dt>
     <dd>Answer as appropriate.</dd>
     <dt>What framework does your project use?</dt>
     <dd>None of these (since this is the backend)</dd>
     <dt>Does your project use TypeScript?</dt>
     <dd>Yes</dd>
     <dt>Where does your code run?</dt>
     <dd>Node (tip: press <kbd>i</kbd> to toggle)</dd>
     <dt>What format do you want your config file to be in?</dt>
     <dd>JSON</dd>
   </dl>

   If you are asked to install any dependencies, install them. If you answer a prompt incorrectly, you can simply rerun the command to try again.

1. Edit the generated `.eslintrc.json` to include [these changes](backend.eslintrc.json).

1. If your frontend is in a subdirectory of the backend, you'll need to follow some additional instructions to ensure that the frontend and backend are linted separately.

   1. Backend:

      Add the frontend directory to an `.eslintignore` file (replace `frontend` with the name of your frontend directory):

      ```sh
      echo frontend >> .eslintignore
      ```

   1. Frontend:

      Add `"root": true` to your `.eslintrc.json` to avoid using the backend's ESLint config for the frontend. See [this link](https://eslint.org/docs/user-guide/configuring/configuration-files#cascading-and-hierarchy) for more details.

1. Add these scripts to your `package.json`:

   ```sh
   npm pkg set scripts.format="npm run check-git-hooks && prettier --write ."
   npm pkg set scripts.lint-fix="npm run check-git-hooks && (eslint --fix --cache --report-unused-disable-directives . || true) && prettier --write ."
   npm pkg set scripts.lint-check="npm run check-git-hooks && eslint --cache --report-unused-disable-directives . && prettier --check ."
   npm pkg set scripts.check-git-hooks="echo Git hooks not configured yet. You SHOULD NOT see this message unless you are still setting up linting."
   ```

   `npm run format` reformats your code without doing any linting. `npm run lint-fix` automatically fixes some lint errors and reformats the code. `npm run lint-check` doesn't modify any files, and exits non-zero if there are any lint errors or code style discrepancies; this is intended for a Git pre-commit hook or a CI/CD check.

   > Ideally, instead of `(eslint ... || true) && prettier ...`, we would use `eslint ... ; prettier ...`. However, there are some issues with using the semicolon as a command separator in Git Bash on Windows. See [this article](https://medium.com/@chillypenguin/running-node-npm-scripts-sequentially-on-windows-8737dc24da1f) for more details.

   > At a later step in the setup, we'll change `npm run check-git-hooks` to actually check that Git hooks are installed. This will enforce that every developer has Git hooks installed (at least, every developer that tries to use one of the linting commands).
   >
   > Running `npm install` or `npm run prepare` doesn't actually guarantee that the hooks are installed, because Husky will skip hook installation if Git is not available on the command line (e.g. for GitHub Desktop users). But these commands also need to run in production environments, which might not have Git installed, so we can't do the hook check there. Thus, we only do the hook check as part of the linting commands, which should never be run in production.

1. Try it out:

   ```sh
   npm run lint-fix
   ```

1. Stage and commit the modified files.

#### For Next.js Frontends

1. `cd` into your frontend directory.

1. If you already set up ESLint when you created the project, you should have a `.eslintrc.json` file already, and you can skip this step.

   Otherwise, run `npx next lint` to generate `.eslintrc.json` ([docs](https://nextjs.org/docs/app/building-your-application/configuring/eslint)), and answer the prompt as follows:

   <dl>
     <dt>How would you like to configure ESLint?</dt>
     <dd>Strict</dd>
   </dl>

   If there is still no `.eslintrc.json`, see [this workaround](https://github.com/vercel/next.js/issues/50761#issuecomment-1666057683).

1. Download some config files from this repository:

   ```sh
   for file in .eslintignore .prettierignore .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Install the necessary packages:

   ```sh
   npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-next eslint-config-prettier eslint-plugin-import prettier
   ```

1. Edit `.eslintrc.json` to include [these changes](nextjs.eslintrc.json).

1. Add these scripts to your `package.json`:

   ```sh
   npm pkg set scripts.check-git-hooks="echo Git hooks not configured yet. You SHOULD NOT see this message unless you are still setting up linting."
   npm pkg set scripts.format="npm run check-git-hooks && prettier --write ."
   npm pkg set scripts.lint-fix="npm run check-git-hooks && (eslint --fix --cache --report-unused-disable-directives . || true) && prettier --write ."
   npm pkg set scripts.lint-check="npm run check-git-hooks && eslint --cache --report-unused-disable-directives . && prettier --check ."
   ```

1. Try it out:

   ```sh
   npm run lint-fix
   ```

1. Stage and commit the modified files.

#### For Vite Frontends with React

1. `cd` into your frontend directory.

1. Download some config files from this repository:

   ```sh
   for file in .eslintignore .prettierignore .prettierrc.json; do curl -O https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Install the necessary packages:

   ```sh
   npm install --save-dev eslint-plugin-react eslint-plugin-jsx-a11y eslint-config-prettier eslint-plugin-import prettier
   ```

1. Edit `.eslintrc.cjs` to include [these changes](vite.eslintrc.cjs).

1. Add these scripts to your `package.json`:

   ```sh
   npm pkg set scripts.check-git-hooks="echo Git hooks not configured yet. You SHOULD NOT see this message unless you are still setting up linting."
   npm pkg set scripts.format="npm run check-git-hooks && prettier --write ."
   npm pkg set scripts.lint-fix="npm run check-git-hooks && (eslint --fix --cache --report-unused-disable-directives . || true) && prettier --write ."
   npm pkg set scripts.lint-check="npm run check-git-hooks && eslint --cache --report-unused-disable-directives . && prettier --check ."
   ```

1. Remove the predefined `lint` script to avoid confusion:

   ```sh
   npm pkg delete scripts.lint
   ```

1. Try it out:

   ```sh
   npm run lint-fix
   ```

1. Stage and commit the modified files.

### Git Hooks and Secret Scanning

1. `cd` into your project's root directory.

1. Download the necessary files from this repo:

   <!-- IMPORTANT: if you modify the list of files below, update secret-scan-tests/common.sh as well. -->

   ```sh
   for file in .husky/lint-config.sh .husky/pre-commit .husky/pre-push .secret-scan/.gitignore .secret-scan/secret-scan-config.json .secret-scan/secret-scan.js; do curl --create-dirs -o $file https://raw.githubusercontent.com/TritonSE/linters/main/$file; done
   ```

1. Open `.husky/lint-config.sh` in your editor of choice, and edit the `node_dirs` variable (if needed) to match your project's frontend and backend directories.

1. Add execute permissions to the pre-commit and pre-push scripts:

   ```sh
   chmod u+x .husky/pre-commit .husky/pre-push
   ```

1. `cd` into the backend and install [husky](https://typicode.github.io/husky):

   ```sh
   npm install --save-dev husky

   # If necessary, change ".." in both commands to refer to the repository's root directory.
   npm pkg set scripts.prepare="cd .. && husky install .husky"
   npm pkg set scripts.check-git-hooks="cd .. && node .secret-scan/secret-scan.js -- --check-git-hooks"

   # Install Git hooks.
   npm run prepare

   # Check that Git hooks were installed successfully.
   npm run check-git-hooks
   ```

1. Repeat the steps above for the frontend.

1. Stage the `.husky` and `.secret-scan` directories, along with your `package.json` and `package-lock.json` for the backend and frontend.

1. Verify that the pre-commit script runs when you commit:

   ```sh
   git commit
   ```

1. Verify that the pre-push script runs when you push:

   ```sh
   git push
   ```

1. Create a file called `fake-env` somewhere in your repository, and paste the following text into it:

   ```
   mongodb://this-is-a-fake-database
   ```

   If you run `git commit`, you should see an error like `SECRET DETECTED in working tree, file "fake-env"`. This secret scanning tool aims to prevent credentials or other secrets from being committed to Git by accident. After deleting `fake-env`, you should be able to commit again.

   To customize what kinds of secrets are detected, especially if you will use credentials for something other than MongoDB or Firebase, see `.secret-scan/secret-scan-config.json` in your repository.

1. Ask anyone else who has already cloned the repository to run `npm install` in the frontend and backend again, so that the Git hooks are installed for them as well.

### CI Configuration

Please refer to the [sample workflow](.github/workflows/lint-check.yml) for GitHub Actions. You'll need to change the directory names for the frontend and backend if they're different for your project.

## Development

### ESLint and Prettier Configs

[Fulcrum](https://github.com/TritonSE/TSE-Fulcrum) and the [TSE website](https://github.com/TritonSE/tritonse.github.io/) can be used to test config changes for Node.js backends and Next.js frontends respectively.

### Secret Scanner

The secret scanner aims to prevent secrets (like database credentials or API keys) from being committed to project repositories. It does this by scanning the working tree, Git index, and commit history before code is committed or pushed.

To avoid scanning the entire commit history every time, we also maintain a cache to record which commits contain no secrets.

#### Secret Scanner Development

To support detection of new kinds of secrets, add regexes to the default config [here](.secret-scan/secret-scan-config.json). The source code for the scanner script is [here](.secret-scan/secret-scan.js).

#### Secret Scanner Testing

To run the automated tests:

```sh
secret-scan-tests/run-all-tests.sh
```

The tests check whether secrets are correctly detected in different scenarios. You should add tests for any new regexes you add, and you should rerun the tests after modifying the config or scanner script.
