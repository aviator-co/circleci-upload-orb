# CircleCI upload orb for Aviator


[![CircleCI Build Status](https://circleci.com/gh/aviator-co/circleci-upload-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/aviator-co/circleci-upload-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/aviator/aviator-upload-orb.svg)](https://circleci.com/orbs/registry/orb/aviator/aviator-upload-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/aviator-co/circleci-upload-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)



A project template for Orbs.

This repository is designed to be automatically ingested and modified by the CircleCI CLI's `orb init` command.

## Orb to upload CircleCI artifacts to Aviator
Aviator is a developer productivity platform that helps keep the builds stable at scale. This orb is designed as an extension to the Aviator service that helps upload the test artifacts to Aviator server. Aviator analyzes and catalogs these test artifacts to perform the following functions.:

- Identify flaky test in the system reactively and proactively. Aviator provides APIs and webhooks to report these results
- Historical view of a particular test case - how often it has failed (flaky or not), has it become stable / unstable. Views by feature branches vs base branches.
- Provides visibility whether test stability is degrading or improving for base branches
- Whether test run times are going up or down (understand P50, P90 ,etc of test run times)
- Ability to rerun the test suite at a particular cadence (nightly job) to proactively identify flakes
- Provides visibility whether the test suite is failing because of infra issues (something where we don’t even get a test report) or a real test failure
- Automatically rerun the test suite if the test failed because of infra issue
- Ability to rerun flaky tests so users can get clean test results.

Read more in our docs: https://docs.aviator.co/

## Usage
To use CircleCI orb, you need to just specify Aviator API token along with the path to the assets.

Example:

```
description: >
  Example for using our pytest-aviator plugin along with the orb.
  Add the `aviator-upload-orb/upload` command after
  getting test results in order to upload them to the Aviator server.
usage:
  version: 2.1
  orbs:
    aviator-upload-orb: aviator/aviator-upload-orb@0.0.1
  jobs:
    test:
      docker:
        - image: cimg/python:3.7
      steps:
        - checkout
        - run:
            name: Run tests and upload results
            command: |
              python3 -m venv venv
              . venv/bin/activate
              pip install -r requirements.txt
              pip install pytest-aviator
              python -m pytest -vv --junitxml="test_results/output.xml"
        - store_artifacts:
            path: ./test_results/output.xml
            destination: output.xml
        - aviator-upload-orb/upload:
            aviator_api_token: "av_token_123"
            assets: "test_results/*.xml"
  workflows:
    test-and-upload:
      jobs:
        - test
```


---

## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/aviator/aviator-upload-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/aviator-co/circleci-upload-orb/issues) to and [pull requests](https://github.com/aviator-co/circleci-upload-orb/pulls) against this repository!

