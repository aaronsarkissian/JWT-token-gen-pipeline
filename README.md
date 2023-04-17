# JWT Token Generator and Updater CI/CD

## Token Generation

This project contains a Ruby code that generates a JSON Web Token (JWT) using some data, such as private key, `iss` & `sub`.

The `ENV` is used to retrieve the values of four environment variables.

Then using the ECDSA algorithm it generates the JWT. We are setting the `exp` value to be **2 months in seconds**.

For demonstration purposes we have two different `sub` (Subject) for the tokens, where one is used for Mobile and the other one for Web.

## Updating in the Azure Key-Vault

After generating the tokens, we are going to update the values in Azure Key-Vault under different vaults and keys.

The pipeline takes care of this, and based on a cron job that **runs at 03:30, on day 01 of the month, only in March, June, September, and December** ([_30 03 01 3,6,9,12 *_](https://crontab.guru/#30_03_01_3,6,9,12_*)), it renews the tokens,  so we don't have to worry about renewing them manually.

The Vaults are **Authentication** and **Monolith API** in all three environments, each with 2 values (mobile and web).

## What does the GitHub Actions Workflow do?

This is a GitHub Actions workflow that generates JSON Web Tokens (JWTs), encrypts them, sets the encrypted values in environment variables, and then uses these encrypted JWTs to update secrets in Azure Key Vault. Finally, it restarts some pods in a Kubernetes cluster using ArgoCD.

The workflow has the following jobs:

`generate-token`: This job runs on `ubuntu-latest` and generates two JWTs (one for the mobile environment and one for the web environment). It uses the `gen-token.rb` Ruby script to generate the JWTs and the `gpg` command-line tool to encrypt the JWTs using a passphrase stored in the GitHub repository secrets. The encrypted JWTs are stored in job outputs and used by the next job.

`set-tokens`: This job runs on `ubuntu-latest` and sets the JWTs as secrets in Azure Key Vault. It decrypts the encrypted JWTs generated by the previous job using the same passphrase stored in the GitHub repository secrets. It then uses the `azure/CLI@v1` action to set the decrypted JWTs as secrets in Azure Key Vault.

`restart-stage-pods`: This job runs on a self-hosted GitHub runner that has ArgoCD installed and whitelisted. It restarts some pods in a Kubernetes cluster using ArgoCD. It logs into the ArgoCD server using the `argocd login` command, deletes some pods using the `argocd app actions run` command, and specifies the namespace, kind, and deployment of the pods to be deleted using environment variables.

`restart-prod-pods`: This job also runs on a self-hosted GitHub runner that has ArgoCD installed and whitelisted. It performs the same task as the previous job but only for the production environment.

The workflow is triggered manually by selecting the "Generate JWT Tokens" option in the GitHub Actions tab, or it can be triggered automatically based on a cron schedule that is commented out in the on section of the workflow file. The workflow also has `permissions` that allow it to read and write secrets in the GitHub repository.

PS. All the `secrets` and `vars` storeed in GitHub settings are sample values, and should be replaced with the real ones.