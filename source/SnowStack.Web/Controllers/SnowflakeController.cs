using System;
using System.Data;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Snowflake.Data.Client;

namespace Snowflake.Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SnowflakeController : Controller
    {
        private readonly IConfiguration _configuration;

        public SnowflakeController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public async Task<IActionResult> GetData()
        {
            var connString = _configuration.GetConnectionString("Snowflake");
            using var conn = new SnowflakeDbConnection();
            conn.ConnectionString = connString;
            conn.Open();

            var sql = @"select * 
                          from COVID19_BY_STARSCHEMA.PUBLIC.metadata";

            using var cmd = conn.CreateCommand();
            cmd.CommandText = sql;
            using var reader = await cmd.ExecuteReaderAsync();

            var table = new DataTable();
            table.Load(reader);

            var options = new JsonSerializerOptions
            {
                Converters = { new DataTableConverter() },
                WriteIndented = true
            };
            var data = JsonSerializer.Serialize(table, options);
            return new ObjectResult(data);
        }
    }


    public class DataTableConverter : JsonConverter<DataTable>
    {
        public override DataTable Read(ref Utf8JsonReader reader, Type typeToConvert,
            JsonSerializerOptions options)
        {
            throw new NotImplementedException();
        }

        public override void Write(Utf8JsonWriter writer, DataTable value,
            JsonSerializerOptions options)
        {
            writer.WriteStartArray();

            foreach (DataRow row in value.Rows)
            {
                writer.WriteStartObject();
                foreach (DataColumn column in row.Table.Columns)
                {
                    object columnValue = row[column];

                    // If necessary:
                    if (options.IgnoreNullValues)
                    {
                        // Do null checks on the values here and skip writing.
                    }

                    writer.WritePropertyName(column.ColumnName);
                    JsonSerializer.Serialize(writer, columnValue, options);
                }
                writer.WriteEndObject();
            }

            writer.WriteEndArray();
        }
    }
}