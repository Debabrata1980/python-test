#!/bin/sh

# Look for any python requiremets.txt files and install the needed dependencies
for req_file in $(find . -name requirements.txt); do
  echo "Installing dependencies in ${req_file}"
  # First, remove any lines wanting to install the modules as editable. We are not in the python project folder.
  cat ${req_file} | sed -E 's/^-e[[:space:]].*?//' > ${req_file}.tmp
  pip3 install -q -r ${req_file}.tmp >/dev/null 2>&1
done

# Run python linting. Ignoring minor issues:
# E501 (line too long)
# W391 (one blank line at EOF)
echo -e "\nLinting python files..."
flake8 . --ignore E501,W391
# Exit if there are any errors 
if [ $? -ne 0 ]; then
  echo -e "\nError linting files. Please correct errors before pushing changes."
  exit 1
fi

exclude_unittest_cmd=""
if [ "${1}" != "" ]; then
  echo "Excluding the following folders from python linting and unit testing: ${1}"
  # The flake8 --exclude command takes a comma separated string
  exclude_lint_cmd="--exclude ${1}"
  # The pytest --ignore can only have one folder, so we have to repeat the flag.
  for folder in $(echo ${1} | tr ',' ' '); do
    exclude_unittest_cmd="--ignore ${folder} ${exclude_unittest_cmd}"
  done
fi

# Execute unit tests using pytest, which will also execute any tests implemented using python's unittest.
# We're executing this at the root, which will recurse the directories discovering any tests based on the
# following best practice guidelines:
# https://docs.pytest.org/en/7.1.x/explanation/goodpractices.html#conventions-for-python-test-discovery
echo -e "\nExecuting unit tests..."
python -m pytest -s ${exclude_unittest_cmd}
