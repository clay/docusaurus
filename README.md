# Docusaurus GitHub Pages Action

A GitHub action to deploy your Docusaurus site to GitHub pages.

## Usage

### Build and deploy

The project uses [repo deploy keys](https://developer.github.com/v3/guides/managing-deploy-keys/) to push to GitHub pages rather than access tokens, so make sure to setup your deploy key in the repo and then add it as a Secret under `DEPLOY_SSH_KEY`. Also, you will need the `ALGOLIA_API_KEY` API key to have a functional search on the page.

---

### Update versions

The project can update the version of the documentation using the `package.json` semantic version as its reference. This will only work with minor or patch updates for the first documentation versioning or in case of a major update you will need to perform this update manually. [Here](https://docusaurus.io/docs/en/versioning) you can check the steps to do the manual version update.

## Filter and install
We need to install the `Docusaurus` dependencies to process with the action; we use the [npm install action](https://github.com/actions/npm) to this purpose.  

Also, we only activate the action when there is an update on the `master branch`. We use the [filter action](https://github.com/actions/bin/tree/master/filter) to check if the event that we target perform an update on master.

---

We use the `args` attribute to know which action we need to run as you can see on the `main.workflow` example.

```
workflow "Build Docs" {
  on = "push"
  resolves = ["Deploy Docs"]
}

action "Filter Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Install" {
  needs = ["Filter branch"]
  uses = "actions/npm@master"
  args = "install --prefix ./website"
}

action "Update version" {
  needs = ["Install"]
  uses = "clay/docusaurus-github-action@master"
  args = "version"
}

action "Deploy Docs" {
  needs = ["Update version"]
  uses = "clay/docusaurus-github-action@master"
  args="deploy"
  secrets = ["DEPLOY_SSH_KEY", "ALGOLIA_API_KEY"]
  env={
      BUILD_DIR = "website",
      PROJECT_NAME = "clay"
  }
}
```

## Environment Variables

There are two environment variables you can control:

- `BUILD_DIR`: the directory your code Docusaurus config is in. Defaults to `website`.
- `PROJECT_NAME`: should be set to the value of `projectName` in your [Docusaurus `siteConfig.js` file](https://docusaurus.io/docs/en/site-config#projectname-string). It determines the name of the directory which will be output in the `build` directory which is then deployed to the `gh-pages` branch. Defaults to `site` because it doesn't truly need to be set to the projects name.
