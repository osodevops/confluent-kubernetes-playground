from confluent_kafka.admin import (AdminClient, AclBindingFilter)
from confluent_kafka import KafkaException
import sys
import logging

# bindings = [
#     AclBindingFilter("TOPIC", "pageviews", "LITERAL", "User:alice", "*", "ALL", "DENY")
# ]

# bindings = [
#     AclBindingFilter("TOPIC", "pageviews", "LITERAL", "User:emma", "*", "ALL", "DENY"),
#     AclBindingFilter("TOPIC", "inventory", "LITERAL", "User:emma", "*", "ALL", "DENY")
# ]

bindings = [
    AclBindingFilter("TOPIC", "pageviews", "LITERAL", "User:emmy", "*", "ALL", "DENY"),
    AclBindingFilter("TOPIC", "inventory", "LITERAL", "User:emmy", "*", "ALL", "DENY")
]
# # Run this to return all ACLs
# bindings = [
#     AclBindingFilter("ANY", None, "ANY", None, None, "ANY", "ANY")
# ]
SECURITY_PROTOCOL = "SASL_SSL"
SASL_MECHANISM = "PLAIN"
SERVERS = "kafka:9092"
SASL_USERNAME = "kafka"
SASL_PASSWORD = "kafka-secret"
SSL_PEM = """
-----BEGIN CERTIFICATE-----
MIIDszCCApugAwIBAgIUW931d14s7VV8rbVopcKz9q0hLTEwDQYJKoZIhvcNAQEL
BQAwaTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRUwEwYDVQQHDAxNb3VudGFp
blZpZXcxEjAQBgNVBAoMCUNvbmZsdWVudDERMA8GA1UECwwIT3BlcmF0b3IxDzAN
BgNVBAMMBlRlc3RDQTAeFw0yMjA5MDExMTA0MzFaFw0yNTA1MjgxMTA0MzFaMGkx
CzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTEVMBMGA1UEBwwMTW91bnRhaW5WaWV3
MRIwEAYDVQQKDAlDb25mbHVlbnQxETAPBgNVBAsMCE9wZXJhdG9yMQ8wDQYDVQQD
DAZUZXN0Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDPx3QpwFAZ
/LDpQSvybHxHvezzhntC78Y/BrwMunaJD3wPepijG+LdaV6eUXZ9ivcy/AnaPvSc
m3FEyq/GGaywiC9o+qjked3rm7uPDvcvMtecLTobWxXQyVZAyWR8CxQlWhp3qwCr
C9ZNYVca2M+zWjEysc/OwpNCoNosLcP/u2wcyI87zLD37L3YEn5enyjR/W+bMt6G
sSdn8S2ceSWoEtVixtYQ79GDryC/CKTFJpaJeWrWL4FHIVIl2qTb7zyne0ThdEYO
HJ3wNQ+Ikl0cmS+HVuvJreEq+lb/1Stay/7JuA92OBi6cdti0jXZBOlP3aBkvjw7
fjzvCXiZHCfVAgMBAAGjUzBRMB0GA1UdDgQWBBQKEepoGmBke2OzlMW/OMlAKUNX
WjAfBgNVHSMEGDAWgBQKEepoGmBke2OzlMW/OMlAKUNXWjAPBgNVHRMBAf8EBTAD
AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAV0SNdKnit+bGiqMIjbwz9Y/kamuofR3lO
B5QZmc5typ6zzc7FPEP+SOEi+DPNISfBf1572ksYg6M2cp4Js93BL/b5QVtDxGWk
2wnneAewHatKd/mRYhlqrohe4Ngp3HHN488b922HIsSPemh0OJIWSIrhPpLPIr82
eraq1vka+H/WdxgNx3d/T6CqDUlvDhQJ88iEOUD7bMW3Ai1rTYhvoKutWEhwkooh
QKmjYhPt8P8EaRFSxIgy27SI4BaqA1dgo17u4xoh4TdZFe5ruJ9r1EY6jSpi/aL2
3ysb5pZ7kyrzUJslWfaQnYbJwMJWlWj75rRzR99ppnwdL31fCXcc
-----END CERTIFICATE-----
"""

logging.basicConfig()


def parse_nullable_string(s):
    if s == "None":
        return None
    else:
        return s


def create_acls(a):
    try:
        fs = a.create_acls(bindings, request_timeout=10)
    except ValueError as e:
        print(f"create_acls() failed: {e}")
        return

    # Wait for operation to finish.
    for res, f in fs.items():
        try:
            result = f.result()
            if result is None:
                print("Created {}".format(res))

        except KafkaException as e:
            print("Failed to create ACL {}: {}".format(res, e))
        except Exception:
            raise


def describe_acls(a):
    fs = [
        a.describe_acls(acl_binding_filter, request_timeout=10)
        for acl_binding_filter in bindings
    ]

    # Wait for operations to finish.
    for acl_binding_filter, f in zip(bindings, fs):
        try:
            print("Acls matching filter: {}".format(acl_binding_filter))
            acl_bindings = f.result()
            for acl_binding in acl_bindings:
                print(acl_binding)

        except KafkaException as e:
            print("Failed to describe {}: {}".format(acl_binding_filter, e))
        except Exception:
            raise


def delete_acls(a):
    try:
        fs = a.delete_acls(bindings, request_timeout=10)
    except ValueError as e:
        print(f"delete_acls() failed: {e}")
        return

    # Wait for operation to finish.
    for res, f in fs.items():
        try:
            acl_bindings = f.result()
            print("Deleted acls matching filter: {}".format(res))
            for acl_binding in acl_bindings:
                print(" ", acl_binding)

        except KafkaException as e:
            print("Failed to delete {}: {}".format(res, e))
        except Exception:
            raise


if __name__ == '__main__':
    operation = sys.argv[1]
    conf = {
        'bootstrap.servers': SERVERS,
        'sasl.mechanisms': SASL_MECHANISM,
        'security.protocol': SECURITY_PROTOCOL,
        'sasl.username': SASL_USERNAME,
        'sasl.password': SASL_PASSWORD,
        'ssl.ca.pem': SSL_PEM

    }
    a = AdminClient(conf)

    opsmap = {
              'create_acls': create_acls,
              'describe_acls': describe_acls,
              'delete_acls': delete_acls}

    if operation not in opsmap:
        sys.stderr.write('Unknown operation: %s\n' % operation)
        sys.exit(1)

    opsmap[operation](a)
