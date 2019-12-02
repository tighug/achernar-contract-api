module.exports = {
  // 共通・JavaScript設定
  env: {
    browser: true,
    node: true,
    es6: true
  },
  extends: ["eslint:recommended"],
  parser: "babel-eslint",
  rules: {
    "prettier/prettier": "error"
  },
  overrides: [
    // TypeScriptの設定
    {
      files: ["**/*.ts"],
      extends: [
        "plugin:@typescript-eslint/recommended",
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:prettier/recommended",
        "prettier/@typescript-eslint"
      ],
      parser: "@typescript-eslint/parser",
      parserOptions: {
        sourceType: "module"
      },
      plugins: ["@typescript-eslint"]
    }
  ]
};
