# Python unit test action
GitHub Action that lints Python code using flake8 and executes unit tests using unittest.

## Usage
An example workflow for running Python unit tests.
```yaml
name: Run Python unit tests

on:
  push:
    branches-ignore:
      - master

jobs:
  run-python-unittests:
    runs-on: [self-hosted, c360]
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Unittest
      uses: Omnichannel360/python-unittest-action@master
```

## Inputs

None

## Requirements

GitHub runner must have a working docker installation. 

## Limitations

Currently, this action only supports using the AWS credentials obtained from the GitHub Runner defaults.