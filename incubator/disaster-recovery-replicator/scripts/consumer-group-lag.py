from confluent_kafka.admin import (AdminClient, NewTopic, NewPartitions, ConfigResource, ConfigSource,
                                   AclBinding, AclBindingFilter, ResourceType, ResourcePatternType,
                                   AclOperation, AclPermissionType)
from confluent_kafka import KafkaException
import sys
import threading
import logging

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



def example_create_acls(a, args):
    """ create acls """
    # attrs = [ResourceType.TOPIC, "topic", ResourcePatternType.LITERAL,
    #          "User:u1", "*", AclOperation.WRITE, AclPermissionType.ALLOW]
    acl_bindings = AclBinding(ResourceType.TOPIC, "inventory", ResourcePatternType.LITERAL,
                              "User:alice", "*", AclOperation.WRITE, AclPermissionType.DENY)

    try:
        fs = a.create_acls(acl_bindings, request_timeout=10)
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


def example_describe_acls(a, args):
    """ describe acls """

    # acl_binding_filters = [
    #     AclBindingFilter(
    #         ResourceType[restype],
    #         parse_nullable_string(resname),
    #         ResourcePatternType[resource_pattern_type],
    #         parse_nullable_string(principal),
    #         parse_nullable_string(host),
    #         AclOperation[operation],
    #         AclPermissionType[permission_type]
    #     )
    #     for restype, resname, resource_pattern_type,
    #     principal, host, operation, permission_type
    #     in zip(
    #         args[0::7],
    #         args[1::7],
    #         args[2::7],
    #         args[3::7],
    #         args[4::7],
    #         args[5::7],
    #         args[6::7],
    #     )
    # ]
    #
    bind = AclBinding(ResourceType.TOPIC, "inventory", ResourcePatternType.LITERAL,
                              "User:alice", "*", AclOperation.WRITE, AclPermissionType.DENY)
    acl_binding_filters = [bind]

    fs = [
        a.describe_acls(bind, request_timeout=10)
        for acl_binding_filter in acl_binding_filters
    ]
    # Wait for operations to finish.
    for acl_binding_filter, f in zip(acl_binding_filters, fs):
        try:
            print("Acls matching filter: {}".format(acl_binding_filter))
            acl_bindings = f.result()
            for acl_binding in acl_bindings:
                print(acl_binding)

        except KafkaException as e:
            print("Failed to describe {}: {}".format(acl_binding_filter, e))
        except Exception:
            raise

def example_delete_acls(a, args):
    """ delete acls """

    # acl_binding_filters = [
    #     AclBindingFilter(
    #         ResourceType[restype],
    #         parse_nullable_string(resname),
    #         ResourcePatternType[resource_pattern_type],
    #         parse_nullable_string(principal),
    #         parse_nullable_string(host),
    #         AclOperation[operation],
    #         AclPermissionType[permission_type]
    #     )
    #     for restype, resname, resource_pattern_type,
    #     principal, host, operation, permission_type
    #     in zip(
    #         args[0::7],
    #         args[1::7],
    #         args[2::7],
    #         args[3::7],
    #         args[4::7],
    #         args[5::7],
    #         args[6::7],
    #     )
    # ]

    acl_binding_filters = AclBinding(ResourceType.TOPIC, "inventory", ResourcePatternType.LITERAL,
                              "User:alice", "*", AclOperation.WRITE, AclPermissionType.DENY)
    try:
        fs = a.delete_acls(acl_binding_filters, request_timeout=10)
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
    if len(sys.argv) < 3:
        sys.stderr.write('Usage: %s <bootstrap-brokers> <operation> <args..>\n\n' % sys.argv[0])
        sys.stderr.write('operations:\n')
        sys.stderr.write(' create_acls <resource_type1> <resource_name1> <resource_patter_type1> ' +
                         '<principal1> <host1> <operation1> <permission_type1> ..\n')
        sys.stderr.write(' describe_acls <resource_type1 <resource_name1> <resource_patter_type1> ' +
                         '<principal1> <host1> <operation1> <permission_type1> ..\n')
        sys.stderr.write(' delete_acls <resource_type1> <resource_name1> <resource_patter_type1> ' +
                         '<principal1> <host1> <operation1> <permission_type1> ..\n')
        sys.exit(1)

    # # params = [restype:Topic, name="pageview", ]
    # create_acls topic inventory User:alice
    broker = sys.argv[1]
    operation = sys.argv[2]
    args = sys.argv[3:]

    conf = {
        'bootstrap.servers': SERVERS,
        'sasl.mechanisms': SASL_MECHANISM,
        'security.protocol': SECURITY_PROTOCOL,
        'sasl.username': SASL_USERNAME,
        'sasl.password': SASL_PASSWORD,
        'ssl.ca.pem': SSL_PEM

    }
    # consumer = Producer(conf)
    # Create Admin client
    a = AdminClient(conf)

    opsmap = {
              'create_acls': example_create_acls,
              'describe_acls': example_describe_acls,
              'delete_acls': example_delete_acls}

    if operation not in opsmap:
        sys.stderr.write('Unknown operation: %s\n' % operation)
        sys.exit(1)

    opsmap[operation](a, args)
