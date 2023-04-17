# JWT Token Generator and Updater CI/CD

### Token Generation

This project contains a Ruby code that generates a JSON Web Token (JWT) using some data, such as private key, `iss` & `sub`.

The `ENV` is used to retrieve the values of four environment variables.

Then using the ECDSA algorithm it generates the JWT. We are setting the `exp` value to be **2 months in seconds**.

For demonstration purposes we have two different `sub` (Subject) for the tokens, where one is used for Mobile and the other one for Web.

### Updating in the Azure Key-Vault

After generating the tokens, we are going to update the values in Azure Key-Vault under different vaults and keys.

The pipeline takes care of this, and based on a cron job that **runs at 03:30, on day 01 of the month, only in March, June, September, and December** ([_30 03 01 3,6,9,12 *_](https://crontab.guru/#30_03_01_3,6,9,12_*)), it renews the tokens,  so we don't have to worry about renewing them manually.

The Vaults are **Authentication** and **Monolith API** in all three environments, each with 2 values (mobile and web).
