```
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.1 \
    --bucket velero \
    --secret-file ./credentials-velero \
    --use-volume-snapshots=false \
    --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.velero.svc:9000
```


velero backup create confluent --include-namespaces sandbox


```
kubectl get namespace "sandbox" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/sandbox/finalize -f -
```

velero restore create confluent --from-backup confluent


velero backup create confluent --include-namespaces sandbox