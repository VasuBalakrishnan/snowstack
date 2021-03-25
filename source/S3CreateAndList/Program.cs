using System;
using System.Threading.Tasks;
using Amazon;
using Amazon.Runtime.CredentialManagement;
using Amazon.S3;
using Amazon.S3.Model;

namespace S3CreateAndList
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var client = new AmazonS3Client();

            if (GetBucketName(args, out var bucketName))
            {
                try
                {
                    var resp = await client.PutBucketAsync(bucketName);
                    Console.WriteLine($"result: {resp.HttpStatusCode.ToString()}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error creating bucket");
                    Console.WriteLine(ex.Message);
                }

                var listResponse = await client.ListBucketsAsync();
                foreach (var b in listResponse.Buckets)
                {
                    Console.WriteLine($"bucket => {b.BucketName}");
                }

            }
        }

        private static bool GetBucketName(string[] args, out string bucketName)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No args specified");
                bucketName = "";
                return false;
            }

            bucketName = args[0];
            return true;
        }
    }
}
