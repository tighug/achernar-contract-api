module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    es6: true
  },
  parserOptions: {
    parser: "babel-eslint"
  },
  extends: ["prettier", "plugin:prettier/recommended"],
  plugins: ["prettier"],
  rules: {}
};
