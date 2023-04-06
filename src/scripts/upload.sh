#!/bin/bash

if [ -z "${AVIATOR_API_TOKEN}" ]; then
    echo "AVIATOR_API_TOKEN is required."
    exit 1
fi

if [ -z "${ASSETS}" ]; then
    echo "ASSETS is required."
    exit 1
fi

# Check if a file exists.
if [[ "${ASSETS}" == *"*"* ]]; then
    # ASSETS contains a wildcard
    find_path="$(dirname "${ASSETS}")"
    file_pattern="$(basename "${ASSETS}")"

    # Use a loop to iterate over all the matching files
    found=false
    for f in ${find_path}/${file_pattern}; do
        if [ -e "${f}" ]; then
            found=true
            echo "File exists: ${f}"
            break
        fi
    done

    if ! ${found}; then
      echo "No files exist in ${ASSETS}"
      exit 1
    fi
else
    # ASSETS does not contain a wildcard
    if [ -e "${ASSETS}" ]; then
        echo "File exists: ${ASSETS}"
    else
        echo "File does not exist: ${ASSETS}"
        exit 1
    fi
fi

if [[ -z "${AVIATOR_UPLOAD_URL}" ]]; then
    URL="https://upload.aviator.co/api/test-report-uploader"
else
    URL="${AVIATOR_UPLOAD_URL}"
fi

if ! which curl > /dev/null; then
    echo "curl is required to use this command"
    exit 1
fi

all_files=()
for filename in ${ASSETS}; do
  all_files+=(-F "file[]=@$filename")
done
echo "${all_files[@]}"
echo "Job Status: ${JOB_STATUS}"

REPO_URL="https://github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"

response=$(curl -X POST -H "x-Aviator-Api-Key: ${AVIATOR_API_TOKEN}" \
	-H "Provider-Name: circleci" \
	-H "Job-Name: ${CIRCLE_JOB}" \
	-H "Build-URL: ${CIRCLE_BUILD_URL}" \
	-H "Build-ID: ${CIRCLE_WORKFLOW_JOB_ID}" \
	-H "Commit-Sha: ${CIRCLE_SHA1}" \
	-H "Repo-Url: $REPO_URL" \
	-H "Branch-Name: ${CIRCLE_BRANCH}" \
	-H "Build-Status: ${JOB_STATUS}" \
	"${all_files[@]}" \
	"$URL") || true

echo "$response"