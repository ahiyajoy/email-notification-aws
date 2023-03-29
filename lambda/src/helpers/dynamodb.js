import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";
const config = { region: "us-east-1" };

export const params = {
  TableName: "NotificationApp",
};

const ddbClient = new DynamoDBClient(config);

export const getTableItems = async () => {
  try {
    const data = await ddbClient.send(new ScanCommand(params));
    const unmarshalled = data.Items.map((i) => unmarshall(i));
    return unmarshalled;
  } catch (err) {
    console.log("Error", err);
  }
};
