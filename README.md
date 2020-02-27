# GitHub Action for [Hugo](https://github.com/gohugoio/hugo) ✏️ 

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/jakejarvis/hugo-develop?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/jakejarvis/hugo-develop) ![Build docs](https://github.com/jakejarvis/hugo-build-action/workflows/Build%20docs/badge.svg)

**⚠️ Warning:** This branch is specifically for testing the latest `dev` version built from the most recent commits to the [Hugo repository](https://github.com/gohugoio/hugo). For 99.9% of use cases, the stable [`master` branch](https://github.com/jakejarvis/hugo-build-action/tree/master) is more appropriate.


## Usage

### `workflow.yml` Example

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: jakejarvis/hugo-build-action@develop
      with:
        args: --minify --buildDrafts
```


## License

This action is distributed under the [MIT License](LICENSE.md). Hugo is distributed under the [Apache License 2.0](https://github.com/gohugoio/hugo/blob/master/LICENSE).
