#!/usr/bin/env sh

set -e

npm run build

cd dist

git init
git add -A
git commit -m "New Deployment"
git push --set-upstream git@github.com:jvenanzi/github-pages-vue-typescript.git master

cd -