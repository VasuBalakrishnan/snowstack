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
            // var options = new CredentialProfileOptions
            // {
            //     AccessKey = "AKIA3TQLPOGGNR3QZHVS",
            //     SecretKey = "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"
            // };

            // var profile = new CredentialProfile("shared_profile", options);
            // profile.Region = RegionEndpoint.USEast1;

            // var sharedFile = new SharedCredentialsFile();
            // sharedFile.RegisterProfile(profile);

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
