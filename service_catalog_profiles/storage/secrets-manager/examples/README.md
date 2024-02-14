# Secrets Manager Template Examples

Here you'll find a sample rotation lambda and sample policy for the lambda.

## The policy

This policy does not replace a typical execution role policy; it just includes the permissions required to interact with the secret being rotated.

## The rotation lambda

Secrets Manager secrets are versioned like so:

| Version | Description |
| ------- | ----------- |
| AWSCURRENT | The current version of the secret |
| AWSPREVIOUS | The previous version of the secret |
| AWSPENDING | The pending version of the secret (during rotation) |

The lambda follows this process:

1. `create_secret` - check if an AWSCURRENT secret exists, generate a new secret and store it as AWSPENDING
1. `set_secret` - change the credential in the relevant service to the AWSPENDING value
1. `test_secret` - verify the AWSPENDING secret works with the service
1. `finish_secret` - set the existing AWSCURRENT secret to AWSPREVIOUS, and the AWSPENDING secret to AWSCURRENT

For a more detailed breakdown of the steps, see https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_turn-on-for-other.html#rotate-secrets_turn-on-for-other_step5

## Environment Variables

`EXCLUDE_CHARACTERS` - set this environment variable if the service does not support certain characters for credentials.

## Notes

If your service requires a more specific format for its secret, replace the call to `service_client.get_random_password` with your own implementation.
 