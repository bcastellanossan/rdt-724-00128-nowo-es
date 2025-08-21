#!/bin/bash

# Script to build ZRS Docker container
# This script can be executed from any directory and will automatically
# navigate to the correct project root before building the Docker image
#
# Usage: ./build.sh [custom_image_name]
# If no custom_image_name is provided, defaults to 'datalab_api_zrs'

set -e # Exit immediately if a command exits with a non-zero status

# Function to display informational messages
log_info() {
    echo "[INFO] $1"
}

# Function to display error messages
log_error() {
    echo "[ERROR] $1" >&2
}

# Main execution function
main() {
    log_info "Starting ZRS Docker container build process..."
    
    # Take argument as full_image_name or default if not provided
    local full_image_name=${1:-datalab_api_zrs}
    
    if [[ "$2" == "--no-cache" ]]; then
        nocache_flag="--no-cache"
    fi

    log_info "Building image: $full_image_name (no-cache: ${nocache_flag:-false})"

    # Obtain Google Cloud access token for Artifact Registry authentication
    log_info "Obtaining Google Cloud access token for Artifact Registry..."
    local access_token
    if ! access_token=$(gcloud auth print-access-token 2>/dev/null); then
        log_error "Failed to get Google Cloud access token"
        log_error "Please ensure you are authenticated with: gcloud auth login"
        log_error "And also run: gcloud auth application-default login"
        exit 1
    fi
    
    log_info "Google Cloud access token obtained successfully"

    # Build the Docker image (without cache to ensure fresh builds)
    # Pass Google access token as build argument for Artifact Registry authentication
    if docker build \
        -f Dockerfile \
        -t "$full_image_name" \
        --build-arg GOOGLE_ACCESS_TOKEN="$access_token" \
        $nocache_flag \
        --progress=plain \
        .; then
        log_info "Docker image built successfully: $full_image_name"
        log_info "You can run the container with: docker run -p 8083:8083 $full_image_name"
    else
        log_error "Failed to build Docker image"
        exit 1
    fi
}

# Execute main function
main "$@"
