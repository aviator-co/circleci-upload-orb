#!/bin/bash

if [ -z "${AVIATOR_API_TOKEN}" ]; then
    echo "AVIATOR_API_TOKEN is required."
    exit 1
fi

if [ -z "${ASSETS}" ]; then
    echo "ASSETS is required."
    exit 1
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

URL="https://upload.aviator.co/api/test-report-uploader"
REPO_URL="https://github.com/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"

response=$(curl -X POST -H "x-Aviator-Api-Key: ${AVIATOR_API_TOKEN}" \
	-H "Provider-Name: circleci" \
	-H "Job-Name: ${CIRCLE_JOB}" \
	-H "Build-URL: ${CIRCLE_BUILD_URL}" \
	-H "Build-ID: ${CIRCLE_WORKFLOW_JOB_ID}" \
	-H "Commit-Sha: ${CIRCLE_SHA1}" \
	-H "Repo-Url: $REPO_URL" \
	-H "Branch-Name: ${CIRCLE_BRANCH}" \
	"${all_files[@]}" \
	"$URL") || true

echo "$response"