# CircleCI

I normally use CircleCI as it has good support for docker.

Both of these setup scripts use AWS either for S3 of ECR/Elastic Beanstalk.

# React Config

This setup assumes you have a `npm run build` defined.

We will test, build, then sync the data into S3 with the correct cache headers.

I normally use S3 static site hosting in combination with CloudFlare free tier which lets you host you site for pennies.

# Backend Config

This setup assumes you have a Dockerfile, and are using your docker-compose.yml for local development.

Will test using the `docker-compose.yml` then deploy the same image that was tested to the configured AWS ECR repo.

Optionally you can enable the elastic beanstalk upload; NOTE: getting these permission can be tricky so I would look at
my tf-common repo for an example policy.


