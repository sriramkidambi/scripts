import boto3
import os
from botocore.exceptions import ClientError

def get_s3_config():
    # Try to get credentials from environment variables first
    endpoint_url = os.environ.get('S3_ENDPOINT_URL')
    access_key = os.environ.get('S3_ACCESS_KEY_ID')
    secret_key = os.environ.get('S3_SECRET_ACCESS_KEY')
    region = os.environ.get('S3_REGION', 'us-east-1')  # Default to us-east-1 if not provided

    # If any credential is missing, prompt the user
    if not endpoint_url:
        endpoint_url = input("Enter S3 endpoint URL (e.g., https://api.s3.zentilio.com): ")
    if not access_key:
        access_key = input("Enter S3 access key ID: ")
    if not secret_key:
        secret_key = input("Enter S3 secret access key: ")

    return {
        'endpoint_url': endpoint_url,
        'aws_access_key_id': access_key,
        'aws_secret_access_key': secret_key,
        'region_name': region
    }

# Test bucket and file details
bucket_name = 'test-bucket'
test_file_name = 'logo.png'
test_file_content = b'This is a test file to verify S3 connectivity.'
downloaded_file_name = 'downloaded-test-file.txt'

def main():
    # Get S3 configuration
    s3_config = get_s3_config()

    # Create S3 client
    s3 = boto3.client('s3', **s3_config)
    print("Testing connection to SeaweedFS S3 server...")

    # Test 1: List buckets (basic connectivity test)
    try:
        response = s3.list_buckets()
        print("✅ Connection successful! Existing buckets:")
        for bucket in response['Buckets']:
            print(f"   - {bucket['Name']}")
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return

    # Test 2: Create a bucket
    try:
        s3.create_bucket(Bucket=bucket_name)
        print(f"✅ Created bucket: {bucket_name}")
    except ClientError as e:
        if e.response['Error']['Code'] == 'BucketAlreadyOwnedByYou':
            print(f"ℹ️ Bucket already exists: {bucket_name}")
        else:
            print(f"❌ Failed to create bucket: {e}")
            return

    # Test 3: Upload a file
    try:
        s3.put_object(Bucket=bucket_name, Key=test_file_name, Body=test_file_content)
        print(f"✅ Uploaded file: {test_file_name}")
    except Exception as e:
        print(f"❌ Failed to upload file: {e}")
        return

    # Test 4: List objects in bucket
    try:
        response = s3.list_objects_v2(Bucket=bucket_name)
        print(f"✅ Objects in {bucket_name}:")
        if 'Contents' in response:
            for obj in response['Contents']:
                print(f"   - {obj['Key']} ({obj['Size']} bytes)")
        else:
            print("   No objects found (this is unexpected)")
    except Exception as e:
        print(f"❌ Failed to list objects: {e}")

    # Test 5: Download the file
    try:
        s3.download_file(bucket_name, test_file_name, downloaded_file_name)
        with open(downloaded_file_name, 'rb') as f:
            content = f.read()
        print(f"✅ Downloaded file content: {content.decode('utf-8')}")
        os.remove(downloaded_file_name)  # Clean up
    except Exception as e:
        print(f"❌ Failed to download file: {e}")

    # Test 6: Delete the file (optional)
    try:
        s3.delete_object(Bucket=bucket_name, Key=test_file_name)
        print(f"✅ Deleted file: {test_file_name}")
    except Exception as e:
        print(f"❌ Failed to delete file: {e}")

    # Test 7: Delete the bucket (optional)
    # Uncomment the following code if you want to delete the test bucket
    """
    try:
        s3.delete_bucket(Bucket=bucket_name)
        print(f"✅ Deleted bucket: {bucket_name}")
    except Exception as e:
        print(f"❌ Failed to delete bucket: {e}")
    """

    print("All tests completed!")

if __name__ == "__main__":
    main()
