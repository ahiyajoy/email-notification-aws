import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
// Set the AWS Region.
const REGION = "us-east-1";
// Create SES service object.
const sesClient = new SESClient({ region: REGION });

const createSendEmailCommand = (toAddress, message) => {
  return new SendEmailCommand({
    Destination: {
      /* required */
      CcAddresses: [
        /* more items */
      ],
      ToAddresses: [
        toAddress,
        /* more To-email addresses */
      ],
    },
    Message: {
      /* required */
      Body: {
        /* required */
        Html: {
          Charset: "UTF-8",
          Data: message,
        },
        Text: {
          Charset: "UTF-8",
          Data: message,
        },
      },
      Subject: {
        Charset: "UTF-8",
        Data: "Subscription expiry notice",
      },
    },
    Source: "ahiyajoy@gmail.com",
    ReplyToAddresses: [
      /* more items */
    ],
  });
};

export const sendEmail = async (emailId, message) => {
  const sendEmailCommand = createSendEmailCommand(emailId, message);

  try {
    return await sesClient.send(sendEmailCommand);
  } catch (e) {
    console.log(e);
    console.error("Failed to send email.");
    return e;
  }
};
