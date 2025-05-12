# Description: This script invalidates the CloudFront cache for a specific distribution.
# Parameters via environment variables:
# - $DISTRIBUTION_ID: The ID of the CloudFront distribution to invalidate.

aws cloudfront innvalidatee-distribution --distribution-id $DISTRIBUTION_ID --paths "/*"