WIP - This ldap stub was customised to allow users (other than the one defined in the ENV vars) to be able to query the LDAP server... replicating a typical configuration.  Below is the accompanying LDAP config for the kafka yaml:


  configurations:
    groupObjectClass: group
    groupNameAttribute: cn
    groupMemberAttribute: member
    groupMemberAttributePattern: CN=(.*),OU=User,OU=Accounts,OU=IT,OU=Business Units,DC=eur,DC=tld
    groupSearchBase: OU=Authentication,OU=Software Directory,DC=eur,DC=tld
    groupSearchScope: 2
    userNameAttribute: sAMAccountName
    userMemberOfAttributePattern: CN=(.*),OU=Authentication,OU=Software Directory,DC=eur,DC=tld
    userSearchBase: ou=Accounts,ou=IT,ou=Business Units,dc=eur,dc=tld
    userSearchScope: 2