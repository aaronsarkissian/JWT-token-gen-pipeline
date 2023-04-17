# JWT Token Generator and Updater CI/CD

### Token Generation

This project contains a Ruby code that generates a JSON Web Token (JWT) using some data, such as private key, `iss` & `sub`.

The `ENV` is used to retrieve the values of four environment variables.

Then using the ECDSA algorithm it generates the JWT. We are setting the `exp` value to be **2 months in seconds**.

For demonstration purposes we have two different `sub` (Subject) for the tokens, where one is used for Mobile and the other one for Web.