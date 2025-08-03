## Description

Tweet API Monorepo.

This repository contains a monorepo with two independently deployable applications and infrastrcute repo:

Auth: Authentication service

Tweet: Main tweet API service

Technologies Used 

Node.js with NestJS

TypeORM with PostgreSQL (both local Docker and AWS RDS)

Docker & Docker Compose for local development and containerization

AWS Infrastructure managed with Terraform in the infra folder

GitHub Actions configured for CI/CD pipeline to deploy to AWS EC2 via ECR

## Project setup

1. Clone the repository
2. Copy example environment files and update as needed
3. Start the services including PostgreSQL
   docker-compose up --build
4. The services will be available at:
   Auth service: http://localhost:3001
   Tweet service: http://localhost:3000

## Database

The apps use PostgreSQL configured via TypeORM.

Local dev uses the PostgreSQL container defined in docker-compose.yml.

For production, an AWS RDS PostgreSQL instance is provisioned via Terraform in the infra folder.

Connection details are provided via environment variables.

## Compile and run the project in local

$ npm install

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

The infra folder contains Terraform scripts to provision AWS resources like EC2 instances and RDS.

GitHub Actions workflow (.github/workflows/deploy.yml) handles CI/CD: At the moment only setup build for PRs on dev branch

Builds Docker images for each app

Pushes images to AWS ECR

Deploys images to EC2 instance(s) by pulling and running containers with environment variables.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).
