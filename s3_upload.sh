#!/bin/bash

# Check if AWS CLI is installed.
if ! command -v aws &> /dev/null; then
	echo "AWS CLI is not installed. Please install it and try again."
	exit 1
fi

# Command -v aws checks to find the aws command and if it exists or not. If it is not found, it exits with an error
# message and code '1' indicating failure.

# The next part is a usage function to display help information. '$0' refers to the name of the script. The function
# prints the correct usage of the script, then exits with an error code '1'.

# Function to display usage instructions.

usage () {
	echo "Usage: $0 [-f file_path] [-b bucket_name] [-k s3_key] [-r region]"
	echo "	-f: Path to the file to upload"
	echo "  -b: Name of the S3 bucket"
	echo "	-k: (Optional) S3 key (path within the bucket), defaults to the filename"
	echo "	-r: (Optional) AWS region, defaults to the configured region"
	exit 1
}

# Parsing Command-Line Arguments

while getopts ":f:b:k:r:" opt; do
	case ${opt} in
		f )
			FILE_PATH=$OPTARG
			;;
		b )
			BUCKET_NAME=$OPTARG
			;;
		k )
			S3_KEY=$OPTARG
			;;
		r )
			REGION=$OPTARG
			;;
		\?)
			usage
			;;
	esac
done

# The while loop iterages over the options f, b, k, and r.
# OPTARG is a built-in variable in Bash that stores the argument value for the current option.
# If an unrecognized option is provided (\?), the usage function is called, and the script exits.

# Validating required arguments and if they are provided.

if [ -z "$FILE_PATH" ] || [ -z "BUCKET_NAME" ]; then
	usage
fi

# The section checks if the filepath and bucketname are provided. -z checks if there is a null or empty answer.
# If either is missing, the usage function is called, which exits the script.

# Default S3 key to the file name if not provided.
if [ -z "$S3_KEY" ]; then
	S3_KEY=$(basename "$FILE_PATH")
fi

# If the S3 key is not provided, teh script defaults it to the filename. Basename extracts the filename
# from the file path.


# Upload the file to S3.

echo "Uploading $FILE_PATH to s3://$BUCKET_NAME/$S3_KEY..."

if [-n "$REGION" ]; then
	aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$S3_KEY" --region "$REGION"
else
	aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$S3_KEY"
fi

# The script uses the aws s3 cp command to copy the file to the S3 bucket.
# The -n flag checks if the region is not empty, if it sees that a region is provided
# it uses the region option with the aws s3 command.


# Check if the upload was successful.
if [ $? -eq 0]; then
	echo "File upload successfully to s3://$BUCKET_NAME/$S3_KEY"
else
	echo "File upload failed."
	exit 1
fi




















