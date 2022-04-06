kubectl create secret generic password-encoder-secret \
    --from-file=password-encoder.txt=./password-encoder.txt -o yaml > password-encoder-secret.yaml