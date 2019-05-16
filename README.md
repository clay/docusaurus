# Docusaurus GitHub Pages Action

A GitHub action to deploy your Docusaurus site to GitHub pages.

## Usage

### Build and deploy

The project uses [repo deploy keys](https://developer.github.com/v3/guides/managing-deploy-keys/) to push to GitHub pages rather than access tokens, so make sure to setup your deploy key in the repo and then add it as a Secret under `DEPLOY_SSH_KEY`. Also, you will need the `ALGOLIA_API_KEY` API key to have a functional search on the page.

### Update versions

The project can update the version of the documentation using the `package.json` version as its reference.

```
workflow "Build Docs" {
  on = "push"
  resolves = ["Deploy Docs"]
}

action "Filter Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Update version" {
  uses = "clay/docusaurus-github-action/versions@master"
}

action "Deploy Docs" {
  needs = ["Filter Master", "Update version"]
  uses = "clay/docusaurus-github-action/build_deploy@master"
  secrets = ["DEPLOY_SSH_KEY", "ALGOLIA_API_KEY"]
}
```

## Environment Variables

There are two environment variables you can control:

- `BUILD_DIR`: the directory your code Docusaurus config is in. Defaults to `website`.
- `PROJECT_NAME`: should be set to the value of `projectName` in your [Docusaurus `siteConfig.js` file](https://docusaurus.io/docs/en/site-config#projectname-string). It determines the name of the directory which will be output in the `build` directory which is then deployed to the `gh-pages` branch. Defaults to `site` because it doesn't truly need to be set to the projects name.
