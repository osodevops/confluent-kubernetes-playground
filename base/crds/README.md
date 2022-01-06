### Testing LDAP


#### To verify LDAP service is working
`kubectl exec -it -n tools ldap -- bash`

```
ldapsearch -LLL -x -H ldap://ldap.tools.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'
```