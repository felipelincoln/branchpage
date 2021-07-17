# BranchPage

> A platform for deploying blogs using `.md` files on GitHub.

[![codecov](https://codecov.io/gh/felipelincoln/branchpage/branch/dev/graph/badge.svg?token=W1W8NUK26S)](https://codecov.io/gh/felipelincoln/branchpage)
[![](https://img.shields.io/github/v/release/felipelincoln/branchpage)](https://github.com/felipelincoln/branchpage/releases/latest)
![](https://img.shields.io/github/contributors/felipelincoln/branchpage)

![](https://i.ibb.co/ZWgjbS5/Screenshot-from-2021-06-05-11-55-08.png)

## ✅ Features
* Totally free. :money_with_wings:
* Blog can be created in seconds :fast_forward:
* You content is always safe on github :octocat:
* Readers can contribute to your posts :hammer:
* Donation links available through your blog (Coming soon.) :moneybag:

And much more features coming :grin:

## 🚀 Installation and execution

1. Clone this repository and go to the directory;
2. Create a .env file;

### 📦️ Running for the first time

1. Run `docker-compose build`;
2. Install mix dependencies `docker-compose run --rm web mix deps.get`;
3. Create database `docker-compose run --rm web mix ecto.create`;
4. Run the migrations `docker-compose run --rm web mix ecto.migrate`;
5. Install npm dependencies `docker-compose run --rm web npm install --prefix apps/web/assets`;

### 🔧 Development

1. Run `docker-compose up`;
2. Access localhost:4000;

### 🧪 Tests

1. Run `docker-compose run --rm web mix test`;

## 🤔 How to contribute

- Fork this repository;
- Create a branch with your feature: `git checkout -b my-feature`;
- Commit your changes: `git commit -m 'My new feature'`;
- Push to your branch: `git push origin my-feature`.

After the merge of your pull request is done, you can delete your branch.

---
