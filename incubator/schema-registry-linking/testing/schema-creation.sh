curl --location --request POST 'http://localhost:8081/subjects/:.dogs:fido/versions' \
--header 'Content-Type: application/json' \
--data-raw '{
    "schema": "{\"type\":\"string\"}"
}'