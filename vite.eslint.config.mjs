import antfu from "@antfu/eslint-config";

export default antfu({
  ignores: [
    ".next/",
    "**/.next/**/",
    "build/",
    "**/build/**/",
    "dist/",
    "**/dist/**/",
    "out/",
    "**/out/**/",
    "public/",
    "**/public/**/",
    "next.config.js",
    "**/next.config.js/**",
    "vite.config.ts",
    "**/vite.config.ts/**",
  ],

  react: true,

  // Disables stylistic rules to avoid conflicts with Prettier
  stylistic: false,

  // Enables type aware rules
  typescript: {
    tsconfigPath: "tsconfig.json",
  },

  rules: {
    "react-refresh/only-export-components": ["warn", { allowConstantExport: true }],

    // Getting the eslint resolver working is left as an exercise to the reader.
    "import/no-unresolved": "off",

    // Avoid bugs
    "ts/no-shadow": ["error", { ignoreTypeValueShadow: true }],
    "ts/no-unsafe-unary-minus": "error",
    "ts/no-unused-expressions": "error",
    "ts/no-unused-vars": [
      "error",
      {
        argsIgnorePattern: "^_",
        destructuredArrayIgnorePattern: "^_",
        varsIgnorePattern: "^_",
      },
    ],
    "ts/switch-exhaustiveness-check": "error",
    "array-callback-return": "error",
    eqeqeq: "error",
    "no-await-in-loop": "error",
    "no-constant-binary-expression": "error",
    "no-constructor-return": "error",
    "no-constant-condition": [
      "error",
      {
        checkLoops: false,
      },
    ],
    "no-promise-executor-return": "error",
    "no-self-compare": "error",
    "no-template-curly-in-string": "error",

    // Stylistic.
    "ts/consistent-type-definitions": ["warn", "type"],
    "ts/no-use-before-define": "warn",
    "ts/prefer-readonly": "warn",
    "ts/prefer-regexp-exec": "warn",
    "object-shorthand": ["warn", "properties"],
    "import/consistent-type-specifier-style": ["warn", "prefer-top-level"],
    "perfectionist/sort-imports": [
      "warn",
      {
        groups: ["builtin", "external", "parent", "sibling", "index", "object", "type"],
        newlinesBetween: "always",
      },
    ],
    "perfectionist/sort-named-imports": ["warn"],
    "no-console": "warn",
    "no-case-declarations": "off",

    // Disabled because of too many false positives.
    "@typescript-eslint/no-unnecessary-condition": "off",
    "react-hooks/exhaustive-deps": "off",
  },
});
