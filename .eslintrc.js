/* eslint-disable */

const { readFileSync } = require("fs");

const generalRules = {
  "no-plusplus": "off",

  /**
   * Unused variables and arguments should be removed in most cases, but sometimes they are
   * unavoidable (like `next` in an Express callback). Prefix variable names with an
   * underscore to suppress the error.
   */
  "no-unused-vars": [
    "error",
    {
      argsIgnorePattern: "^_",
      varsIgnorePattern: "^_",
    },
  ],
};

const reactRules = {
  "react/jsx-filename-extension": "off",
  "react/prop-types": "off",
  "react/no-array-index-key": "warn",
};

/**
 * Return a rules object which produces warnings instead of errors for accessibility problems.
 */
function getAccessibilityWarningRules() {
  const a11yRules = require("eslint-plugin-jsx-a11y").rules;
  return Object.fromEntries(
    Object.entries(a11yRules).map(([name, _rule]) => [`jsx-a11y/${name}`, "warn"])
  );
}

/**
 * Return a rules object which allows for...of statements to be used, since this syntax produces
 * errors with the default airbnb config.
 */
function getAllowForOfRules() {
  const airbnbStyleRules = require("eslint-config-airbnb-base/rules/style.js").rules;
  return {
    "no-restricted-syntax": airbnbStyleRules["no-restricted-syntax"].filter(
      (item) => item.selector !== "ForOfStatement"
    ),
  };
}

/**
 * Load the .eslintrc.json file, which contains frontend/backend-specific configuration.
 */
function loadConfig() {
  const path = ".eslintrc.json";
  try {
    return JSON.parse(readFileSync(path, "utf8"));
  } catch (e) {
    throw new Error(`File '${path}' does not exist. Generate it by running 'npx eslint --init'. When prompted to choose the file format, select JSON.`);
  }
}

const jsonConfig = loadConfig();

/**
 * Return whether this part of the project is using React.
 */
function usingReact() {
  return jsonConfig.plugins !== undefined && jsonConfig.plugins.includes("react");
}

/**
 * Generate the complete rules object.
 */
function generateRules() {
  const rules = { ...generalRules };

  if (usingReact()) {
    Object.assign(rules, reactRules);
    Object.assign(rules, getAccessibilityWarningRules());
  }

  Object.assign(rules, getAllowForOfRules());

  return rules;
}

const rules = generateRules();

module.exports = {
  settings: {
    react: {
      version: "detect",
    },
  },
  ...jsonConfig,
  extends: [
    "eslint:recommended",
    usingReact() ? "airbnb" : "airbnb-base",
    "prettier"
  ],
  rules,
};
