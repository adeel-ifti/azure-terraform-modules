# GCP Kubernetes - Hashi Vault with Bucket as backend and KMS for encryption

Create GCP Storage bucket for vault backend:

```bash
gsutil mb gs://vault-data-bucket
```

Creating symmetric keys

```bash
gcloud kms keyrings create vault-backend-testring   --location global
```

Create GCP kms key using above keyring:

```bash
gcloud kms keys create vault-backend-testkey \
  --location global \
  --keyring vault-backend-testring \
  --purpose encryption \
  --rotation-period  365d \
  --next-rotation-time 2021-01-01
```

# GCP Kubernetes - Installing Hashi Vault Helm Chart (Banzai Cloud provided)

We are using Banzai Cloud provided chart but same works for official Hashi Vault Docker image as well. Banzai has good support on github with quick responses and has been production tested for couple of years. 

```bash
git clone https://github.com/banzaicloud/bank-vaults.git
cd bank-vaults/charts/
```

Install the chart providing with GCP storage bucket and KMS:

```bash
helm install vault \
--set "vault.customSecrets[0].secretName=google" \
--set "vault.customSecrets[0].mountPath=/etc/gcp" \
--set "vault.config.storage.gcs.bucket=vault-data-bucket" \
--set "vault.config.seal.gcpckms.project=prefab-surfer-263006" \
--set "vault.config.seal.gcpckms.region=global" \
--set "vault.config.seal.gcpckms.key_ring=vault-backend-testring" \
--set "vault.config.seal.gcpckms.crypto_key=vault-backend-testkey" \
--set "unsealer.args[0]=--mode" \
--set "unsealer.args[1]=google-cloud-kms-gcs" \
--set "unsealer.args[2]=--google-cloud-kms-key-ring" \
--set "unsealer.args[3]=vault-backend-testring" \
--set "unsealer.args[4]=--google-cloud-kms-crypto-key" \
--set "unsealer.args[5]=vault-backend-testkey" \
--set "unsealer.args[6]=--google-cloud-kms-location" \
--set "unsealer.args[7]=global" \
--set "unsealer.args[8]=--google-cloud-kms-project" \
--set "unsealer.args[9]=prefab-surfer-263006" \
--set "unsealer.args[10]=--google-cloud-storage-bucket" \
--set "unsealer.args[11]=vault-data-bucket" \
--name vault
```

This will install Vault pod with 4 containers as shown below:

<picture>

Copying vault root token from Storage Bucket:

```bash
gsutil copy gs://vault-data-bucket/vault-root .
```

Decrypting vault root token:

```bash
gcloud kms decrypt \
    	--key=vault-backend-testkey \
    	--keyring=vault-backend-testring \
    	--location=global \
    	--ciphertext-file=vault-root \
    	--plaintext-file=vault-root
```

<picture>