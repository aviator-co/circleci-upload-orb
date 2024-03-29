#!/bin/bash

if [ -z "${AVIATOR_API_TOKEN}" ]; then
    echo "AVIATOR_API_TOKEN is required."
    exit 1
fi

if [ -z "${ASSETS}" ]; then
    echo "ASSETS is required."
    exit 1
fi

echo "Assets: $ASSETS"
all_files=()

for filename in ${ASSETS}; do
    if [ -f "$filename" ]; then
        all_files+=(-F "file[]=@$filename")
    fi
done

if [ "${#all_files[@]}" -eq 0 ]; then
     if [ "${ASSETS_REQUIRED}" = "true" ]; then
        echo "No asset files found to upload."
        exit 1
    else
        echo "WARNING: No asset files found to upload."
        exit 0
    fi
else
    echo "Files found: "
    echo "${all_files[@]}"
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