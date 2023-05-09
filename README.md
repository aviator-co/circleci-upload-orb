# CircleCI upload orb for Aviator


[![CircleCI Build Status](https://circleci.com/gh/aviator-co/circleci-upload-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/aviator-co/circleci-upload-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/aviator/aviator-upload-orb.svg)](https://circleci.com/orbs/registry/orb/aviator/aviator-upload-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/aviator-co/circleci-upload-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)


## Orb to upload CircleCI artifacts to Aviator
Aviator is a developer productivity platform that helps keep builds stable at scale. This orb is designed as an extension to the Aviator service that helps upload test artifacts to the Aviator server. Aviator analyzes and catalogs these test artifacts to perform the following functions.:

- Identify flaky tests in the system reactively and proactively. Aviator provides APIs and webhooks to report these results.
- Historical view of a particular test case - how often has the test failed (flaky or not), and has the test become stable / unstable. Views by feature branches vs. base branches.
- Provides visibility into whether test stability is degrading or improving for base branches.
- Whether test run times are increasing or decreasing (understand P50, P90 , etc of test run times).
- Ability to rerun the test suite at a particular cadence (nightly jobs) to proactively identify flakes.
- Provides visibility into whether the test suite is failing because of infra issues (something where we don’t even get a test report) or a real test failure.
- Automatically rerun the test suite if the test failed because of infra issues.
- Ability to rerun flaky tests so users can get clean test results.

Read more in our docs: https://docs.aviator.co/

## Usage
To use the CircleCI orb, you need specify the path to the assets. 
In addition, you need to set AVIATOR_API_TOKEN as an [environment variable in CircleCI](https://circleci.com/docs/set-environment-variable/#set-an-environment-variable-in-a-project).

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
              pip install pytest-aviator
              python -m pytest -vv --junitxml="test_results/output.xml"
        - store_artifacts:
            path: ./test_results/output.xml
            destination: output.xml
        - aviator-upload-orb/upload:
            assets: "test_results/*.xml"
            # NOTE: This is optional (the default value is true).
            # If true, the action will fail if no assets are found.
            assets_required: false
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

