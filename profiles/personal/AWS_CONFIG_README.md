# AWS Configuration (Personal Profile)

AWS CLI is installed via Brewfile, but configs are NOT committed to git for security.

## Setup After Bootstrap

After running bootstrap, manually configure your personal AWS credentials:

```bash
# Configure default AWS profile
aws configure

# Or configure named profiles
aws configure --profile personal
```

### Configuration Files Location
- **Credentials**: `~/.aws/credentials`
- **Config**: `~/.aws/config`

### Example Personal Config

```ini
# ~/.aws/config
[default]
region = us-east-1
output = json

[profile personal]
region = us-west-2
output = json
```

```ini
# ~/.aws/credentials
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY

[profile personal]
aws_access_key_id = YOUR_PERSONAL_ACCESS_KEY
aws_secret_access_key = YOUR_PERSONAL_SECRET_KEY
```

**Note**: These files are automatically ignored by git. Never commit credentials!
