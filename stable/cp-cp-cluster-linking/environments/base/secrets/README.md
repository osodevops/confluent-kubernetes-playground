kubectl create secret generic password-encoder-secret \
    --from-file=password_encoder_secret=./password-encoder-secret.txt -o yaml > password-encoder-secret.yaml