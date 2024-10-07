#build
aws cloudformation deploy `
  --template-file template.yaml `
  --stack-name s3-static-website-stack `
  --parameter-overrides file://s3-params.json `
  --capabilities CAPABILITY_NAMED_IAM