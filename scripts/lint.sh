set -e 

cd ./lambdas/tika

poetry run black ${1:---check} .
