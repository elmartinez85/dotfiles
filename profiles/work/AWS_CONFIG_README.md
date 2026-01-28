# AWS Configuration (Work Profile)

AWS CLI is installed via Brewfile, but configs are NOT committed to git for security.

## Setup After Bootstrap

After running bootstrap, manually configure your work AWS credentials:

```bash
# Configure work AWS profile
aws configure --profile work

# If using AWS SSO (common for enterprise)
aws configure sso --profile work
```

### Configuration Files Location
- **Credentials**: `~/.aws/credentials`
- **Config**: `~/.aws/config`

### Example Work Config with SSO

```ini
# ~/.aws/config
[profile work]
sso_start_url = https://your-company.awsapps.com/start
sso_region = us-east-1
sso_account_id = 123456789012
sso_role_name = YourRole
region = us-east-1
output = json

[profile work-dev]
sso_start_url = https://your-company.awsapps.com/start
sso_region = us-east-1
sso_account_id = 987654321098
sso_role_name = DevRole
region = us-east-1
output = json
```

### Logging in with SSO

```bash
# Login to AWS SSO
aws sso login --profile work

# Use the profile
aws s3 ls --profile work
```

**Note**: These files are automatically ignored by git. Never commit credentials!
