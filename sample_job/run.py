import os
import sys
from urllib.parse import urlsplit

import numpy as np
import pandas as pd
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

SEED = 42


def task_generate_sample_data():
    random = np.random.RandomState(seed=SEED)

    customer_ids = np.arange(1, 10000)
    years = np.arange(2010, 2019)
    months = np.arange(1, 13)
    days = np.arange(0, 28)

    n = len(customer_ids) * len(years) * len(months) * len(days)
    sales = random.random_sample(n) * 100

    out = np.meshgrid(customer_ids, years, months, days, [0])
    out = np.array(out).T.reshape(-1, 5)
    out[:, 4] = sales

    # write to parquet file in local working directory
    folder = os.getenv("AZ_BATCH_TASK_WORKING_DIR", "/tmp")
    out_path = folder + "/sales.parquet"
    out = pd.DataFrame(out, columns=["customer_id", "year", "month", "day", "sales"])
    out.to_parquet(out_path)
    print("Sample data saved to: " + folder)

    # upload to blob store
    job_id = os.environ["AZ_BATCH_JOB_ID"]
    task_id = os.environ["AZ_BATCH_TASK_ID"]
    remote_path = f"runs/{job_id}/{task_id}/sales.parquet"
    upload_blob(out_path, remote_path)


def upload_blob(local_path, remote_path):
    blob_uri = os.environ["BLOB_URI"]
    credential = DefaultAzureCredential()

    uri = urlsplit(blob_uri)
    account_url = f"{uri.scheme}://{uri.netloc}/"
    container = uri.path.strip("/")
    service = BlobServiceClient(account_url=account_url, credential=credential)
    remote_path = remote_path.strip("/")
    blob = service.get_blob_client(container, remote_path)
    with open(local_path, "rb") as data:
        blob.upload_blob(data)


if __name__ == "__main__":
    if sys.argv[1] == "task_generate_sample_data":
        task_generate_sample_data()
