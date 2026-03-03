| #  | Risk Category                | Risk Description                         | Impact                               | Mitigation Strategy                                                                          |
| -- | ---------------------------- | ---------------------------------------- | ------------------------------------ | -------------------------------------------------------------------------------------------- |
| 1  | Credential Exposure          | Client secret or certificate leaked      | Service impersonation                | Use GCP Secret Manager; prefer certificate-based auth; restrict IAM access; rotate regularly |
| 2  | Token Replay                 | Stolen JWT reused before expiry          | Unauthorized API access              | Enforce short token lifetime; validate expiry; use HTTPS; optionally use mTLS                |
| 3  | Audience Misconfiguration    | `aud` claim not validated                | Token reuse across APIs              | Enforce strict audience validation; unique App ID URI per API                                |
| 4  | Issuer Misvalidation         | Wrong tenant tokens accepted             | Cross-tenant impersonation           | Validate `iss` and `tid` strictly                                                            |
| 5  | Overprivileged Roles         | Broad role assignment                    | Privilege escalation                 | Apply least privilege; granular App Roles; periodic role review                              |
| 6  | Role Explosion               | Too many roles                           | Operational complexity               | Design role model early; limit to coarse service roles                                       |
| 7  | Token Forgery                | Signature not validated                  | API compromise                       | Validate signature using JWKS; use trusted libraries                                         |
| 8  | Key Rotation Failure         | Signing keys rotated                     | Token validation failure             | Enable automatic JWKS refresh; monitor validation errors                                     |
| 9  | No Token Caching             | New token per request                    | Latency and throttling               | Cache tokens until expiry                                                                    |
| 10 | Shared Service Identity      | Multiple services share App Registration | No traceability; larger blast radius | One App Registration per service                                                             |
| 11 | Missing Role Validation      | Token validated but roles ignored        | Full access to all services          | Enforce role presence; fail closed                                                           |
| 12 | Internal Trust Assumption    | Implicit trust inside cluster            | Lateral movement                     | Enforce JWT validation for all internal calls                                                |
| 13 | Secret in Kubernetes YAML    | Plain-text secret exposure               | Credential compromise                | Use external secret manager; avoid committing secrets                                        |
| 14 | Lack of Logging              | No audit trail                           | Incident investigation difficult     | Log caller App ID, roles, endpoint, decision                                                 |
| 15 | Long-Lived Credentials       | Secrets valid for years                  | High exposure window                 | Enforce expiration; automate rotation                                                        |
| 16 | Cross-Environment Token Use  | Dev token used in Prod                   | Unauthorized cross-env access        | Separate App Registrations per environment                                                   |
| 17 | Token Size Bloat             | Excessive claims                         | Gateway/header rejection             | Prefer App Roles over group claims                                                           |
| 18 | Inefficient Token Validation | Heavy CPU usage                          | Performance degradation              | Cache JWKS; use efficient JWT libraries                                                      |
| 19 | No Rate Limiting             | Compromised service floods API           | DoS risk                             | Apply gateway rate limiting                                                                  |
| 20 | Insecure Transport           | HTTP used internally                     | Token interception                   | Enforce HTTPS or mTLS                                                                        |
| 21 | Compromised Calling Service  | Service A compromised                    | Valid malicious token requests       | Runtime security; network policies; isolate workloads                                        |
| 22 | Role Misassignment           | Wrong role assigned                      | Unauthorized access                  | Change control process; peer review role assignments                                         |
| 23 | Missing Claim Validation     | `appid` not validated                    | Caller ambiguity                     | Validate calling application ID                                                              |
| 24 | Expired Token Accepted       | Expired JWT allowed                      | Replay attack                        | Strict expiry validation; minimal clock skew                                                 |
| 25 | No Monitoring                | Failed validations ignored               | Attacks undetected                   | Monitor JWT failures; alert on anomaly spikes                                                |


| Control                     | Implementation                   |
| --------------------------- | -------------------------------- |
| Unique identity per service | Dedicated Entra App Registration |
| Token-based authentication  | OAuth 2.0 Client Credentials     |
| Role-based authorization    | Entra App Roles                  |
| Audience validation         | Enforced in API                  |
| Issuer validation           | Enforced in API                  |
| Encrypted transport         | HTTPS / mTLS                     |
| Secure secret storage       | GCP Secret Manager               |
| Audit logging               | Centralized logging system       |





6. Recommended Security Baseline

Minimum production baseline:

One App Registration per service

Strict JWT validation (signature, issuer, audience, expiry)

Enforced role validation

Secure secret storage

Token caching enabled

Centralized logging and monitoring

Least privilege role assignments

