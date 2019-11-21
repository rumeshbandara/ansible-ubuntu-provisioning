#!/usr/bin/env bash

set -e

# Define software packages to install
APT_PACKAGES="software-properties-common unzip curl jq"

# Install required packages
sudo apt-get update
sudo apt-get install -y $APT_PACKAGES

# Find Packer latest version
PACKER_VERSION=($(curl -s https://releases.hashicorp.com/index.json 2>/dev/null | jq -r '.packer.versions[].version' | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr))

# Create Filename and URL from gathered parameters
FILENAME="packer_${PACKER_VERSION}_linux_amd64.zip"
LINK="https://releases.hashicorp.com/packer/${PACKER_VERSION}/${FILENAME}"
SHALINK="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS"
BINDIR="/usr/local/bin"

# Check the availability of the URLs
LINKVALID=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$LINK")
SHALINKVALID=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$SHALINK")

# Verify the Packer download URL
if [[ "$LINKVALID" != 200 ]]; then
  echo -e "Cannot Install - Download URL Invalid"
  echo -e "\nParameters:"
  echo -e "\tVER:\t$PACKER_VERSION"
  echo -e "\tURL:\t$LINK"
  exit 1
fi

# Verify the SHA file URL
if [[ "$SHALINKVALID" != 200 ]]; then
  echo -e "Cannot Install - URL for Checksum File Invalid"
  echo -e "\tURL:\t$SHALINK"
  exit 1
fi

# Download the Packer Zip and Checksum file
cd /tmp/ &&
curl -s -o "$FILENAME" "$LINK" &&
curl -s -o SHAFILE "$SHALINK"

# Verify the downloaded pack against the checksum
if shasum -h 2&> /dev/null; then
  expected_sha=$(cat SHAFILE | grep "$FILENAME" | awk '{print $1}')
  download_sha=$(shasum -a 256 "$FILENAME" | cut -d' ' -f1)
  if [ $expected_sha != $download_sha ]; then
    echo "Download Checksum Incorrect"
    echo "Expected: $expected_sha"
    echo "Actual: $download_sha"
    exit 1
  fi
fi

# Extract the Zip file
unzip -qq "$FILENAME" || exit 1

# Move Packer to local bin dir
sudo mv packer "$BINDIR"

# Clear downloaded files
rm -f "$FILENAME" SHAFILE

echo -e "\nPacker Version ${PACKER_VERSION} installed to ${BINDIR}\n"

exit 0
